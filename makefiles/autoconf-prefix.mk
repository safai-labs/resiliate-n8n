# configure target directory variables for use with
# makefiles.  Also provides a SED script to generate replacements
# using foo formatting


export prefix = /usr
export cefsroot:=$${prefix}/lib/${PACKAGE_NAME}/${PACKAGE_VERSION}
export datarootdir:=$${prefix}/share
export datadir:=$${prefix}/share/${PACKAGE_NAME}/${PACKAGE_VERSION}
export bindir:=$${cefsroot}/bin
export sbindir:=$${cefsroot}/sbin
export libdir:=$${cefsroot}/lib
export libexecdir:=$${cefsroot}/libexec
export docdir:=$${datadir}/docs
export pdfdir:=$${datadir}/docs/pdf
export mandir:=$${datadir}/man
export sysconfdir:=$${cefsroot}/etc/$(PACKAGE_NAME)
export localstatedir:=$${prefix}/var/run
export logdir:=$${prefix}/var/log/$(PACKAGE_NAME)
export syslibdir=$${prefix}/var/lib/$(PACKAGE_NAME)
export localedir:=$${datarootdir}/locale

mkutils.autoconf.ATVARS := prefix \
  bindir sbindir libdir libexecdir cefsroot \
  docdir pdfdir mandir \
  sysconfdir localstatedir logdir syslibdir localedir

mkutils.autoconf.DIRVARS := prefix \
  bindir sbindir libdir libexecdir datadir\
  docdir pdfdir mandir \
  sysconfdir localstatedir localedir


ifeq ($(prefix),/)
  export sysconfdir:=/etc/$(PACKAGE_NAME)
  export localstatedir:=/var/run/$(PACKAGE_NAME)
  export logdir:=/var/log/$(PACKAGE_NAME)
endif

ifeq ($(prefix),/usr)
  export sysconfdir:=/etc/$(PACKAGE_NAME)
  export localstatedir:=/var/run/$(PACKAGE_NAME)
  export logdir:=/var/log/$(PACKAGE_NAME)
  export syslibdir:=/var/lib/$(PACKAGE_NAME)
endif

DESTDIR_LIST=$(DESTDIR) 		\
  $(DESTDIR)$(cefsroot)/{bin,sbin,lib,libexec}	\
  $(DESTDIR)$(prefix) 			\
  $(DESTDIR)$(bindir) 			\
  $(DESTDIR)$(libdir) 			\
  $(DESTDIR)$(libexecdir)		\
  $(DESTDIR)$(sysconfdir) 		\
  $(DESTDIR)$(cefsroot)/{scripts,extra}

$(DESTDIR_LIST): ; eval prefix=$(prefix) cefsroot=$(cefsroot) $(--mkutils-mkdir-p) $@

PHONY += mkutils.autoconf.destdirs
mkutils.autoconf.destdirs: $(DESTDIR_LIST)

destdirs: mkutils.autoconf.destdirs

$(foreach v, $(mkutils.autoconf.ATVARS), \
  $(eval $(call --mkutils-add-at-var,$(v))))

define --mkutils.get.autoconf.vars
  $(foreach v,  $(mkutils.autoconf.ATVARS), $(v)=$(value $(v)))
endef

define --mkutils.get.autoconf.flags
  $(foreach v,$(mkutils.autoconf.DIRVARS), --$(v)=$(value $(v)))
endef


PHONY += test-autoconf.vars
test-autoconf.vars:
	@echo $(call --mkutils.get.autoconf.vars)
	@echo $(call --mkutils.get.autoconf.flags)
