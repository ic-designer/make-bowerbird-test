# TODO

- It is annoying that it doesn't know how to remove failing test results if a .failed file is left in the test path. Example
test fails, delete the code, and rerun make check. Unless you
run make clean, the test still fails due to the .fail file even if the target is deleted
- ability to select only specific tests
- ~~include some information about how long tests take to run~~ → Implemented! See [Proposal 04: Test Runtime Information](development/proposals/accepted/04-test-runtime-information.md)
- Test wrapper has a lot of repeated statements