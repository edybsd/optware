###########################################################
#
# samba41
#
###########################################################

# You must replace "samba" and "SAMBA" with the lower case name and
# upper case name of your new package.  Some places below will say
# "Do not change this" - that does not include this global change,
# which must always be done to ensure we have unique names.

#
# SAMBA_VERSION, SAMBA_SITE and SAMBA_SOURCE define
# the upstream location of the source code for the package.
# SAMBA_DIR is the directory which is created when the source
# archive is unpacked.
# SAMBA_UNZIP is the command used to unzip the source.
# It is usually "zcat" (for .gz) or "bzcat" (for .bz2)
#
# You should change all these variables to suit your package.
#
SAMBA41_SITE=http://www.samba.org/samba/ftp/stable
SAMBA41_VERSION ?= 4.1.14
SAMBA41_IPK_VERSION ?= 1
SAMBA41_SOURCE=samba-$(SAMBA41_VERSION).tar.gz
SAMBA41_DIR=samba-$(SAMBA41_VERSION)
SAMBA41_UNZIP=zcat
SAMBA41_MAINTAINER=NSLU2 Linux <nslu2-linux@yahoogroups.com>
SAMBA41_DESCRIPTION=Samba suite provides file and print services to SMB/CIFS clients. This is a newer version.
SAMBA41_SECTION=net
SAMBA41_PRIORITY=optional
SAMBA41_DEPENDS=avahi, popt, readline, zlib, e2fsprogs
ifeq (openldap, $(filter openldap, $(PACKAGES)))
SAMBA41_DEPENDS +=, openldap-libs
endif
ifeq (glibc, $(LIBC_STYLE))
SAMBA41_DEPENDS +=, gconv-modules
endif
SAMBA41-DEV_DEPENDS=samba41
SAMBA41-SWAT_DEPENDS=samba41, xinetd
SAMBA41_SUGGESTS=cups
SAMBA41-DEV_SUGGESTS=
SAMBA41-SWAT_SUGGESTS=
SAMBA41_CONFLICTS=samba,samba2,samba34,samba35,samba41
SAMBA41-DEV_CONFLICTS=samba2,samba3-dev,samba34-dev,samba35-dev,samba41-dev
SAMBA41-SWAT_CONFLICTS=samba2, samba3-swat, samba34-swat,samba35-swat,samba41-swat
SAMBA41_ADDITIONAL_CODEPAGES=CP866

#
# SAMBA41_CONFFILES should be a list of user-editable files
SAMBA41_CONFFILES=/opt/etc/init.d/S08samba
SAMBA41-SWAT_CONFFILES=/opt/etc/xinetd.d/swat

#
# SAMBA41_PATCHES should list any patches, in the the order in
# which they should be applied to the source code.
#
#SAMBA41_PATCHES=\
$(SAMBA41_SOURCE_DIR)/configure.in.patch \
$(SAMBA41_SOURCE_DIR)/IPV6_V6ONLY.patch \

#
# If the compilation of the package requires additional
# compilation or linking flags, then list them here.
#
SAMBA41_CPPFLAGS= -I$(STAGING_INCLUDE_DIR)/etc
SAMBA41_LDFLAGS=

#
# SAMBA41_BUILD_DIR is the directory in which the build is done.
# SAMBA41_SOURCE_DIR is the directory which holds all the
# patches and ipkg control files.
# SAMBA41_IPK_DIR is the directory in which the ipk is built.
# SAMBA41_IPK is the name of the resulting ipk files.
#
# You should not change any of these variables.
#
SAMBA41_BUILD_DIR=$(BUILD_DIR)/samba41
SAMBA41_SOURCE_DIR=$(SOURCE_DIR)/samba41

SAMBA41_IPK_DIR=$(BUILD_DIR)/samba41-$(SAMBA41_VERSION)-ipk
SAMBA41_IPK=$(BUILD_DIR)/samba41_$(SAMBA41_VERSION)-$(SAMBA41_IPK_VERSION)_$(TARGET_ARCH).ipk
SAMBA41-DEV_IPK_DIR=$(BUILD_DIR)/samba41-dev-$(SAMBA41_VERSION)-ipk
SAMBA41-DEV_IPK=$(BUILD_DIR)/samba41-dev_$(SAMBA41_VERSION)-$(SAMBA41_IPK_VERSION)_$(TARGET_ARCH).ipk
SAMBA41-SWAT_IPK_DIR=$(BUILD_DIR)/samba41-swat-$(SAMBA41_VERSION)-ipk
SAMBA41-SWAT_IPK=$(BUILD_DIR)/samba41-swat_$(SAMBA41_VERSION)-$(SAMBA41_IPK_VERSION)_$(TARGET_ARCH).ipk

SAMBA41_BUILD_DIR_SRC=$(SAMBA41_BUILD_DIR)/source3

SAMBA41_INST_DIR=/opt
SAMBA41_EXEC_PREFIX=$(SAMBA41_INST_DIR)
SAMBA41_BIN_DIR=$(SAMBA41_INST_DIR)/bin
SAMBA41_SBIN_DIR=$(SAMBA41_INST_DIR)/sbin
SAMBA41_LIBEXEC_DIR=$(SAMBA41_INST_DIR)/libexec
SAMBA41_DATA_DIR=$(SAMBA41_INST_DIR)/share/samba
SAMBA41_SYSCONF_DIR=$(SAMBA41_INST_DIR)/etc/samba
SAMBA41_SHAREDSTATE_DIR=$(SAMBA41_INST_DIR)/com/samba
SAMBA41_LOCALSTATE_DIR=$(SAMBA41_INST_DIR)/var/samba
SAMBA41_LIB_DIR=$(SAMBA41_INST_DIR)/lib
SAMBA41_INCLUDE_DIR=$(SAMBA41_INST_DIR)/include
SAMBA41_INFO_DIR=$(SAMBA41_INST_DIR)/info
SAMBA41_MAN_DIR=$(SAMBA41_INST_DIR)/man
SAMBA41_SWAT_DIR=$(SAMBA41_INST_DIR)/share/swat

ifeq (uclibc, $(LIBC_STYLE))
SAMBA41_LINUX_GETGROUPLIST_OK=no
else
SAMBA41_LINUX_GETGROUPLIST_OK=yes
endif

ifneq ($(HOSTCC), $(TARGET_CC))
SAMBA41_CROSS_ENVS=\
		LINUX_LFS_SUPPORT=yes \
		libreplace_cv_READDIR_GETDIRENTRIES=no \
		libreplace_cv_READDIR_GETDENTS=no \
		libreplace_cv_HAVE_GETADDRINFO=no \
		samba_cv_HAVE_WRFILE_KEYTAB=no \
		samba_cv_has_proc_sys_kernel_core_pattern=yes \
		smb_krb5_cv_enctype_to_string_takes_krb5_context_arg=no \
		smb_krb5_cv_enctype_to_string_takes_size_t_arg=no \
		LOOK_DIRS=$(STAGING_PREFIX) \
		samba_cv_CC_NEGATIVE_ENUM_VALUES=yes \
		samba_cv_HAVE_BROKEN_GETGROUPS=$(SAMBA41_LINUX_GETGROUPLIST_OK) \
		samba_cv_HAVE_GETTIMEOFDAY_TZ=yes \
		samba_cv_have_setresuid=yes \
		samba_cv_have_setresgid=yes \
		samba_cv_USE_SETRESUID=yes \
		samba_cv_HAVE_IFACE_IFCONF=yes \
		samba_cv_SIZEOF_OFF_T=yes \
		samba_cv_SIZEOF_INO_T=yes \
		samba_cv_HAVE_DEVICE_MAJOR_FN=yes \
		samba_cv_HAVE_DEVICE_MINOR_FN=yes \
		samba_cv_HAVE_MAKEDEV=yes \
		samba_cv_HAVE_UNSIGNED_CHAR=yes \
		samba_cv_HAVE_C99_VSNPRINTF=yes \
		samba_cv_HAVE_KERNEL_OPLOCKS_LINUX=yes \
		samba_cv_HAVE_KERNEL_CHANGE_NOTIFY=yes \
		samba_cv_HAVE_KERNEL_SHARE_MODES=yes \
		samba_cv_HAVE_FTRUNCATE_EXTEND=yes \
		samba_cv_HAVE_SECURE_MKSTEMP=yes \
		samba_cv_SYSCONF_SC_NGROUPS_MAX=yes \
		samba_cv_HAVE_MMAP=yes \
		samba_cv_HAVE_FCNTL_LOCK=yes \
		samba_cv_HAVE_STRUCT_FLOCK64=yes \
		samba_cv_have_longlong=yes \
		samba_cv_HAVE_OFF64_T=no \
		samba_cv_HAVE_INO64_T=no \
		samba_cv_HAVE_DEV64_T=no \
		samba_cv_HAVE_BROKEN_READDIR=no \
		samba_cv_HAVE_IRIX_SPECIFIC_CAPABILITIES=no \
		samba_cv_HAVE_WORKING_AF_LOCAL=yes \
		samba_cv_HAVE_BROKEN_GETGROUPS=no \
		samba_cv_REPLACE_INET_NTOA=no \
		samba_cv_SYSCONF_SC_NPROC_ONLN=no \
		samba_cv_HAVE_IFACE_AIX=no \
		samba_cv_HAVE_BROKEN_FCNTL64_LOCKS=no \
		samba_cv_REALPATH_TAKES_NULL=no \
		samba_cv_HAVE_TRUNCATED_SALT=no \
		fu_cv_sys_stat_statvfs64=yes
  ifeq (no, $(IPV6))
SAMBA41_CROSS_ENVS += libreplace_cv_HAVE_IPV6=no
  endif
  ifeq ($(OPTWARE_TARGET), $(filter oleg, $(OPTWARE_TARGET)))
SAMBA41_CROSS_ENVS += ac_cv_header_linux_dqblk_xfs_h=no
  endif
endif

ifeq (openldap, $(filter openldap, $(PACKAGES)))
SAMBA41_CONFIG_ARGS=--with-ldap
endif

# cifsmount does not work for some plattforms , missing fstab.h, allow override, should  patched now 
SAMBA41_CONFIG_ARGS_EXTRA ?= --with-cifsmount --with-cifsumount
SAMBA41_CONFIG_ARGS += $(SAMBA41_CONFIG_ARGS_EXTRA)

.PHONY: samba41-source samba41-unpack samba41 samba41-stage samba41-ipk samba41-clean samba41-dirclean samba41-check

#
# This is the dependency on the source code.  If the source is missing,
# then it will be fetched from the site using wget.
#
$(DL_DIR)/$(SAMBA41_SOURCE):
	$(WGET) -P $(@D) $(SAMBA41_SITE)/$(@F) || \
	$(WGET) -P $(@D) $(SOURCES_NLO_SITE)/$(@F)

#
# The source code depends on it existing within the download directory.
# This target will be called by the top level Makefile to download the
# source code's archive (.tar.gz, .bz2, etc.)
#
samba41-source: $(DL_DIR)/$(SAMBA41_SOURCE) $(SAMBA41_PATCHES)

#
# This target unpacks the source code in the build directory.
# If the source archive is not .tar.gz or .tar.bz2, then you will need
# to change the commands here.  Patches to the source code are also
# applied in this target as required.
#
# This target also configures the build within the build directory.
# Flags such as LDFLAGS and CPPFLAGS should be passed into configure
# and NOT $(MAKE) below.  Passing it to configure causes configure to
# correctly BUILD the Makefile with the right paths, where passing it
# to Make causes it to override the default search paths of the compiler.
#
# If the compilation of the package requires other packages to be staged
# first, then do that first (e.g. "$(MAKE) <bar>-stage <baz>-stage").
#
$(SAMBA41_BUILD_DIR)/.configured: $(DL_DIR)/$(SAMBA41_SOURCE) $(SAMBA41_PATCHES) make/samba41.mk
ifeq (openldap, $(filter openldap, $(PACKAGES)))
	$(MAKE) openldap-stage 
endif
	$(MAKE) avahi-stage cups-stage popt-stage readline-stage zlib-stage e2fsprogs-stage
	rm -rf $(BUILD_DIR)/$(SAMBA41_DIR) $(@D)
	$(SAMBA41_UNZIP) $(DL_DIR)/$(SAMBA41_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	mv $(BUILD_DIR)/$(SAMBA41_DIR) $(@D)
	if test -n "$(TRANSMISSION_PATCHES)" ; \
                then cat $(TRANSMISSION_PATCHES) | \
		then cat $(SAMBA41_PATCHES) | patch -d $(@D) -p1
	fi
	(cd $(@D)/source3/; ./autogen.sh)
	(cd $(@D)/source3/; \
		$(TARGET_CONFIGURE_OPTS) \
		CPPFLAGS="$(STAGING_CPPFLAGS) $(SAMBA41_CPPFLAGS)" \
		LDFLAGS="$(STAGING_LDFLAGS) $(SAMBA41_LDFLAGS)" \
		$(SAMBA41_CROSS_ENVS) \
		./configure \
		--build=$(GNU_HOST_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--target=$(GNU_TARGET_NAME) \
		--prefix=$(SAMBA41_INST_DIR) \
		--exec-prefix=$(SAMBA41_INST_DIR) \
		--bindir=$(SAMBA41_BIN_DIR) \
		--sbindir=$(SAMBA41_SBIN_DIR) \
		--libexecdir=$(SAMBA41_LIBEXEC_DIR) \
		--datadir=$(SAMBA41_DATA_DIR) \
		--sysconfdir=$(SAMBA41_SYSCONF_DIR) \
		--sharedstatedir=$(SAMBA41_SHAREDSTATE_DIR) \
		--localstatedir=$(SAMBA41_LOCALSTATE_DIR) \
		--libdir=$(SAMBA41_LIB_DIR) \
		--includedir=$(SAMBA41_INCLUDE_DIR) \
		--oldincludedir=$(SAMBA41_INCLUDE_DIR) \
		--infodir=$(SAMBA41_INFO_DIR) \
		--mandir=$(SAMBA41_MAN_DIR) \
		--disable-pie \
		--with-privatedir=$(SAMBA41_SYSCONF_DIR) \
		--with-lockdir=$(SAMBA41_LOCALSTATE_DIR) \
		--with-piddir=$(SAMBA41_LOCALSTATE_DIR) \
		--with-swatdir=$(SAMBA41_SWAT_DIR) \
		--with-configdir=$(SAMBA41_SYSCONF_DIR) \
		--with-logfilebase=$(SAMBA41_LOCALSTATE_DIR) \
		--with-libdir=$(SAMBA41_LIB_DIR) \
		--with-mandir=$(SAMBA41_MAN_DIR) \
		--with-smbmount \
		--without-quotas \
		--without-sys-quotas\
		--with-krb5=no \
		$(SAMBA41_CONFIG_ARGS) \
		--disable-nls \
	)
#	Remove Kerberos libs produced by broken configure
#	sed -i -e 's/KRB5LIBS=.*/KRB5LIBS=/' \
#	 -e 's/-lgssapi_krb5\|-lkrb5\|-lk5crypto\|-lcom_err\|-lgnutls//g' \
#	 -e '/^TERMLIBS=/s/$$/ -ltermcap/g' \
		$(@D)/source3/Makefile
### additional codepages
	CODEPAGES="$(SAMBA41_ADDITIONAL_CODEPAGES)" SAMBA41_SOURCE_DIR=$(SAMBA41_SOURCE_DIR) SAMBA41_BUILD_DIR=$(SAMBA41_BUILD_DIR) /bin/sh $(SAMBA41_SOURCE_DIR)/addcodepages.sh
	touch $@

samba41-unpack: $(SAMBA41_BUILD_DIR)/.configured

#
# This builds the actual binary.
#
$(SAMBA41_BUILD_DIR)/.built: $(SAMBA41_BUILD_DIR)/.configured
	rm -f $@
	$(MAKE) -C $(@D)/source3/
	touch $@

#
# This is the build convenience target.
#
samba41: $(SAMBA41_BUILD_DIR)/.built

#
# If you are building a library, then you need to stage it too.
#
$(SAMBA41_BUILD_DIR)/.staged: $(SAMBA41_BUILD_DIR)/.built
	rm -f $@
	$(MAKE) -C $(@D)/source3/ DESTDIR=$(STAGING_DIR) install
	touch $@

samba41-stage: $(SAMBA41_BUILD_DIR)/.staged

#
# This rule creates a control file for ipkg.  It is no longer
# necessary to create a seperate control file under sources/samba
#
$(SAMBA41_IPK_DIR)/CONTROL/control:
	@install -d $(@D)/
	@rm -f $@
	@echo "Package: samba41" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(SAMBA41_PRIORITY)" >>$@
	@echo "Section: $(SAMBA41_SECTION)" >>$@
	@echo "Version: $(SAMBA41_VERSION)-$(SAMBA41_IPK_VERSION)" >>$@
	@echo "Maintainer: $(SAMBA41_MAINTAINER)" >>$@
	@echo "Source: $(SAMBA41_SITE)/$(SAMBA41_SOURCE)" >>$@
	@echo "Description: $(SAMBA41_DESCRIPTION)" >>$@
	@echo "Depends: $(SAMBA41_DEPENDS)" >>$@
	@echo "Suggests: $(SAMBA41_SUGGESTS)" >>$@
	@echo "Conflicts: $(SAMBA41_CONFLICTS)" >>$@

$(SAMBA41-DEV_IPK_DIR)/CONTROL/control:
	@install -d $(@D)/
	@rm -f $@
	@echo "Package: samba41-dev" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(SAMBA41_PRIORITY)" >>$@
	@echo "Section: $(SAMBA41_SECTION)" >>$@
	@echo "Version: $(SAMBA41_VERSION)-$(SAMBA41_IPK_VERSION)" >>$@
	@echo "Maintainer: $(SAMBA41_MAINTAINER)" >>$@
	@echo "Source: $(SAMBA41_SITE)/$(SAMBA41_SOURCE)" >>$@
	@echo "Description: development files for samba41" >>$@
	@echo "Depends: $(SAMBA41-DEV_DEPENDS)" >>$@
	@echo "Suggests: $(SAMBA41-DEV_SUGGESTS)" >>$@
	@echo "Conflicts: $(SAMBA41-DEV_CONFLICTS)" >>$@

$(SAMBA41-SWAT_IPK_DIR)/CONTROL/control:
	@install -d $(@D)/
	@rm -f $@
	@echo "Package: samba41-swat" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(SAMBA41_PRIORITY)" >>$@
	@echo "Section: $(SAMBA41_SECTION)" >>$@
	@echo "Version: $(SAMBA41_VERSION)-$(SAMBA41_IPK_VERSION)" >>$@
	@echo "Maintainer: $(SAMBA41_MAINTAINER)" >>$@
	@echo "Source: $(SAMBA41_SITE)/$(SAMBA41_SOURCE)" >>$@
	@echo "Description: the Samba Web Admin Tool for samba41" >>$@
	@echo "Depends: $(SAMBA41-SWAT_DEPENDS)" >>$@
	@echo "Suggests: $(SAMBA41-SWAT_SUGGESTS)" >>$@
	@echo "Conflicts: $(SAMBA41-SWAT_CONFLICTS)" >>$@

#
# This builds the IPK file.
#
# Binaries should be installed into $(SAMBA41_IPK_DIR)/opt/sbin or $(SAMBA41_IPK_DIR)/opt/bin
# (use the location in a well-known Linux distro as a guide for choosing sbin or bin).
# Libraries and include files should be installed into $(SAMBA41_IPK_DIR)/opt/{lib,include}
# Configuration files should be installed in $(SAMBA41_IPK_DIR)/opt/etc/samba/...
# Documentation files should be installed in $(SAMBA41_IPK_DIR)/opt/doc/samba/...
# Daemon startup scripts should be installed in $(SAMBA41_IPK_DIR)/opt/etc/init.d/S??samba
#
# You may need to patch your application to make it use these locations.
#
$(SAMBA41_IPK) $(SAMBA41-DEV_IPK) $(SAMBA41-SWAT_IPK): $(SAMBA41_BUILD_DIR)/.built
	rm -rf $(SAMBA41_IPK_DIR) $(BUILD_DIR)/SAMBA41_*_$(TARGET_ARCH).ipk
	rm -rf $(SAMBA41-DEV_IPK_DIR) $(BUILD_DIR)/samba41-dev_*_$(TARGET_ARCH).ipk
	rm -rf $(SAMBA41-SWAT_IPK_DIR) $(BUILD_DIR)/samba41-swat_*_$(TARGET_ARCH).ipk
	# samba3
	$(MAKE) -C $(SAMBA41_BUILD_DIR)/source3/ DESTDIR=$(SAMBA41_IPK_DIR) install
	$(STRIP_COMMAND) `ls $(SAMBA41_IPK_DIR)/opt/sbin/* | egrep -v 'mount.smbfs'`
	$(STRIP_COMMAND) `ls $(SAMBA41_IPK_DIR)/opt/bin/* | egrep -v 'findsmb|smbtar'`
	cd $(SAMBA41_BUILD_DIR)/source3/bin/; for f in lib*.so.[01]; \
		do cp -a $$f $(SAMBA41_IPK_DIR)/opt/lib/$$f; done
	$(STRIP_COMMAND) `find $(SAMBA41_IPK_DIR)/opt/lib -name '*.so'`
	install -d $(SAMBA41_IPK_DIR)/opt/etc/init.d
	install -m 755 $(SAMBA41_SOURCE_DIR)/rc.samba $(SAMBA41_IPK_DIR)/opt/etc/init.d/S08samba
	$(MAKE) $(SAMBA41_IPK_DIR)/CONTROL/control
	install -m 644 $(SAMBA41_SOURCE_DIR)/postinst $(SAMBA41_IPK_DIR)/CONTROL/postinst
	install -m 644 $(SAMBA41_SOURCE_DIR)/preinst $(SAMBA41_IPK_DIR)/CONTROL/preinst
	echo $(SAMBA41_CONFFILES) | sed -e 's/ /\n/g' > $(SAMBA41_IPK_DIR)/CONTROL/conffiles
	# samba3-dev
	install -d $(SAMBA41-DEV_IPK_DIR)/opt
	mv $(SAMBA41_IPK_DIR)/opt/include $(SAMBA41-DEV_IPK_DIR)/opt/
	# samba3-swat
	install -d $(SAMBA41-SWAT_IPK_DIR)/opt/share $(SAMBA41-SWAT_IPK_DIR)/opt/sbin
	mv $(SAMBA41_IPK_DIR)/opt/share/swat $(SAMBA41-SWAT_IPK_DIR)/opt/share/
	mv $(SAMBA41_IPK_DIR)/opt/sbin/swat $(SAMBA41-SWAT_IPK_DIR)/opt/sbin/
	install -d $(SAMBA41-SWAT_IPK_DIR)/opt/etc/xinetd.d
	install -m 755 $(SAMBA41_SOURCE_DIR)/swat $(SAMBA41-SWAT_IPK_DIR)/opt/etc/xinetd.d/swat
	# building ipk's
	cd $(BUILD_DIR); $(IPKG_BUILD) $(SAMBA41_IPK_DIR)
	$(MAKE) $(SAMBA41-DEV_IPK_DIR)/CONTROL/control
	cd $(BUILD_DIR); $(IPKG_BUILD) $(SAMBA41-DEV_IPK_DIR)
	$(MAKE) $(SAMBA41-SWAT_IPK_DIR)/CONTROL/control
	echo $(SAMBA41-SWAT_CONFFILES) | sed -e 's/ /\n/g' > $(SAMBA41-SWAT_IPK_DIR)/CONTROL/conffiles
	cd $(BUILD_DIR); $(IPKG_BUILD) $(SAMBA41-SWAT_IPK_DIR)
	$(WHAT_TO_DO_WITH_IPK_DIR) $(SAMBA41_IPK_DIR) $(SAMBA41-DEV_IPK_DIR) $(SAMBA41-SWAT_IPK_DIR)

#
# This is called from the top level makefile to create the IPK file.
#
samba41-ipk: $(SAMBA41_IPK) $(SAMBA41-DEV_IPK) $(SAMBA41-SWAT_IPK)

#
# This is called from the top level makefile to clean all of the built files.
#
samba41-clean:
	-$(MAKE) -C $(SAMBA41_BUILD_DIR) clean

#
# This is called from the top level makefile to clean all dynamically created
# directories.
#
samba41-dirclean:
	rm -rf $(BUILD_DIR)/$(SAMBA41_DIR) $(SAMBA41_BUILD_DIR) $(SAMBA41_IPK_DIR) $(SAMBA41_IPK)

#
# Some sanity check for the package.
#
samba41-check: $(SAMBA41_IPK) $(SAMBA41-DEV_IPK) $(SAMBA41-SWAT_IPK)
	perl scripts/optware-check-package.pl --target=$(OPTWARE_TARGET) $^
