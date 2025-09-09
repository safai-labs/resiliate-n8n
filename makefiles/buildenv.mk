mkutils.shtools.mkshadow=$(mkutils.shtools) mkshadow -e '\.history'

define --mkutils-gen-builddir
	(srcdir="$(1)"; builddir="$(2)"; \
	if [ ! -d "$${srcdir}" ] ; then 								  \
		echo "$${srcdir} does not exist" 1>&2 && exit 127 ; fi 		; \
	$(RM) -r $${builddir}											; \
	$(MKDIR_P) $${builddir}											; \
	cd $${builddir}													; \
	if [ -f $${srcdir}/meson.build ] ; then							  \
		meson . $${srcdir}	&& ninja 								; \
	elif   [ -f $${srcdir}/CMakeList.txt ]; then 					  \
		cmake $${srcdir}   	 										; \
	elif [ -x $${srcdir}/configure ]; then 							  \
		echo $${srcdir}/configure $(call --mkutils.get.autoconf.flags)	; \
		$${srcdir}/configure $(call --mkutils.get.autoconf.flags)		; \
	elif [ -f $${srcdir}/Makefile ];  then 							  \
		$(mkutils.shtools.mkshadow) $${srcdir} $${builddir} 		; \
	else													  \
		echo "don't quite know how to make stuff in $(1)"	; \
		exit 126											; \
	fi) || exit
endef

define mkutils-build-c-ish
	$(call --mkutils-gen-builddir,$(1),$(2)); \
	srcdir="$(1)" builddir="$(2)"	; \
  	cd $${builddir} 				&& \
	make $(call --mkutils.autoconf.vars)	&& \
	make $(call --mkutils.autoconf.vars) DESTDIR=$(DESTDIR) install
endef
