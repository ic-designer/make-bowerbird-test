# Constants
WORKDIR_DEPS ?= $(error ERROR: Undefined variable WORKDIR_DEPS)

# Load Bowerbird Dependency Tools
BOWERBIRD_DEPS.MK := $(WORKDIR_DEPS)/BOWERBIRD_DEPS/bowerbird_deps.mk
$(BOWERBIRD_DEPS.MK):
	@curl --silent --show-error --fail --create-dirs -o $@ -L \
https://raw.githubusercontent.com/ic-designer/make-bowerbird-deps/\
a84d91d5d726ab8639b330b453a3d899556b480f/src/bowerbird-deps/bowerbird-deps.mk
include $(BOWERBIRD_DEPS.MK)


# Load Dependencies
$(eval $(call bowerbird::git-dependency,BOWERBIRD_HELP,https://github.com/ic-designer/make-bowerbird-help.git,main,bowerbird.mk))
$(eval $(call bowerbird::git-dependency,BOWERBIRD_GITHOOKS,https://github.com/ic-designer/make-bowerbird-githooks.git,main,bowerbird.mk))
