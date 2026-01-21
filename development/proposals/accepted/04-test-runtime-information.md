# Test Runtime Information

```
Status:   Draft (Revision 1)
Project:  make-bowerbird-test
Created:  2026-01-21
Author:   Bowerbird Team
```

---

## Summary

This proposal adds **runtime information tracking** to the test framework, capturing execution time for individual tests and test suites. This information helps identify performance bottlenecks, slow tests, and provides valuable metrics for continuous integration and test optimization.

**Key Features:**
- **Per-Test Timing**: Records start and end time for each test
- **Suite-Level Timing**: Tracks total execution time for test suites
- **Minimal Overhead**: Uses shell built-in `date` command for timing
- **Backwards Compatible**: Works with existing test infrastructure
- **Always Visible**: Timing information displayed in all test output

**Benefits:**
- Identify slow tests that need optimization
- Track test performance over time
- Provide metrics for CI/CD dashboards
- Help developers prioritize test improvements
- Debug parallel execution performance

---

## Problem

The current test framework provides excellent test discovery, execution, and result reporting, but lacks visibility into test execution time:

1. **No Performance Visibility**: Cannot identify which tests are slow
2. **Difficult to Optimize**: No data to guide optimization efforts
3. **CI/CD Blind Spots**: Cannot track test performance trends
4. **Parallel Execution Opacity**: Cannot see timing benefits of parallel runs
5. **Debug Challenges**: Hard to diagnose unexpected slowdowns

**Example scenarios:**
- Developer adds a test that takes 30 seconds but doesn't realize it
- Test suite slows down over time without clear indication of which tests are responsible
- CI builds timeout but no clear indication which tests are consuming time
- Parallel execution improvements are hard to measure

---

## Design

### Core Mechanism: Timestamp Files

The solution uses timestamp files to track test start and end times with minimal overhead:

```makefile
# Capture start time
__test-wrapper/$suite/$test:
	@date +%s > $(WORKDIR_RESULTS)/$test.start
	# ... existing test execution ...
	@date +%s > $(WORKDIR_RESULTS)/$test.end
```

**Why this works:**
- `date +%s` returns Unix epoch time (seconds since 1970-01-01)
- File-based approach works with parallel execution
- No process instrumentation required
- Survives test failures

### Runtime Information Files

Per-test timing files (cleaned before each test run):

1. **`.start` files**: Unix timestamp when test begins
2. **`.end` files**: Unix timestamp when test completes
3. **`.time` files**: Human-readable duration (computed from start/end)

Suite-level timing files:

4. **`.suite.start` files**: Unix timestamp when suite begins
5. **`.suite.wall.time` files**: Wall clock duration (actual elapsed time)
6. **`.suite.cumulative.time` files**: Cumulative duration (sum of all test times)

```bash
# Example per-test file contents
$ cat test-example.start
1737504123

$ cat test-example.end
1737504125

$ cat test-example.time
2s

# Example suite file contents
$ cat test-suite.suite.wall.time
8s

$ cat test-suite.suite.cumulative.time
15s
```

**Cleanup behavior**: All timing files are removed before each test execution to prevent stale data. Consider throwing an error if timing files exist when a test starts (indicates incomplete cleanup from previous run).

### Enhanced Test Output

The test output includes timing information:

```
Passed: test-compare-strings (0.5s)
Passed: test-compare-sets (1.2s)
Failed: test-mock-output (2.3s)

Passed: test-suite: 45/46 passed in 8.3s (wall) / 15.2s (cumulative)
```

The suite timing shows:
- **Wall clock time**: Actual elapsed time (8.3s) - accounts for parallel execution
- **Cumulative time**: Sum of all test times (15.2s) - shows parallelism efficiency

### File Structure

```
.bowerbird/
└── test-suite/
    ├── test-example.log            # Existing: test output
    ├── test-example.pass           # Existing: pass marker
    ├── test-example.start          # NEW: start timestamp
    ├── test-example.end            # NEW: end timestamp
    ├── test-example.time           # NEW: computed duration
    ├── test-suite.suite.start      # NEW: suite start timestamp
    ├── test-suite.suite.wall.time  # NEW: suite wall clock duration
    └── test-suite.suite.cumulative.time  # NEW: suite cumulative duration
```

---

## Implementation Details

### Constants

Add new file extension constants:

```makefile
# Constants (add to existing constants)
bowerbird-test.constant.ext-start = start
bowerbird-test.constant.ext-end = end
bowerbird-test.constant.ext-time = time
```

### Modified Test Wrapper Pattern

Enhance the generated pattern rule to capture timing:

```makefile
__test-wrapper/$suite/%:
	@mkdir -p $(dir $(WORKDIR_RESULTS)/$$*.$$(ext-log))
	@# Clean up any existing timing files (error if they exist?)
	@rm -f $(WORKDIR_RESULTS)/$$*.$$(ext-start) \
	       $(WORKDIR_RESULTS)/$$*.$$(ext-end) \
	       $(WORKDIR_RESULTS)/$$*.$$(ext-time)
	@date +%s > $(WORKDIR_RESULTS)/$$*.$$(ext-start)
	@($(MAKE) $$* \
	    --debug=v \
	    --warn-undefined-variables \
	    $(process-tag) \
	    >$(WORKDIR_RESULTS)/$$*.$$(ext-log) 2>&1 && \
	  # ... existing undefined variable detection ... && \
	  ( \
	    date +%s > $(WORKDIR_RESULTS)/$$*.$$(ext-end) && \
	    START=$$$$(cat $(WORKDIR_RESULTS)/$$*.$$(ext-start)) && \
	    END=$$$$(cat $(WORKDIR_RESULTS)/$$*.$$(ext-end)) && \
	    DURATION=$$$$((END - START)) && \
	    printf "%ss\n" "$$$$DURATION" > \
	      $(WORKDIR_RESULTS)/$$*.$$(ext-time) && \
	    printf "\e[1;32mPassed:\e[0m $$* ($$$$DURATION\s)\n" && \
	    printf "\e[1;32mPassed:\e[0m $$* ($$$$DURATION\s)\n" > \
	      $(WORKDIR_RESULTS)/$$*.$$(ext-pass) \
	  )) || \
	(\
	  date +%s > $(WORKDIR_RESULTS)/$$*.$$(ext-end) && \
	  START=$$$$(cat $(WORKDIR_RESULTS)/$$*.$$(ext-start)) && \
	  END=$$$$(cat $(WORKDIR_RESULTS)/$$*.$$(ext-end)) && \
	  DURATION=$$$$((END - START)) && \
	  printf "%ss\n" "$$$$DURATION" > \
	    $(WORKDIR_RESULTS)/$$*.$$(ext-time) && \
	  printf "\e[1;31mFailed: $$*\e[0m ($$$$DURATION\s)\n" && \
	  printf "\e[1;31mFailed: $$*\e[0m ($$$$DURATION\s)\n" > \
	    $(WORKDIR_RESULTS)/$$*.$$(ext-fail) && \
	  # ... existing error handling ...
	)
```

### Suite-Level Timing

Capture suite start/end time and compute both wall clock and cumulative duration:

```makefile
# In bowerbird::test::suite main target
.PHONY: $1
$1: __suite-start/$1 $(test-dependencies)
	# ... existing result collection ...
	@SUITE_START=$$(cat $(workdir-results)/$1.suite.start) && \
	  SUITE_END=$$(date +%s) && \
	  WALL_TIME=$$((SUITE_END - SUITE_START)) && \
	  printf "%ss\n" "$$WALL_TIME" > \
	    $(workdir-results)/$1.suite.wall.time
	@CUMULATIVE=0; \
	  for f in $(workdir-results)/$1/*.$$(ext-time); do \
	    [ -f "$$f" ] || continue; \
	    TIME=$$(cat "$$f"); \
	    CUMULATIVE=$$((CUMULATIVE + TIME)); \
	  done; \
	  printf "%ss\n" "$$CUMULATIVE" > \
	    $(workdir-results)/$1.suite.cumulative.time
	@WALL=$$(cat $(workdir-results)/$1.suite.wall.time) && \
	  CUMUL=$$(cat $(workdir-results)/$1.suite.cumulative.time) && \
	  printf "\e[1;32mPassed: $1: %s/%s passed in %ss (wall) / %ss (cumulative)\e[0m\n\n" \
	    "$(num-passed)" \
	    "$(num-total)" \
	    "$$WALL" \
	    "$$CUMUL"

.PHONY: __suite-start/$1
__suite-start/$1:
	@mkdir -p $(workdir-results)
	@date +%s > $(workdir-results)/$1.suite.start
```

### Optional: Runtime Report Target

Add a new target to display timing information:

```makefile
# bowerbird::test::runtime-report, suite-name
#
#   Displays runtime information for all tests in a suite
#
#   Args:
#       suite-name: Name of the test suite
#
#   Example:
#       make test-runtime-report-my-suite
#
define bowerbird::test::runtime-report # suite-name
.PHONY: test-runtime-report-$1
test-runtime-report-$1:
	@echo "Runtime Report for: $1"
	@echo
	@find $(workdir-results)/$1 \
		-name '*.$$(ext-time)' \
		-type f | \
	  while read f; do \
	    TEST=$$$$(basename "$$$$f" .$$(ext-time)); \
	    TIME=$$$$(cat "$$$$f"); \
	    printf "  %-50s %10s\n" "$$$$TEST" "$$$$TIME"; \
	  done | sort -k2 -n -r
	@echo
	@if [ -f $(workdir-results)/$1.suite.wall.time ] && \
	    [ -f $(workdir-results)/$1.suite.cumulative.time ]; then \
	  WALL=$$$$(cat $(workdir-results)/$1.suite.wall.time); \
	  CUMUL=$$$$(cat $(workdir-results)/$1.suite.cumulative.time); \
	  printf "Suite Total: %s (wall) / %s (cumulative)\n" "$$$$WALL" "$$$$CUMUL"; \
	else \
	  echo "Suite timing not available"; \
	fi
endef
```

---

## Performance Impact

### Overhead Analysis

**Per-Test Overhead:**
- 2x `date +%s` calls: ~1-2ms each = 2-4ms total
- 2x file writes (timestamps): ~1ms each = 2ms total
- 1x computation + file write: ~1ms
- **Total per test: ~5-7ms**

**Suite Overhead:**
- 2x `date +%s` calls: ~2-4ms
- 2x file operations: ~2ms
- **Total per suite: ~4-6ms**

**Impact on typical test suite:**
- 100 tests * 7ms = 700ms overhead
- If tests average 100ms each = 10s total runtime
- **Overhead: ~7% for fast tests, <1% for slower tests**

This overhead is acceptable given the value of the timing information.

### Optimization Opportunities

Future optimizations if needed:
1. Batch timestamp writes
2. Use arithmetic instead of file I/O for duration calculation
3. Make timing optional via compile-time flag

---

## Backwards Compatibility

This change is fully backwards compatible:

1. **No Breaking Changes**: Existing test definitions work unchanged
2. **File Addition Only**: Only adds new files, doesn't modify existing ones
3. **Enhanced Output**: Test output now includes timing, but remains readable
4. **Gradual Adoption**: Projects can adopt timing features incrementally

---

## Testing Strategy

### Test Coverage

1. **Basic Timing Tests**
   - Verify `.start` files are created
   - Verify `.end` files are created
   - Verify `.time` files contain valid durations
   - Verify timing works for passing tests
   - Verify timing works for failing tests
   - Verify cleanup removes old timing files before test runs

2. **Suite Timing Tests**
   - Verify suite `.suite.start` files are created
   - Verify suite `.suite.wall.time` files are created
   - Verify suite `.suite.cumulative.time` files are created
   - Verify wall clock time ≤ cumulative time (accounting for parallelism)
   - Verify cumulative time = sum of individual test times

3. **Parallel Execution Tests**
   - Verify timing works with parallel test execution
   - Verify no race conditions in timestamp writing
   - Verify wall clock time < cumulative time when tests run in parallel
   - Verify parallelism efficiency calculation is correct

4. **Cleanup Tests**
   - Verify old timing files are removed before test runs
   - Verify no stale timing data from previous runs
   - Consider: Test error handling if timing files exist at test start

5. **Edge Cases**
   - Tests that complete in <1 second (duration = 0s)
   - Tests that take multiple seconds
   - Tests that fail immediately
   - Empty test suites
   - Single-test suites (wall ≈ cumulative)

### Test Implementation

```makefile
# test/bowerbird-test/test-runtime-timing.mk

# Test: Start timestamp file is created
test-runtime-start-file-created:
	# Run a simple test and verify .start file exists
	# ...

# Test: End timestamp file is created
test-runtime-end-file-created:
	# Run a simple test and verify .end file exists
	# ...

# Test: Duration is computed correctly
test-runtime-duration-computed:
	# Mock test with known duration and verify .time file
	# ...

# Test: Timing works for failed tests
test-runtime-failed-test-timing:
	# Run a failing test and verify timing still works
	# ...

# Test: Suite timing is captured
test-runtime-suite-timing:
	# Run a test suite and verify suite.time file
	# ...
```

---

## Future Enhancements

### Phase 2: Enhanced Timing Features

Once basic timing is stable, consider:

1. **Memory Usage Tracking**
   - Track RSS/VSZ for each test process
   - Identify memory-intensive tests

2. **Timing History**
   - Store timing data across runs
   - Generate trends and graphs
   - Alert on performance regressions

3. **Percentile Statistics**
   - P50, P95, P99 for test suites
   - Identify outlier tests

4. **JSON/CSV Export**
   - Machine-readable timing data
   - Integration with external tools
   - CI/CD dashboard integration

5. **Time Budget Enforcement**
   - Fail tests that exceed time budgets
   - Prevent performance regressions

### Phase 3: Advanced Analytics

1. **Comparative Analysis**
   - Compare timing across branches
   - Identify performance regressions in PRs

2. **Parallel Efficiency Metrics**
   - Measure parallel speedup
   - Identify serialization bottlenecks

3. **Resource Correlation**
   - Correlate timing with system load
   - Account for CI resource variation

---

## Implementation Plan

### Phase 1: Core Timing (This Proposal)

1. **Add constants** for new file extensions
   - `bowerbird-test.constant.ext-start`
   - `bowerbird-test.constant.ext-end`
   - `bowerbird-test.constant.ext-time`

2. **Modify `bowerbird::test::__suite-generate-rules`**
   - Add cleanup of old timing files before test runs
   - Add start timestamp capture
   - Add end timestamp capture
   - Compute and store duration
   - Update output formatting with timing (simple format: `test-name (2s)`)

3. **Add suite-level timing**
   - Capture suite start time
   - Compute wall clock duration (actual elapsed time)
   - Compute cumulative duration (sum of all test times)
   - Display both in final summary: `passed in 8.3s (wall) / 15.2s (cumulative)`

4. **Add tests**
   - Basic timing functionality
   - Wall clock vs cumulative timing
   - Cleanup behavior
   - Parallel execution compatibility
   - Edge cases

5. **Update documentation**
   - Add timing section to README
   - Document new file types
   - Provide examples

### Phase 2: Reporting Tools (Future)

1. **Add `bowerbird::test::runtime-report` macro**
2. **Add timing summary target**
3. **Add timing history tracking**

---

## Examples

### Basic Usage

```makefile
# Run tests with timing (default behavior)
make test

# Example output:
# Passed: test-compare-strings (0.1s)
# Passed: test-compare-sets (0.2s)
# Passed: test-compare-files (1.5s)
#
# Passed: test: 45/45 passed in 8.3s (wall) / 15.2s (cumulative)
```

The output shows:
- Individual test times in parentheses
- Suite wall clock time (actual elapsed: 8.3s)
- Suite cumulative time (sum of all tests: 15.2s)
- Parallelism efficiency: 15.2s / 8.3s ≈ 1.8x speedup

### Identifying Slow Tests

```bash
# Find the slowest tests
find .bowerbird/test -name '*.time' -exec sh -c '
    echo "$(cat {}) {}"
' \; | sort -n -r | head -10

# Example output:
# 5s ./test-integration-full.time
# 3s ./test-mock-complex.time
# 2s ./test-compare-large-files.time
# ...
```

### CI/CD Integration

```yaml
# .github/workflows/test.yml
- name: Run Tests
  run: make test

- name: Generate Timing Report
  run: |
    echo "## Test Timing Report" >> $GITHUB_STEP_SUMMARY
    find .bowerbird -name '*.time' | while read f; do
      test=$(basename "$f" .time)
      time=$(cat "$f")
      echo "- $test: ${time}s" >> $GITHUB_STEP_SUMMARY
    done

- name: Check for Slow Tests
  run: |
    # Fail if any test takes more than 10 seconds
    find .bowerbird -name '*.time' -exec sh -c '
      TIME=$(cat {})
      if [ "$TIME" -gt 10 ]; then
        echo "ERROR: Test {} took ${TIME}s (threshold: 10s)"
        exit 1
      fi
    ' \;
```

---

## Design Decisions

1. **Precision**: Start with seconds
   - Seconds provide sufficient granularity for most tests
   - Portable across BSD and GNU date implementations
   - Millisecond precision can be added later if needed

2. **Cleanup**: Clean timing files on each test run
   - Remove `.start`, `.end`, and `.time` files before each test execution
   - Prevents stale data from previous runs
   - Consider throwing error if timing files exist when test starts (indicates incomplete cleanup)
   - Same cleanup behavior as `.pass`/`.fail` files

3. **Display Format**: Simple seconds format
   - Format: `test-name (2s)`
   - Clean, readable output
   - Consistent with existing test output style

4. **Suite Timing**: Show both wall clock and cumulative time
   - **Wall clock time**: Actual elapsed time from suite start to finish (accounts for parallelism)
   - **Cumulative time**: Sum of all individual test times
   - Display format: `Passed: suite-name: 45/45 passed in 8.3s (wall) / 15.2s (cumulative)`
   - Wall clock shows real performance impact
   - Cumulative helps identify total CPU time and parallelism efficiency

---

## Appendix: Alternative Approaches Considered

### Alternative 1: `time` Command Wrapper

```makefile
# Wrap each test with 'time' command
$(MAKE) time test
```

**Rejected because:**
- Requires parsing `time` output (format varies by shell)
- Clutters test output
- Harder to extract programmatically

### Alternative 2: Make Variables

```makefile
TEST_START_TIME := $(shell date +%s)
# ... run test ...
TEST_END_TIME := $(shell date +%s)
```

**Rejected because:**
- Variables evaluated at parse time, not runtime
- Doesn't work with parallel execution
- Can't survive test failures

### Alternative 3: External Instrumentation

```bash
# External wrapper script
./run-tests-with-timing.sh
```

**Rejected because:**
- Requires external tooling
- Not integrated with Make
- Harder to maintain

### Alternative 4: Builtin Make Timing

```makefile
.RECIPEPREFIX = >
test:
>   @time $(MAKE) actual-test
```

**Rejected because:**
- `time` output goes to stderr, pollutes logs
- Inconsistent across Make versions
- No structured data capture

---

## References

- [GNU Make Manual: Target-Specific Variables](https://www.gnu.org/software/make/manual/html_node/Target_002dspecific.html)
- [POSIX date command](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/date.html)
- [Proposal 01: Mock Shell Testing Framework](./01-mock-shell-testing.md)
- [Bowerbird Test Suite Documentation](../../README.md)
