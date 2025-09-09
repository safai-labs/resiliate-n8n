# filetype: make
# set verbosity to 1 to show the commands,
SHELL=/bin/bash

--mkutils-sed 		:= sed
--mkutils-tar		:= tar
--mkutils-mkdir-p	:= mkdir -p
--mkutils-grep := grep

_VARS=
QQ=@

# Used to calculate separation between left and right on help and showvars
DIVCOL=32

define --mkutils-requote
  $(subst ',{%squot}, $(subst ",{%dquot}, $(1)))
endef

define qsay
    $(call say,'$(call --mkutils-requote,$(1))') | $(--mkutils-sed) -E \
        -e "s|\{%squot\}|'|g" \
        -e 's|\{%dquot\}|"|g'
endef

define say
	(echo -ne $(1) | $(--mkutils-sed) -E \
    -e 's#((\{%(red|green|yellow|blue|magenta|cyan|white|reset|b|u)\}+))[[]{2}(.*)[]]{2}#\1\4{%reset}#g' \
    -e "s|\{%red\}|$$(tput setaf 1)|g" \
    -e "s|\{%green\}|$$(tput setaf 2)|g" \
    -e "s|\{%yellow\}|$$(tput setaf 3)|g" \
    -e "s|\{%blue\}|$$(tput setaf 4)|g" \
    -e "s|\{%magenta\}|$$(tput setaf 5)|g" \
    -e "s|\{%cyan\}|$$(tput setaf 6)|g" \
    -e "s|\{%white\}|$$(tput setaf 7)|g" \
    -e "s|\{%r(eset)?\}|$$(tput sgr0)|g" \
    -e "s|\{%b(old)?\}|$$(tput bold)|g" \
    -e "s|\{%u(nderline)\}|$$(tput sgr 0 1)|g") 
endef

# define say_var_value
#   $(call say, $(call requote,$(value $(1))))
# endef

define --mkutils-show-var
	$(call say,"{%b}{%cyan}[[$(1)]]");
	(printf "%$$(($(DIVCOL) - $$(echo $(1) | wc -c)))s" "= ");
	$(call qsay,{%yellow}{%b}[{%reset}$(subst {%dollar},$$,$(value $(1))){%yellow}{%b}]{%reset});
  (echo);
endef

define --mkutils-show-vars
  echo
  $(if test $V -lt 3 && echo y, \
    $(foreach v,$(filter-out __% @%@,$(_VARS)), \
      $(call --mkutils-show-var,$(v))))
  $(if $(shell test $V -ge 1 -a $V -lt 3 && echo y), \
    echo && $(foreach v,$(filter  @%@,$(_VARS)),\
      $(call --mkutils-show-var,$(v))))
  $(if $(shell test $V -ge 2 -a $V -lt 3 && echo y), \
    echo && $(call --mkutils-show-var,--mkutils-SED-XP))
  $(if $(shell test $V -ge 3 && echo y), \
    echo && $(foreach v, $(filter-out \
      --mkutils-% mkutils-% say qsay required, \
      $(.VARIABLES)), $(call --mkutils-show-var,$(v))))
  echo
endef

define required
  REQUIRED_VARS += $(1)
  _$(1)_helptxt = $(2)
endef

define --mkutils-to-lower
   $(shell echo -n $(1) | tr '[:upper:]' '[:lower:]')
endef

# Subtitution of @foo@ with $(@foo@) using sed in target 
# files, e.g. .in files.

# ON --mkutils-SED-XP behavior:

# When storing things in --mkutils-SED-XP, we replace all $$ with
# {%dollar} and then use a SED expression to revert it 
# Otherwise the variables that are supposed be passed as
# env vars for substiutions (e.g. foo=$${bar}) get prematurely
# expanded.

define --mkutils-decl-at-var =
  $(eval $(1) = $(value @$(1)@))
  _VARS += $(if $(findstring @$(1)@,$(_VARS)),,@$(1)@)
  --mkutils-sed-X := -e 's|@$(1)@|$(subst $$,{%dollar},$(value @$(1)@))|g'
  --mkutils-sed-X += -e 's|{%xp:$(1)}|$(subst $$,{%dollar},$(value @$(1)@))|g'
  --mkutils-SED-XP += $(if $(findstring \
      $(--mkutils-sed-X),$(--mkutils-SED-XP)),, $(--mkutils-sed-X))
endef

# also note that space after the , is important in the definition of SED-XP
# $(subst $$,$$$$,$(value $(1)))
define --mkutils-add-at-var =
  $(eval @$(1)@ =  $(value $(1)))
  _VARS += $(if $(findstring @$(1)@,$(_VARS)),,@$(1)@)
  --mkutils-sed-X := -e 's|@$(1)@|$(subst $$,{%dollar},$(value $(1)))|g'
  --mkutils-sed-X += -e 's|{%xp:$(1)}|$(subst $$,{%dollar},$(value $(1)))|g'
  --mkutils-SED-XP += $(if $(findstring \
    $(--mkutils-sed-X),$(--mkutils-SED-XP)),, $(--mkutils-sed-X))
endef

define mkutils-subst-atvars
	test -n "$(strip $(1))" -a -n "$(strip $(2))"  || \
    (echo mkutils-subst-atvars requires two arguments 1>&2 ; exit 127 )
	$(Q)$(PERL) $(mkutils.toolsdir)/resolver.pl $(1) | \
     	$(--mkutils-sed) $(--mkutils-SED-XP) -e 's/{%dollar}/$$/g' > $(2)
endef

define mkutils-subst-atvars-for-find
  $(Q)$(PERL) $(mkutils.toolsdir)/resolver.pl $(1) | $(--mkutils-sed) $(--mkutils-SED-XP) -e 's/{%dollar}/$$/g' > $$(echo $(2) | sed s,\.in$$,,) \
      && chmod --reference=$(1) $$(echo $(2) | sed s,\.in$$,,)
endef


define --mkutils-display-help
	( printf '%8s' ""; width=65; \
		$(call say,"{%b}{%cyan}[[$(1)]]") ; \
		DIVCOL=$(DIVCOL) ; \
		printf "%$$((DIVCOL - $$(echo $(1) | wc -c) - 2))s" " - " ; \
		c=0; \
		echo -e $(2) | fold -s -w $${width} | \
			while read l ; do \
				let c=c+1; \
				[ $$c -gt 1 ] && printf "%$$((DIVCOL+ 5))s"; \
				$(call say,"{%b}{%white}$${l}{%reset}\\n"); \
			done; )
endef


define --mkutils-var-help
$$([ "$(value $(1))" = "" ] && \
    echo -n '<{%cyan}$(call --mkutils-to-lower,$(1)){%reset}>' || \
    echo -n '{%cyan}{%b}$(value $(1)){%reset}')
endef

define mkutils-needs-var
    if [ "$(value $(1))" = "" -o "$(origin $(1))" = "file" ]; then \
      missing="$${missing}$${missing:+" "}$(1)" ; \
    else \
      $(call say,"{%green}{%b}[[$(1)]]={%white}{%b}$(value $(1)){%reset}\\n"); \
    fi;
endef

define mkutils-needs
  (missing=; $(foreach v,$(1),$(call mkutils-needs-var,$(v))) \
	missing="$$(echo $$missing)"; \
	  test -z "$${missing}" && exit 0 ; \
      err="\n\t{%yellow}{%b}$(MAKE) {%white}$(MAKECMDGOALS){%reset}"; \
	  err="$${err} requires {%red}{%b}$${missing}{%reset}.\\n\\n"; \
      err="$${err}For example:\\n\\n\\t{%b}{%yellow}[[make{%reset}]]"; \
      err="$${err}$(MAKEFLAGS) {%white}$(MAKECMDGOALS){%reset}"; \
      err="$${err}"; \
      $(foreach v,$(1),err="$${err} {%cyan}{%b}$(v){%reset}=$(call --mkutils-var-help,$(v))"; ) err="$${err}\\n\\n"; \
      $(call say,$${err}) ; exit 1 )
endef


PHONY += mkutils.upgrade-shtools

# Upgrade shell tools in tools/ director
mkutils.upgrade-shtools:
	shtoolize -q -o $(mkutils.toolsdir)/shtools all


### Show internal variables (V=1 for @vars@ and V=2 for internal vars)
show-vars:
	$(QQ)$(call --mkutils-show-vars)

SILENT+=show-vars var mkutils-subst-atvars --mkutils-show-vars clean

### Generate a Makefile from a template


### cleans {%v:$(CLEAN_FILES)} after running {%v:$(CLEAN_TARGETS)}
### use show-vars to see the value of ${CLEAN_TARGETS} and ${CLEAN_FILES}
clean: $(CLEAN_TARGETS)
	$(QQ)[ -z "$(CLEAN_FILES)" ] || \
		$(call say,"{%red}$(RM) -r {%white}$(CLEAN_FILES)\n") && \
		$(RM) -r $(CLEAN_FILES)

HELP_G2 += clean

CLEAN_FILES += $(mkutils.makefiledir)/makefile.tar.gz
_VARS += CLEAN_FILES

$(mkutils.makefiledir)/makefile.tar.gz: $(mkutils.makefiledir)/GNUmakefile $(shell echo $(mkutils.toolsdir)/*)
	$(QQ)(cd $(mkutils.makefiledir) && $(--mkutils-tar) fcvz $@ GNUmakefile $(shell basename $(mkutils.toolsdir)))

### Bundle up the makefile templates for a new project
bundle-maketools: $(mkutils.makefiledir)/makefile.tar.gz

PHONY += bundle-maketools $(mkutils.makefiledir)/makefile.tar.gz

#nvim:filetype=makefile
