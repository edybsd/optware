###########################################################
#
# xt
#
###########################################################

#
# XT_VERSION, XT_SITE and XT_SOURCE define
# the upstream location of the source code for the package.
# XT_DIR is the directory which is created when the source
# archive is unpacked.
#
XT_SITE=http://freedesktop.org
XT_SOURCE=# none - available from CVS only
XT_VERSION=0.1.5+cvs20050130
XT_REPOSITORY=:pserver:anoncvs@freedesktop.org:/cvs/xlibs
XT_DIR=Xt
XT_CVS_OPTS=-D20050130
XT_MAINTAINER=Josh Parsons <jbparsons@ucdavis.edu>
XT_DESCRIPTION=X toolkit intrinsics library
XT_SECTION=lib
XT_PRIORITY=optional
XT_DEPENDS=x11, sm

#
# XT_IPK_VERSION should be incremented when the ipk changes.
#
XT_IPK_VERSION=1

#
# XT_CONFFILES should be a list of user-editable files
XT_CONFFILES=

#
# XT_PATCHES should list any patches, in the the order in
# which they should be applied to the source code.
#
XT_PATCHES=

#
# If the compilation of the package requires additional
# compilation or linking flags, then list them here.
#
XT_CPPFLAGS=
XT_LDFLAGS=

#
# XT_BUILD_DIR is the directory in which the build is done.
# XT_SOURCE_DIR is the directory which holds all the
# patches and ipkg control files.
# XT_IPK_DIR is the directory in which the ipk is built.
# XT_IPK is the name of the resulting ipk files.
#
# You should not change any of these variables.
#
XT_BUILD_DIR=$(BUILD_DIR)/xt
XT_SOURCE_DIR=$(SOURCE_DIR)/xt
XT_IPK_DIR=$(BUILD_DIR)/xt-$(XT_VERSION)-ipk
XT_IPK=$(BUILD_DIR)/xt_$(XT_VERSION)-$(XT_IPK_VERSION)_armeb.ipk

#
# Automatically create a ipkg control file
#
$(XT_IPK_DIR)/CONTROL/control:
	@install -d $(XT_IPK_DIR)/CONTROL
	@rm -f $@
	@echo "Package: xt" >>$@
	@echo "Architecture: armeb" >>$@
	@echo "Priority: $(XT_PRIORITY)" >>$@
	@echo "Section: $(XT_SECTION)" >>$@
	@echo "Version: $(XT_VERSION)-$(XT_IPK_VERSION)" >>$@
	@echo "Maintainer: $(XT_MAINTAINER)" >>$@
	@echo "Source: $(XT_SITE)/$(XT_SOURCE)" >>$@
	@echo "Description: $(XT_DESCRIPTION)" >>$@
	@echo "Depends: $(XT_DEPENDS)" >>$@

#
# In this case there is no tarball, instead we fetch the sources
# directly to the builddir with CVS
#
$(XT_BUILD_DIR)/.fetched:
	rm -rf $(XT_BUILD_DIR) $(BUILD_DIR)/$(XT_DIR)
	( cd $(BUILD_DIR); \
		cvs -d $(XT_REPOSITORY) -z3 co $(XT_CVS_OPTS) $(XT_DIR); \
	)
	mv $(BUILD_DIR)/$(XT_DIR) $(XT_BUILD_DIR)
	#cat $(XT_PATCHES) | patch -d $(XT_BUILD_DIR) -p0
	touch $@

xt-source: $(XT_BUILD_DIR)/.fetched $(XT_PATCHES)

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
$(XT_BUILD_DIR)/.configured: $(XT_BUILD_DIR)/.fetched $(XT_PATCHES)
	$(MAKE) x11-stage
	$(MAKE) sm-stage
	(cd $(XT_BUILD_DIR); \
		$(TARGET_CONFIGURE_OPTS) \
		CPPFLAGS="$(STAGING_CPPFLAGS) $(XT_CPPFLAGS)" \
		LDFLAGS="$(STAGING_LDFLAGS) $(XT_LDFLAGS)" \
		PKG_CONFIG_PATH="$(STAGING_LIB_DIR)/pkgconfig" \
		PKG_CONFIG_LIBDIR="$(STAGING_LIB_DIR)/pkgconfig" \
		ACLOCAL=aclocal-1.9 \
		AUTOMAKE=automake-1.9 \
		./autogen.sh \
		--build=$(GNU_HOST_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--target=$(GNU_TARGET_NAME) \
		--prefix=/opt \
		--disable-static \
	)
	touch $(XT_BUILD_DIR)/.configured

xt-unpack: $(XT_BUILD_DIR)/.configured

#
# This builds the actual binary.
#
$(XT_BUILD_DIR)/.built: $(XT_BUILD_DIR)/.configured
	rm -f $(XT_BUILD_DIR)/.built
	$(MAKE) -C $(XT_BUILD_DIR)/util CC=$(HOSTCC) CFLAGS="-pipe -O1" LDFLAGS=""
	$(MAKE) -C $(XT_BUILD_DIR)
	touch $(XT_BUILD_DIR)/.built

#
# This is the build convenience target.
#
xt: $(XT_BUILD_DIR)/.built

#
# If you are building a library, then you need to stage it too.
#
$(XT_BUILD_DIR)/.staged: $(XT_BUILD_DIR)/.built
	rm -f $(XT_BUILD_DIR)/.staged
	$(MAKE) -C $(XT_BUILD_DIR) DESTDIR=$(STAGING_DIR) install
	rm -f $(STAGING_LIB_DIR)/libXt.la
	touch $(XT_BUILD_DIR)/.staged

xt-stage: $(XT_BUILD_DIR)/.staged

#
# This builds the IPK file.
#
# Binaries should be installed into $(XT_IPK_DIR)/opt/sbin or $(XT_IPK_DIR)/opt/bin
# (use the location in a well-known Linux distro as a guide for choosing sbin or bin).
# Libraries and include files should be installed into $(XT_IPK_DIR)/opt/{lib,include}
# Configuration files should be installed in $(XT_IPK_DIR)/opt/etc/xt/...
# Documentation files should be installed in $(XT_IPK_DIR)/opt/doc/xt/...
# Daemon startup scripts should be installed in $(XT_IPK_DIR)/opt/etc/init.d/S??xt
#
# You may need to patch your application to make it use these locations.
#
$(XT_IPK): $(XT_BUILD_DIR)/.built
	rm -rf $(XT_IPK_DIR) $(BUILD_DIR)/xt_*_armeb.ipk
	$(MAKE) -C $(XT_BUILD_DIR) DESTDIR=$(XT_IPK_DIR) install-strip
	$(MAKE) $(XT_IPK_DIR)/CONTROL/control
	rm -f $(XT_IPK_DIR)/opt/lib/*.la
	cd $(BUILD_DIR); $(IPKG_BUILD) $(XT_IPK_DIR)

#
# This is called from the top level makefile to create the IPK file.
#
xt-ipk: $(XT_IPK)

#
# This is called from the top level makefile to clean all of the built files.
#
xt-clean:
	-$(MAKE) -C $(XT_BUILD_DIR) clean

#
# This is called from the top level makefile to clean all dynamically created
# directories.
#
xt-dirclean:
	rm -rf $(BUILD_DIR)/$(XT_DIR) $(XT_BUILD_DIR) $(XT_IPK_DIR) $(XT_IPK)
