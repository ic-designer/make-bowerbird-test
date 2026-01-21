# Constants
WORKDIR_DEPS ?= $(error ERROR: Undefined variable WORKDIR_DEPS)

# Bootstrap bowerbird-core
bowerbird-core.path ?= $(WORKDIR_DEPS)/bowerbird-core
bowerbird-core.url ?= https://github.com/asikros/make-bowerbird-core.git
bowerbird-core.branch ?= main
bowerbird-core.entry ?= bowerbird.mk
$(WORKDIR_DEPS)/bowerbird-loader.mk:
	@curl --silent --show-error --fail --create-dirs -o $@ -L \
https://raw.githubusercontent.com/asikros/make-bowerbird-core/$(bowerbird-core.branch)/bowerbird-loader.mk

include $(WORKDIR_DEPS)/bowerbird-loader.mk

# Load Dependencies using kwargs-based API
$(call bowerbird::core::git-dependency, \
	name=bowerbird-help, \
	path=$(WORKDIR_DEPS)/bowerbird-help, \
	url=https://github.com/asikros/make-bowerbird-help.git, \
	branch=main, \
	entry=bowerbird.mk)

$(call bowerbird::core::git-dependency, \
	name=bowerbird-githooks, \
	path=$(WORKDIR_DEPS)/bowerbird-githooks, \
	url=https://github.com/asikros/make-bowerbird-githooks.git, \
	branch=main, \
	entry=bowerbird.mk)
