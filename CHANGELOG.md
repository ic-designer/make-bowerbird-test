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
- Created internal hooks in preparation for a future `TESTFLAGS` argument
  - `BOWERBIRD_TEST/CONFIG/FAIL_EXIT_CODE` sets the exit code for failing tests.
  - `BOWERBIRD_TEST/CONFIG/FAIL_FAST` helps terminate all the parallel make jobs
    immediately when a test fails.
  - `BOWERBIRD_TEST/CONFIG/FAIL_FIRST` will find failed tests from the previously
    cached test results and try to re-run those failed tests first.
- Added a debugging target to the workflow to help diagnose failed results on the
  remote runners.
### Changed
- Removed the filename pattern argument from the generate-test-runner macro. Patterns
  set using the new configuration macros `bowerbird::test::pattern-test-files` and
  `bowerbird::test::pattern-test-targets`.
- To help with debugging, the test output is now combined into a single log that shows
  both stdout and stderr.
- All macros intended for use outside of target recipes no longer need the pattern
  `$(eval $(call ... ))` and can instead simply use `$(call ...)`.
- Renamed log extension variable from BOWERBIRD_TEST_EXT_LOG to the new name
  BOWERBIRD_TEST/CONSTANT/LOG_EXT in order to better group constants with a common
  prefix.
- Renamed all the internal variables to use a consistent pattern.
- Created series of "action" targets for running the test suite:
  - `bowerbird-test/runner/list-discovered-tests/<target>`
  - `bowerbird-test/runner/clean-results/<target>`
  - `bowerbird-test/runner/run-primary-tests/$<target>`
  - `bowerbird-test/runner/run-secondary-tests/<target>`
  - `bowerbird-test/runner/report-results/<target>`
- Individual test results are now saved to a cache directory organized by target name
  so that reporting and analyzing the tests can performed separately from running the
  tests.
### Deprecated
### Fixed
- Removed flags from MAKEFLAGS unsupported by Make 3.81.
- Fixed a bug causing errors when no test targets were discovered.
- Removed the printed response test since controlling the standard output under all
  scenarios is too hard.
- Fixed bug in how pass and fail are determined when other bugs cause the number of
  targets to be miscounted. Test now fail when a mismatch in the counts is discovered.
- Fixed bug that created duplicate test targets when target specific variables were
  used in a test.
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
