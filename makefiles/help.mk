# HELP_G[1-2] are used to group help outputs.
# Help groups if you add more groups these for the core then make
# sure to update the help function in help.mk


### Show detailed help messages
help: -mkutils-autogen-help

-mkutils-autogen-help:
	$(QQ)echo
	$(QQ)echo "Usage: make [options] [target] ..."
	$(QQ)echo
	$(QQ)$(--mkutils-sed) -e '/^[[:space:]]*$$/d' $(mkfile_path) | \
	( declare -A HLP; msg=""; \
	while read line ; do 	\
		case "$${line}" in 	\
		'###'*) 			\
			msg="$${msg} $$(echo "$${line}" | 					\
				$(--mkutils-sed) -e 's/^###[ \t]*//g'			\
				-e 's,{%v:\([^}][^}]*\)},{%green}\1{%reset},g'	\
				-e 's,{%xp:[^}][^}]*},{%yellow}\0{%reset},g'	\
				$(--mkutils-SED-XP))"						\
			;;  \
		*:*|*:) \
			if [ "$${#msg}" -gt 0 ] ; then 					\
				key="$$(echo $${line} | sed 's/:.*//')"; 	\
				HLP[$${key}]="$${key}\n$$msg"; 				\
				unset msg; \
			fi; \
			;; 	\
		esac; 	\
	done; \
	HELP_G1="$$(echo $${HELP_G1} | sort )" ; \
	HELP_G2="$$(echo $${HELP_G2} | sort )" ; \
	for k in $(if $(strip ${HELP_G1}), ${HELP_G1} blank) \
			 $(if $(strip ${HELP_G2}), ${HELP_G2} blank) \
			 sep help \
			 $(if $(shell test "$(MAKECMDGOALS)" = "help" \
			 	&& echo -n 't'), $${!HLP[@]}) \
		; do \
		if [ "$$k" = "blank" ] ; then  echo ; continue ; fi ; \
		if [ "$$k" = "sep" ] ; then  printf "%16s\n" \
			"--------"; continue ; fi ; \
		left=$$(echo $${HLP[$$k]} | sed 's/\\n.*//');	\
		right=$$(echo $${HLP[$$k]} | sed 's/.*\\n//'); 	\
		if [ "$${left}" = "" ]; then continue ; fi ; \
		$(call --mkutils-display-help,$${left},$${right}); 	\
		unset HLP[$$k]; \
	done )
	$(QQ)echo

