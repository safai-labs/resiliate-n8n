#!/usr/bin/make -f
# General purpose make file.  Use this as a template for everything.


ifeq ($(_GNUmakefile_loaded),)


.DEFAULT_GOAL = help


Q:=@
V=0
ifeq ($(V),1)
Q:=
endif

mkutils.makefiledir  = $(dir $(abspath $(firstword $(MAKEFILE_LIST))))
mkutils.makefiledir := $(shell cd $(mkutils.makefiledir) && pwd)
mkutils.topdir		:= $(shell cd $(mkutils.makefiledir)/.. && pwd)
mkutils.toolsdir	:= $(mkutils.makefiledir)/makefiles

include $(mkutils.makefiledir)/makefiles/utils.mk
include $(mkutils.makefiledir)/makefiles/make-cfg.mk
include $(mkutils.makefiledir)/makefiles/autoconf-prefix.mk
-include $(mkutils.makefiledir)/makefiles/buildenv.mk
-include $(mkutils.makefiledir)/makefiles/git.mk

include $(mkutils.makefiledir)/Makefile

# Include enhanced makefile modules
-include $(mkutils.makefiledir)/makefiles/diagnostics.mk
-include $(mkutils.makefiledir)/makefiles/analytics.mk
-include $(mkutils.makefiledir)/makefiles/dev-tools.mk


$(foreach v,$(mkutils.ATVARS) _, \
	$(eval $(call --mkutils-add-at-var,$(v))))

include $(mkutils.makefiledir)/makefiles/help.mk
#  ALL items below this line MUST appear at the very end
#  of the Makefile parsing (because the values are affected)
#  by other sections.  mkfile_path is needed for help targets

mkfile_path := $(foreach m,$(MAKEFILE_LIST),$(abspath $m))
mkfile_dir := $(dir $(firstword $(MAKEFILE_LIST)))

ifneq ($(shell test -f Makefile && pwd | $(--mkutils-sed) s:^$(mkfile_dir):: || : ),)
 mkfile_path += $(abspath Makefile)
endif


PHONY += $(HELP_G1) $(HELP_G2)
SILENT+= $(HELP_G1) $(HELP_G2)

.SILENT: $(SILENT)

.PHONY: $(PHONY)

$(mkutils.makefiledir)/config.mk:
	$(QQ)test -f $@ || ($(call say,"You forgot to create a {%bold}{%cyan}$@{%reset} file.") && exit 1)

$(mkutils.makefiledir)/Makefile: $(mkutils.makefiledir)/config.mk
	$(QQ)test -f $@ || ($(call say, "You forgot to create a {%bold}{%cyan}$@{%reset}.") && exit 1)

_GNUmakefile_loaded=1
endif # _GNUmakefile_already_loaded
