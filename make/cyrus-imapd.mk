###########################################################
#
# cyrus-imapd
#
###########################################################

CYRUS-IMAPD_SITE=ftp://ftp.andrew.cmu.edu/pub/cyrus-mail
CYRUS-IMAPD_VERSION=2.2.12
CYRUS-IMAPD_SOURCE=cyrus-imapd-$(CYRUS-IMAPD_VERSION).tar.gz
CYRUS-IMAPD_DIR=cyrus-imapd-$(CYRUS-IMAPD_VERSION)
CYRUS-IMAPD_UNZIP=zcat
CYRUS-IMAPD_MAINTAINER=Matthias Appel <private_tweety@gmx.net>
CYRUS-IMAPD_DESCRIPTION=The Carnegie Mellon University Cyrus IMAP Server
CYRUS-IMAPD_SECTION=util
CYRUS-IMAPD_PRIORITY=optional
CYRUS-IMAPD_DEPENDS=openssl, libdb, cyrus-sasl, perl
CYRUS-IMAPD_SUGGESTS=
CYRUS-IMAPD_CONFLICTS=

CYRUS-IMAPD_IPK_VERSION=2

CYRUS-IMAPD_CONFFILES=/opt/etc/cyrus.conf /opt/etc/imapd.conf /opt/etc/init.d/S59cyrus-imapd

CYRUS-IMAPD_PATCHES=$(CYRUS-IMAPD_SOURCE_DIR)/cyrus.cross.patch \
 $(CYRUS-IMAPD_SOURCE_DIR)/perl.Makefile.in.patch \
 $(CYRUS-IMAPD_SOURCE_DIR)/perl.Makefile.PL.patch \
 $(CYRUS-IMAPD_SOURCE_DIR)/cyrus-imapd-2.2.12-autosievefolder-0.6.diff \
 $(CYRUS-IMAPD_SOURCE_DIR)/cyrus-imapd-2.2.12-autocreate-0.9.4.diff \
 $(CYRUS-IMAPD_SOURCE_DIR)/cyrus-imapd-2.2.12-rmquota+deletemailbox-0.2-1.diff \

CYRUS-IMAPD_CPPFLAGS=
CYRUS-IMAPD_LDFLAGS=

ifeq ($(HOST_MACHINE),armv5b)
  CYRUS-IMAPD_CONFIGURE_OPTS=
else
ifeq ($(HOST_MACHINE),ds101g)
  CYRUS-IMAPD_CONFIGURE_OPTS=
else
  CYRUS-IMAPD_CONFIGURE_OPTS=--without-perl
endif
endif

CYRUS-IMAPD_BUILD_DIR=$(BUILD_DIR)/cyrus-imapd
CYRUS-IMAPD_SOURCE_DIR=$(SOURCE_DIR)/cyrus-imapd
CYRUS-IMAPD_IPK_DIR=$(BUILD_DIR)/cyrus-imapd-$(CYRUS-IMAPD_VERSION)-ipk
CYRUS-IMAPD_IPK=$(BUILD_DIR)/cyrus-imapd_$(CYRUS-IMAPD_VERSION)-$(CYRUS-IMAPD_IPK_VERSION)_$(TARGET_ARCH).ipk

$(DL_DIR)/$(CYRUS-IMAPD_SOURCE):
	$(WGET) -P $(DL_DIR) $(CYRUS-IMAPD_SITE)/$(CYRUS-IMAPD_SOURCE)

cyrus-imapd-source: $(DL_DIR)/$(CYRUS-IMAPD_SOURCE) $(CYRUS-IMAPD_PATCHES)

$(CYRUS-IMAPD_BUILD_DIR)/.configured: $(DL_DIR)/$(CYRUS-IMAPD_SOURCE) $(CYRUS-IMAPD_PATCHES)
	$(MAKE) libdb-stage openssl-stage
	$(MAKE) cyrus-sasl-stage
	$(MAKE) e2fsprogs-stage # for libcom_err.a and friends
	rm -rf $(BUILD_DIR)/$(CYRUS-IMAPD_DIR) $(CYRUS-IMAPD_BUILD_DIR)
	$(CYRUS-IMAPD_UNZIP) $(DL_DIR)/$(CYRUS-IMAPD_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	cat $(CYRUS-IMAPD_PATCHES) | patch -d $(BUILD_DIR)/$(CYRUS-IMAPD_DIR) -p1
	mv $(BUILD_DIR)/$(CYRUS-IMAPD_DIR) $(CYRUS-IMAPD_BUILD_DIR)
	(cd $(CYRUS-IMAPD_BUILD_DIR); \
		autoconf; \
		$(TARGET_CONFIGURE_OPTS) \
		CC_FOR_BUILD=$(HOSTCC) \
		BUILD_CFLAGS="$(STAGING_CPPFLAGS) $(CYRUS-IMAPD_CPPFLAGS) -I.. -I../et" \
		CPPFLAGS="$(STAGING_CPPFLAGS) $(CYRUS-IMAPD_CPPFLAGS)" \
		LDFLAGS="$(STAGING_LDFLAGS) $(CYRUS-IMAPD_LDFLAGS)" \
		./configure \
		--build=$(GNU_HOST_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--target=$(GNU_TARGET_NAME) \
		--prefix=/opt \
		--sysconfdir=/opt/etc \
		--with-cyrus-prefix=/opt/libexec/cyrus \
		--with-statedir=/opt/var \
		--with-pidfile=/opt/var/run \
		--with-openssl=/opt \
		--with-sasl=/opt \
		--with-bdb=/opt \
		--with-auth=unix \
		--without-krb \
		--with-cyrus-user=mail \
		--with-cyrus-group=mail \
		--with-checkapop \
		--disable-nls \
		--with-com_err \
		$(CYRUS-IMAPD_CONFIGURE_OPTS) \
	)
	touch $(CYRUS-IMAPD_BUILD_DIR)/.configured

cyrus-imapd-unpack: $(CYRUS-IMAPD_BUILD_DIR)/.configured

$(CYRUS-IMAPD_BUILD_DIR)/.built: $(CYRUS-IMAPD_BUILD_DIR)/.configured
	rm -f $(CYRUS-IMAPD_BUILD_DIR)/.built
	$(MAKE) -C $(CYRUS-IMAPD_BUILD_DIR)
	touch $(CYRUS-IMAPD_BUILD_DIR)/.built

cyrus-imapd: $(CYRUS-IMAPD_BUILD_DIR)/.built

$(CYRUS-IMAPD_BUILD_DIR)/.staged: $(CYRUS-IMAPD_BUILD_DIR)/.built
	rm -f $(CYRUS-IMAPD_BUILD_DIR)/.staged
#	$(MAKE) -C $(CYRUS-IMAPD_BUILD_DIR) DESTDIR=$(STAGING_DIR) install
	echo "Warning: the makefile target 'cyrus-imapd-stage' is not available."
	touch $(CYRUS-IMAPD_BUILD_DIR)/.staged

cyrus-imapd-stage: $(CYRUS-IMAPD_BUILD_DIR)/.staged

$(CYRUS-IMAPD_IPK_DIR)/CONTROL/control:
	@install -d $(CYRUS-IMAPD_IPK_DIR)/CONTROL
	@rm -f $@
	@echo "Package: cyrus-imapd" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(CYRUS-IMAPD_PRIORITY)" >>$@
	@echo "Section: $(CYRUS-IMAPD_SECTION)" >>$@
	@echo "Version: $(CYRUS-IMAPD_VERSION)-$(CYRUS-IMAPD_IPK_VERSION)" >>$@
	@echo "Maintainer: $(CYRUS-IMAPD_MAINTAINER)" >>$@
	@echo "Source: $(CYRUS-IMAPD_SITE)/$(CYRUS-IMAPD_SOURCE)" >>$@
	@echo "Description: $(CYRUS-IMAPD_DESCRIPTION)" >>$@
	@echo "Depends: cyrus-imapd-devel (= $(CYRUS-IMAPD_VERSION)-$(CYRUS-IMAPD_IPK_VERSION))" >>$@
	@echo "Suggests: cyrus-imapd-doc, $(CYRUS-IMAPD_SUGGESTS)" >>$@
	@echo "Conflicts: $(CYRUS-IMAPD_CONFLICTS)" >>$@

$(CYRUS-IMAPD_IPK_DIR)-doc/CONTROL/control:
	@install -d $(CYRUS-IMAPD_IPK_DIR)-doc/CONTROL
	@rm -f $@
	@echo "Package: cyrus-imapd-doc" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(CYRUS-IMAPD_PRIORITY)" >>$@
	@echo "Section: $(CYRUS-IMAPD_SECTION)" >>$@
	@echo "Version: $(CYRUS-IMAPD_VERSION)-$(CYRUS-IMAPD_IPK_VERSION)" >>$@
	@echo "Maintainer: $(CYRUS-IMAPD_MAINTAINER)" >>$@
	@echo "Source: $(CYRUS-IMAPD_SITE)/$(CYRUS-IMAPD_SOURCE)" >>$@
	@echo "Description: $(CYRUS-IMAPD_DESCRIPTION)" >>$@
	@echo "Depends: " >>$@
	@echo "Suggests: man" >>$@
	@echo "Conflicts: " >>$@

$(CYRUS-IMAPD_IPK_DIR)-devel/CONTROL/control:
	@install -d $(CYRUS-IMAPD_IPK_DIR)-devel/CONTROL
	@rm -f $@
	@echo "Package: cyrus-imapd-devel" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(CYRUS-IMAPD_PRIORITY)" >>$@
	@echo "Section: $(CYRUS-IMAPD_SECTION)" >>$@
	@echo "Version: $(CYRUS-IMAPD_VERSION)-$(CYRUS-IMAPD_IPK_VERSION)" >>$@
	@echo "Maintainer: $(CYRUS-IMAPD_MAINTAINER)" >>$@
	@echo "Source: $(CYRUS-IMAPD_SITE)/$(CYRUS-IMAPD_SOURCE)" >>$@
	@echo "Description: $(CYRUS-IMAPD_DESCRIPTION)" >>$@
	@echo "Depends: $(CYRUS-IMAPD_DEPENDS)" >>$@
	@echo "Suggests: $(CYRUS-IMAPD_SUGGESTS)" >>$@
	@echo "Conflicts: $(CYRUS-IMAPD_CONFLICTS)" >>$@

$(CYRUS-IMAPD_IPK): $(CYRUS-IMAPD_BUILD_DIR)/.built
	rm -rf $(CYRUS-IMAPD_IPK_DIR)* $(BUILD_DIR)/cyrus-imapd_*_$(TARGET_ARCH).ipk
	install -d $(CYRUS-IMAPD_IPK_DIR)/opt/bin
	install -d $(CYRUS-IMAPD_IPK_DIR)/opt/etc
	install -m 644 $(CYRUS-IMAPD_SOURCE_DIR)/imapd.conf $(CYRUS-IMAPD_IPK_DIR)/opt/etc/imapd.conf
	install -m 644 $(CYRUS-IMAPD_SOURCE_DIR)/cyrus.conf $(CYRUS-IMAPD_IPK_DIR)/opt/etc/cyrus.conf
	install -d $(CYRUS-IMAPD_IPK_DIR)/opt/include/cyrus
	install -d $(CYRUS-IMAPD_IPK_DIR)/opt/libexec/cyrus/bin
	install -d $(CYRUS-IMAPD_IPK_DIR)/opt/var/run
	install -d $(CYRUS-IMAPD_IPK_DIR)/opt/var/lib
	install -d -m 750 $(CYRUS-IMAPD_IPK_DIR)/opt/var/lib/imap
	install -d -m 755 $(CYRUS-IMAPD_IPK_DIR)/opt/var/lib/imap/db
	install -d -m 755 $(CYRUS-IMAPD_IPK_DIR)/opt/var/lib/imap/log
	install -d -m 755 $(CYRUS-IMAPD_IPK_DIR)/opt/var/lib/imap/msg
	install -d -m 755 $(CYRUS-IMAPD_IPK_DIR)/opt/var/lib/imap/proc
	install -d -m 755 $(CYRUS-IMAPD_IPK_DIR)/opt/var/lib/imap/ptclient
	install -d -m 755 $(CYRUS-IMAPD_IPK_DIR)/opt/var/lib/imap/quota
	install -d -m 755 $(CYRUS-IMAPD_IPK_DIR)/opt/var/lib/imap/sieve
	install -d -m 750 $(CYRUS-IMAPD_IPK_DIR)/opt/var/lib/imap/ssl/certs
	install -d -m 750 $(CYRUS-IMAPD_IPK_DIR)/opt/var/lib/imap/ssl/CA
	install -d -m 755 $(CYRUS-IMAPD_IPK_DIR)/opt/var/lib/imap/socket
	install -d -m 755 $(CYRUS-IMAPD_IPK_DIR)/opt/var/lib/imap/user
	(cd $(CYRUS-IMAPD_IPK_DIR)/opt/var/lib/imap/quota ; \
		for i in a b c d e f g h i j k l m n o p q r s t u v w x y z ; do install -d -m 755 $$i ; done \
	)
	(cd $(CYRUS-IMAPD_IPK_DIR)/opt/var/lib/imap/sieve ; \
		for i in a b c d e f g h i j k l m n o p q r s t u v w x y z ; do install -d -m 755 $$i ; done \
	)
	(cd $(CYRUS-IMAPD_IPK_DIR)/opt/var/lib/imap/user ; \
		for i in a b c d e f g h i j k l m n o p q r s t u v w x y z ; do install -d -m 755 $$i ; done \
	)
	install -d $(CYRUS-IMAPD_IPK_DIR)/opt/var/spool/imap
	install -d -m 750 $(CYRUS-IMAPD_IPK_DIR)/opt/var/spool/imap/mail
	install -d -m 750 $(CYRUS-IMAPD_IPK_DIR)/opt/var/spool/imap/news
	install -d -m 755 $(CYRUS-IMAPD_IPK_DIR)/opt/var/spool/imap/stage.
	install -d -m 755 $(CYRUS-IMAPD_IPK_DIR)/opt/var/spool/imap/user
	$(MAKE) -C $(CYRUS-IMAPD_BUILD_DIR) DESTDIR=$(CYRUS-IMAPD_IPK_DIR) install
	$(STRIP_COMMAND) $(CYRUS-IMAPD_IPK_DIR)/opt/libexec/cyrus/bin/*
	$(STRIP_COMMAND) $(CYRUS-IMAPD_IPK_DIR)/opt/lib/*.a
# more work is needed to strip the following files
#	$(STRIP_COMMAND) $(CYRUS-IMAPD_IPK_DIR)/opt/bin/*
ifeq ($(HOST_MACHINE),armv5b)
	(cd $(CYRUS-IMAPD_IPK_DIR)/opt/lib/perl5/site_perl/5.8.6/armv5b-linux/auto/Cyrus ; \
		chmod +w IMAP/IMAP.so; \
		chmod +w SIEVE/managesieve/managesieve.so; \
		$(STRIP_COMMAND) IMAP/IMAP.so; \
		$(STRIP_COMMAND) SIEVE/managesieve/managesieve.so; \
		chmod -w IMAP/IMAP.so; \
		chmod -w SIEVE/managesieve/managesieve.so; \
	)
endif
	rm -rf $(CYRUS-IMAPD_IPK_DIR)/opt/lib/perl5/5.8.6
	find $(CYRUS-IMAPD_IPK_DIR)/opt/lib -type d -exec chmod go+rx {} \;
	find $(CYRUS-IMAPD_IPK_DIR)/opt/man -type d -exec chmod go+rx {} \;
	install -d $(CYRUS-IMAPD_IPK_DIR)/opt/etc/init.d
	install -m 755 $(CYRUS-IMAPD_SOURCE_DIR)/rc.cyrus-imapd $(CYRUS-IMAPD_IPK_DIR)/opt/etc/init.d/S59cyrus-imapd
	(cd $(CYRUS-IMAPD_IPK_DIR)/opt/etc/init.d; \
		ln -s S59cyrus-imapd K41cyrus-imapd \
	)

# Split into the different packages
	rm -rf $(CYRUS-IMAPD_IPK_DIR)-doc
	install -d $(CYRUS-IMAPD_IPK_DIR)-doc/opt/share/doc/cyrus/html
	install -m 644 $(CYRUS-IMAPD_BUILD_DIR)/README $(CYRUS-IMAPD_IPK_DIR)-doc/opt/share/doc/cyrus/README
	install -m 644 $(CYRUS-IMAPD_BUILD_DIR)/doc/*.html $(CYRUS-IMAPD_IPK_DIR)-doc/opt/share/doc/cyrus/html/
	install -m 644 $(CYRUS-IMAPD_BUILD_DIR)/doc/murder.* $(CYRUS-IMAPD_IPK_DIR)-doc/opt/share/doc/cyrus/html/
	mv $(CYRUS-IMAPD_IPK_DIR)/opt/man $(CYRUS-IMAPD_IPK_DIR)-doc/opt/man
	mv $(CYRUS-IMAPD_IPK_DIR)-doc/opt/man/man8/idled.8 $(CYRUS-IMAPD_IPK_DIR)-doc/opt/man/man8/cyrus_idled.8
	mv $(CYRUS-IMAPD_IPK_DIR)-doc/opt/man/man8/master.8 $(CYRUS-IMAPD_IPK_DIR)-doc/opt/man/man8/cyrus_master.8
	$(MAKE) $(CYRUS-IMAPD_IPK_DIR)-doc/CONTROL/control
#	install -d $(CYRUS-IMAPD_IPK_DIR)-doc/CONTROL
#	install -m 644 $(CYRUS-IMAPD_SOURCE_DIR)/control-doc $(CYRUS-IMAPD_IPK_DIR)-doc/CONTROL/control
	cd $(BUILD_DIR); $(IPKG_BUILD) $(CYRUS-IMAPD_IPK_DIR)-doc

	rm -rf $(CYRUS-IMAPD_IPK_DIR)-devel
	install -d $(CYRUS-IMAPD_IPK_DIR)-devel/opt/lib
	mv $(CYRUS-IMAPD_IPK_DIR)/opt/lib/*.a $(CYRUS-IMAPD_IPK_DIR)-devel/opt/lib
	mv $(CYRUS-IMAPD_IPK_DIR)/opt/include $(CYRUS-IMAPD_IPK_DIR)-devel/opt/include
	$(MAKE) $(CYRUS-IMAPD_IPK_DIR)-devel/CONTROL/control
#	install -d $(CYRUS-IMAPD_IPK_DIR)-devel/CONTROL
#	install -m 644 $(CYRUS-IMAPD_SOURCE_DIR)/control-devel $(CYRUS-IMAPD_IPK_DIR)-devel/CONTROL/control
	cd $(BUILD_DIR); $(IPKG_BUILD) $(CYRUS-IMAPD_IPK_DIR)-devel

	$(MAKE) $(CYRUS-IMAPD_IPK_DIR)/CONTROL/control
#	install -d $(CYRUS-IMAPD_IPK_DIR)/CONTROL
#	install -m 644 $(CYRUS-IMAPD_SOURCE_DIR)/control $(CYRUS-IMAPD_IPK_DIR)/CONTROL/control
	install -m 644 $(CYRUS-IMAPD_SOURCE_DIR)/postinst $(CYRUS-IMAPD_IPK_DIR)/CONTROL/postinst
#	install -m 644 $(CYRUS-IMAPD_SOURCE_DIR)/prerm $(CYRUS-IMAPD_IPK_DIR)/CONTROL/prerm
	echo $(CYRUS-IMAPD_CONFFILES) | sed -e 's/ /\n/g' > $(CYRUS-IMAPD_IPK_DIR)/CONTROL/conffiles
	cd $(BUILD_DIR); $(IPKG_BUILD) $(CYRUS-IMAPD_IPK_DIR)

cyrus-imapd-ipk: $(CYRUS-IMAPD_IPK)

cyrus-imapd-clean:
	-$(MAKE) -C $(CYRUS-IMAPD_BUILD_DIR) clean

cyrus-imapd-dirclean:
	rm -rf $(BUILD_DIR)/$(CYRUS-IMAPD_DIR) $(CYRUS-IMAPD_BUILD_DIR) $(CYRUS-IMAPD_IPK_DIR) $(CYRUS-IMAPD_IPK)
