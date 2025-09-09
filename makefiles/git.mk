# Git functions for package-manager 2.0

GIT=git

define mkutils.git.worktree
	gitdir=$(shell realpath $(1))		; \
	workdir=$(shell basename $(1))		; \
	commitish=$(shell realpath $(2))	; \
	$(--mkutils.mkdir-p) $(workdir) && \
	$(GIT) --git-path=$(gitdir) worktree add $(workdir) $(commitish)
endef


