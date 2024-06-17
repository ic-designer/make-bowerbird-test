# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

```markdown
## [Unreleased] - YYYY-MM-DD

### Added
### Changed
### Deprecated
### Fixed
### Security
```

## [Unreleased] - YYYY-MM-DD

### Added
- Created the `bowerbird::test::pattern-test-files` macro to configure the file pattern
  used during test discovery.
- Created the `bowerbird::test::pattern-test-targets` macro to configure the target
  pattern used during test discovery.
### Changed
- Removed the filename pattern argument from the generate-test-runner macro. Patterns
  read through a global configuration.
- To help with debugging, the test output is now combined into a single log that shows
  both stdout and stderr.
- All macros intended for use outside of target recipes no longer need the pattern
  `$(eval $(call ... ))` and can instead simply use `$(call ...)`.
- Renamed log extension variable from BOWERBIRD_TEST_EXT_LOG to the new name
  BOWERBIRD_TEST/CONSTANT/LOG_EXT in order to better group constants with a common
  prefix.
### Deprecated
### Fixed
- Removed flags from MAKEFLAGS unsupported by Make 3.81.
- Fixed a bug causing errors when no test targets were discovered.
### Security


## [0.1.0] - 2024-06-06

### Added
- Test runner now enables undefined an variable warning and fails when an undefined
  variable is encountered.
- Created macros for comparing strings, sets/lists, files.
- Added tests for checking the printed output from the test runner.
- Added documentation to teh source macros.
### Changed
- Separated the test-runner source files from the comparison macos.
### Fixed
- Removed an unused reference to the obsolete NEWLINE macro.
- Removed  unnecessary comments and newlines from the test files.
