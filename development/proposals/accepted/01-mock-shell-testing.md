# Mock Shell Testing Framework for Make Recipes

```
Status:   Implemented
Project:  make-bowerbird-test
Created:  2026-01-07
Revised:  2026-01-21
Author:   Bowerbird Team
```

> **Implementation Note:** The final implementation uses a static Bash script file
> (`scripts/mock-shell.bash`) that is tracked in version control. This approach
> provides better reliability, easier debugging, and consistent behavior across
> platforms compared to dynamically generated scripts.
> The core concepts and mechanisms described here reflect the actual implementation.

---

## Summary

This proposal introduces a **mock shell framework** for testing Make recipes without
executing their commands. It captures shell commands for verification, allowing unit
testing of recipe logic (variable expansion, conditionals, command construction)
independently of command behavior.

**Key Features:**
- **Target-Specific SHELL Override**: Uses `%: SHELL = ...` pattern to preserve
  `$(shell)` calls during parsing
- **Environment Variable Activation**: Enabled via `BOWERBIRD_MOCK_RESULTS`
- **Parallel Safe**: Each test uses target-specific results files
- **Recursive Make Pattern**: Outer test target invokes inner target with mock mode

**Benefits:**
- Fast, deterministic unit tests for Makefile recipes
- Test edge cases without external tool dependencies
- `$(shell)` calls during parsing work normally (not captured)


## Problem

Testing Make recipes today requires executing actual commands:

1. **Dependency on External Commands**: Tests require git, curl, compilers, etc.
2. **Cannot Test Without Side Effects**: Commands modify filesystem/network
3. **Slow Execution**: Network I/O, compilation take time
4. **Unreliable**: Network failures cause flaky tests
5. **Recipe Logic vs Command Logic**: Testing construction requires execution

**We need to test recipe construction independently of command execution.**


## Design

### Core Mechanism: Target-Specific SHELL

The key insight is using Make's **target-specific variables** with a pattern rule:

```makefile
# When BOWERBIRD_MOCK_RESULTS is set, override SHELL for all targets
ifdef BOWERBIRD_MOCK_RESULTS
%: SHELL = $(BOWERBIRD_MOCK_SHELL)
endif
```

**Why this works:**
- `$(shell ...)` calls happen at **parse time**, before any target builds
- Target-specific variables only affect **recipe execution**
- Therefore, `$(shell)` uses real shell; recipes use mock shell

**Comparison with command-line approach:**
```makefile
# OLD: Passes SHELL to nested make, affects $(shell) calls too
$(MAKE) SHELL=$(MOCK) target

# NEW: SHELL is inherited via pattern rule, $(shell) unaffected
$(MAKE) target
```

### Mock Shell Script

The mock shell is implemented as a static Bash script at `scripts/mock-shell.bash`:

```bash
#!/bin/bash
for __c; do :; done
__c_normalized=$(printf "%s" "$__c" | tr -d '\' | tr -s "[:space:]" " " | sed "s/^ //" | sed "s/ $$//")
if [ "${__BOWERBIRD_MOCK_SHOW_SHELL+set}" = "set" ]; then
  printf "%s %s %s\n" "$__BOWERBIRD_SHELL" "$__BOWERBIRD_SHELLFLAGS" "$__c_normalized" >>"$BOWERBIRD_MOCK_RESULTS"
else
  printf "%s\n" "$__c_normalized" >>"$BOWERBIRD_MOCK_RESULTS"
fi
```

Referenced in `bowerbird-mock.mk`:

```makefile
# Path to static mock shell script
__BOWERBIRD_MOCK_SHELL_SCRIPT := $(dir $(lastword $(MAKEFILE_LIST)))../../scripts/mock-shell.bash

ifdef BOWERBIRD_MOCK_RESULTS
export __BOWERBIRD_SHELL := $(SHELL)
export __BOWERBIRD_SHELLFLAGS = $(value .SHELLFLAGS)
%: SHELL = /bin/bash $(__BOWERBIRD_MOCK_SHELL_SCRIPT)
endif
```

The mock shell:
1. Receives all arguments: `$(SHELL) $(SHELLFLAGS) command`
2. Extracts the last argument (the command) using bash parameter expansion
3. Normalizes line continuations by removing backslashes and collapsing whitespace
4. Appends normalized command to `BOWERBIRD_MOCK_RESULTS` file
5. Optionally captures SHELL and SHELLFLAGS if `__BOWERBIRD_MOCK_SHOW_SHELL` is set
6. Does NOT execute the command

**Key Features:**
- **Static file**: Tracked in version control, no dynamic generation needed
- **Line continuation handling**: Normalizes `\` and whitespace for consistent output
- **Cross-platform compatible**: Works reliably on macOS and Linux
- **Optional shell capture**: Can capture SHELL and SHELLFLAGS for advanced testing

### Test Definition Macro

```makefile
define bowerbird::test::add-mock-test # test-name, target, expected-output, extra-args
$(eval $(call bowerbird::test::__add-mock-test-impl,$(strip $1),$(strip $2),$(strip $3),$4))
endef

define bowerbird::test::__add-mock-test-impl # test-name, target, expected-output, extra-args
.PHONY: $1
$1: SHELL = /bin/sh
$1:
	@mkdir -p $$(WORKDIR_TEST)/$1
	@: > $$(WORKDIR_TEST)/$1/results
	$$(MAKE) -j1 BOWERBIRD_MOCK_RESULTS=$$(WORKDIR_TEST)/$1/results $4 $2
	$$(call bowerbird::test::compare-file-content-from-var,$$(WORKDIR_TEST)/$1/results,$3)
endef
```

**Arguments:**
- `$1`: Test name (e.g., `test-mock-clean`)
- `$2`: Target to test (e.g., `clean`)
- `$3`: Expected output variable name (define block with expected commands)
- `$4`: Optional extra make arguments (e.g., `__BOWERBIRD_MOCK_SHOW_SHELL=`)

**Key Changes:**
- Uses `compare-file-content-from-var` for flexible comparison
- Expected output is a variable name, not inline strings
- Forces sequential execution with `-j1` to prevent parallel issues
- Uses `/bin/sh` as outer shell for deterministic behavior

### Example Usage

```makefile
# Target under test
.PHONY: clean
clean:
	@rm -rf $(WORKDIR)/build
	@echo "Clean complete"

# Expected output as define block
define expected-clean
rm -rf /tmp/build
echo "Clean complete"
endef

# Test definition
$(call bowerbird::test::add-mock-test,\
    test-mock-clean,\
    clean,\
    expected-clean,)
```

**Optional: Capture SHELL and SHELLFLAGS**

```makefile
# Test that also captures which shell is being used
$(call bowerbird::test::add-mock-test,\
    test-mock-with-shell-info,\
    clean,\
    expected-with-shell,\
    __BOWERBIRD_MOCK_SHOW_SHELL=)
```

---

## SHELLFLAGS Compatibility

### The Challenge

Make invokes the shell as: `$(SHELL) $(SHELLFLAGS) command`

The `.SHELLFLAGS` variable can be customized by users or projects:
- **Default:** `.SHELLFLAGS := -c` → `shell -c "command"`
- **Strict mode:** `.SHELLFLAGS := -e -u -c` → `shell -e -u -c "command"`
- **Debug mode:** `.SHELLFLAGS := -xc` → `shell -xc "command"`

A naive mock shell that assumes `$2` is the command will break with multi-flag
configurations:

```sh
# Broken approach
echo "$$2" >> "$BOWERBIRD_MOCK_RESULTS"

# shell -c "cmd"        → $2 = "cmd" ✓
# shell -e -u -c "cmd"  → $2 = "-u" ✗
```

### The Solution: Last-Argument Extraction

The command is **always the last argument**, regardless of flag configuration:

```sh
#!/bin/sh
# Extract command (always last argument after SHELLFLAGS)
eval "COMMAND=\"\$${$$#}\""
echo "$$COMMAND" >> "$${BOWERBIRD_MOCK_RESULTS:?BOWERBIRD_MOCK_RESULTS must be set}"
```

**How it works:**
- `$#` contains the total number of arguments
- `eval "\${$#}"` extracts the value of the last argument
- Works with any `.SHELLFLAGS` configuration

**Compatibility matrix:**

| .SHELLFLAGS | Invocation | Last Arg ($#) | Result |
|-------------|------------|---------------|--------|
| `-c` | `shell -c "cmd"` | `$2 = "cmd"` | ✓ |
| `-e -u -c` | `shell -e -u -c "cmd"` | `$4 = "cmd"` | ✓ |
| `-xc` | `shell -xc "cmd"` | `$2 = "cmd"` | ✓ |
| `-e -u -x -v -c` | `shell -e -u -x -v -c "cmd"` | `$6 = "cmd"` | ✓ |

### Testing SHELLFLAGS

The test suite includes comprehensive `.SHELLFLAGS` coverage:
- Default configuration (`-c`)
- Multiple separate flags (`-e -u -c`)
- Combined flags (`-xc`, `-euc`)
- Many flags (`-e -u -x -v -c`)
- Various flag combinations used in real projects

See [`test/bowerbird-test/test-mock-shellflags.mk`](../../test/bowerbird-test/test-mock-shellflags.mk)
for complete test coverage.

---

## Limitations

### Quote Handling is Fragile

**Problem:** Make strips some quotes before passing to shell. Single quotes in
expected output can break the comparison mechanism.

**Guidance:**
- Prefer double quotes in recipes where possible
- Accept that exact quote preservation is not guaranteed
- For complex quote scenarios, verify manually

**Example of fragility:**
```makefile
# Recipe:
target:
	@echo 'hello'

# May be captured as:
echo hello        # OR
echo 'hello'      # Depends on Make/shell version
```

### What Cannot Be Tested

1. **Command Output Dependencies**: `VAR=$(shell cmd)` in recipes
2. **Exit Code Logic**: `cmd || fallback` — all commands "succeed"
3. **Side Effect Dependencies**: Recipes checking for created files
4. **Shell Built-ins**: Loops, conditionals within single command

### Appropriate Use Cases

- Testing Make variable expansion in recipes
- Testing command construction and argument passing
- Testing conditional recipe generation
- Unit testing recipe logic without side effects

---

## Implementation Plan

### File Changes

1. **`src/bowerbird-test/bowerbird-mock.mk`** (simplify)
   - Remove parse-time `$(shell)` script creation
   - Add `ifdef BOWERBIRD_MOCK_RESULTS` pattern rule
   - Simplify test macro

2. **`src/bowerbird-test/bowerbird-compare.mk`** (no change)
   - Existing comparison macros work as-is

3. **`bowerbird.mk`** (no change)
   - Already includes mock module

### Testing Strategy

Focus tests on:
- Basic command capture (without quotes)
- Variable expansion verification
- Multiple commands in order
- Conditional target generation

Skip or simplify:
- Complex quote scenarios
- Special character edge cases

---

## Appendix: Issues from Previous Implementation

### Issue 1: $(shell) Contamination

**Symptom:** Results file contained parsing-time commands (`git describe`, etc.)

**Cause:** Passing `SHELL=...` on `$(MAKE)` command line affected `$(shell)` calls

**Solution:** Use target-specific `%: SHELL = ...` pattern rule

### Issue 2: Quote Corruption

**Symptom:** Expected file contained corrupted content like `echo single\nquotes`

**Cause:** Single quotes in expected output broke `printf '...'` command

**Solution:** Document as limitation; simplify expected output format

### Issue 3: Script Creation Race

**Symptom:** Mock shell script not found or permissions wrong

**Cause:** Complex parse-time script creation with `$(shell)`

**Solution:** Use simple recipe-based creation; depend on source file

### Issue 4: SHELLFLAGS Compatibility

**Symptom:** Mock shell breaks with non-default `.SHELLFLAGS` (e.g., `-e -u -c`)

**Cause:** Hardcoded `$2` assumes exactly one flag argument before command

**Original broken approach:**
```sh
echo "$$2" >> "$${BOWERBIRD_MOCK_RESULTS:?...}"
# Works with: shell -c "cmd"      (where $2 = "cmd")
# Breaks with: shell -e -u -c "cmd" (where $2 = "-u", $4 = "cmd")
```

**Solution:** Extract last argument using `$#`, which works with any flag configuration

```sh
eval "COMMAND=\"\$${$$#}\""
echo "$$COMMAND" >> "$${BOWERBIRD_MOCK_RESULTS:?...}"
# Works with: shell -c "cmd"        (last arg = "cmd")
# Works with: shell -e -u -c "cmd"  (last arg = "cmd")
# Works with: shell -xc "cmd"       (last arg = "cmd")
```

This approach is robust because Make always invokes: `$(SHELL) $(SHELLFLAGS) command`
The command is always the final argument, regardless of flag count or syntax.
