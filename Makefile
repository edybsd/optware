# Makefile for Optware packages
#
# Copyright (C) 2004 by Rod Whitby <unslung@gmail.com>
# Copyright (C) 2004 by Oleg I. Vdovikin <oleg@cs.msu.su>
# Copyright (C) 2001-2004 Erik Andersen <andersen@codepoet.org>
# Copyright (C) 2002 by Tim Riker <Tim@Rikers.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
#

# Options are "nslu2", "wl500g", "ddwrt", "oleg", "ds101", "ds101j", "ds101g", "mss", "nas100d" and "fsg3"
OPTWARE_TARGET ?= nslu2

HOST_MACHINE:=$(shell uname -m | sed -e 's/i[3-9]86/i386/' )

# Add new packages here - make sure you have tested cross compilation.
# When they have been tested, they will be promoted and uploaded.
#
CROSS_PACKAGES_READY_FOR_TESTING = \

# Add new native-only packages here
# When they have been tested, they will be promoted and uploaded.
#
NATIVE_PACKAGES_READY_FOR_TESTING = \

COMMON_CROSS_PACKAGES = \
	abook adduser adns alac-decoder amule antinat appweb asterisk asterisk-sounds \
	apache apr apr-util atftp atk audiofile autoconf automake \
	bash bc bzip2 bind bip bitchx bitlbee bsdmainutils busybox byrequest bzflag \
	bluez-libs bluez-utils bluez-hcidump \
	ccxstream chillispot coreutils cpio cron cdargs cherokee chrpath classpath clamav clearsilver \
	clips cogito ctags ctcs ctorrent cups cvs cyrus-sasl \
	dcraw denyhosts dev-pts dict digitemp distcc dhcp diffutils dnsmasq dokuwiki dovecot dropbear dspam \
	e2fsprogs e2tools eaccelerator ed ecl elinks enhanced-ctorrent esmtp erlang esound eggdrop \
	expat extract-xiso \
	fetchmail file findutils flex flip ftpd-topfield ffmpeg ficy fixesext flac \
	fontconfig freeradius freetds freetype \
	gambit-c gawk gconv-modules getmail gettext gdchart ghostscript gdb gdbm grep groff gzip \
	gift giftcurs gift-ares gift-fasttrack gift-gnutella gift-openft gift-opennap \
	git-core glib gnupg gnuplot gnutls gtk \
	hdparm hexcurse hnb hpijs \
	ice id3lib iozone imagemagick imap inetutils iperf ipkg-web iptables ipython \
	ircd-hybrid irssi ivorbis-tools \
	jabber jamvm jikes jove joe \
	knock \
	lame ldconfig less lftp libart libbt libcurl libdb libdvb libdvdread libesmtp libevent libexif libftdi \
	libgc libgcrypt libgd libghttp libgmp libgpg-error libid3tag libjpeg liblcms libmad libmemcache libnsl \
	libol libogg libosip2 libpcap libpng librsync libsigc++ libstdc++ libtasn1 libtiff libtool libtorrent \
	libupnp libusb libvorbis libvorbisidec libxml2 libxslt lighttpd logrotate lrzsz lsof lua lynx lzo \
	m4 mailman make mc miau minicom mktemp modutils monit motion mt-daapd mysql \
	madplay man man-pages mdadm mediawiki memcached metalog microperl mod-fastcgi mod-python \
	monotone mpage mrtg mtr mutt \
	nagios-plugins nail nano nbench-byte neon net-snmp ncftp ncurses ncursesw noip \
	netcat net-tools netio nfs-server nfs-utils \
	nget nmap nload nrpe ntfsprogs ntop ntp ntpclient nvi nylon nzbget \
	opencdk oww openssh openssl openvpn \
	palantir pango patch pcre php php-apache php-fcgi php-thttpd phpmyadmin pkgconfig \
	popt poptop portmap postgresql postfix pound procmail procps proftpd psutils puppy pwgen \
	python pyrex \
	py-4suite py-amara py-apsw \
	py-bazaar-ng py-bittorrent py-bluez py-celementtree py-cheetah py-cherrypy py-cherrytemplate \
	py-clips py-configobj py-constraint py-crypto py-curl py-django py-docutils py-elementtree \
	py-formencode py-gdchart2 py-gd py-kid py-lxml py-nose \
	py-mercurial py-moin py-mssql py-mx-base py-mysql py-myghty \
	py-paste py-pastedeploy py-pastescript py-pil py-protocols \
	py-psycopg py-psycopg2 py-pygresql py-pgsql py-quixote \
	py-rdiff-backup py-reportlab py-routes py-roundup py-ruledispatch \
	py-scgi py-serial py-setuptools py-simplejson py-simpy py-soappy \
	py-sqlalchemy py-sqlite py-sqlobject \
	py-tgfastdata py-turbocheetah py-turbogears py-turbojson py-turbokid \
	py-urwid py-yaml py-xml py-zope-interface \
	py-twisted py-axiom py-epsilon py-mantissa py-nevow \
	qemu qemu-libc-i386 quagga  \
	rcs rdate readline recode recordext renderext rrdtool \
	rsync rtorrent ruby rubygems \
	sablevm samba sane-backends scons sdl ser setpwc siproxd sm snownews \
	screen sed smartmontools sqlite sqlite2 strace syslog-ng \
	sqsh squeak stunnel streamripper sudo swi-prolog svn \
	sysstat \
	taged tcl tcpwrappers tethereal tftp-hpa \
	tar tcpdump termcap textutils thttpd \
	tin torrent transcode transmission tsocks \
	ttf-bitstream-vera \
	ufsd unfs3 units unrar \
	unzip usbutils ushare \
	vblade vdr-mediamvp vim vorbis-tools vsftpd vte \
	w3cam w3m webalizer wget-ssl wizd \
	wakelan which whois wpa-supplicant wxbase \
	x11 xau xauth xaw xchat xcursor xdmcp xdpyinfo xext xextensions xfixes xft xinetd \
	xmail xmu xpdf xpm xproto xrender xt xterm xtrans xtst xvid \
	zip zlib \

PERL_PACKAGES_CROSS_AND_NATIVE = \
	perl-algorithm-diff perl-appconfig perl-archive-tar perl-archive-zip \
	perl-business-isbn-data perl-business-isbn \
	perl-cgi-application perl-class-accessor perl-class-data-inheritable perl-class-trigger \
	perl-clone perl-convert-tnef perl-compress-zlib \
	perl-date-manip perl-db-file perl-dbi perl-dbix-contextualfetch \
	perl-digest-hmac perl-digest-sha1 perl-digest-sha \
	perl-extutils-cbuilder perl-extutils-parsexs \
	perl-gd perl-gd-barcode \
	perl-html-parser perl-html-tagset perl-html-template \
	perl-ima-dbi perl-io-string perl-io-stringy perl-io-zlib \
	perl-mime-base64 perl-mime-tools perl-module-build \
        perl-module-signature \
	perl-net-dns perl-net-ident \
	perl-par-dist perl-pod-readme \
	perl-storable \
	perl-template-toolkit perl-term-readkey perl-text-diff perl-time-hires \
	perl-unicode-map perl-unicode-string perl-universal-moniker perl-uri \
	perl-version \
	spamassassin \

# autoconf compiles in a path to m4, and also wants to run it at that path.
# bison cross-compiles, but can't build flex.  native-compiled bison is fine.
# bogofilter's configure wants to run some small executables
# cdrtools makes no provision in the build for cross-compilation.  It
#   *always* uses shell calls to uname to determine the target arch.
# cyrus-imapd fails with "impossible constraint in `asm'" when cross-compiled
# emacs and xemacs needs to run themselves to dump an image, so they probably will never cross-compile.
# ocaml does not use gnu configure, cross build may work by some more tweaking, build native first
# openldap runs its own binaries at compile-time and expects them to have same byte-order as target
# perl's Configure is not cross-compile "friendly"
# perl modules depend on perl
# rsnapshot depends on perl
# squid probably will build cross - may just need some configure work
# stow depends on perl
COMMON_NATIVE_PACKAGES = \
	autoconf \
	bison \
	bogofilter \
	cdrtools \
	cyrus-imapd \
	emacs \
	xemacs \
	hugs \
	mzscheme \
        ocaml \
	openldap \
	perl-class-dbi \
	perl-libwww \
	rsnapshot \
	squid \
	stow \
        xmail \

# Packages that *only* work for nslu2 - do not just put new packages here.
NSLU2_SPECIFIC_PACKAGES = upslug2 unslung-feeds unslung-devel crosstool-native \
	perl $(PERL_PACKAGES_CROSS_AND_NATIVE) \

# Packages that do not work for nslu2.
# perl-dbd-mysql: Can't exec "mysql_config": No such file or directory at Makefile.PL line 76.
NSLU2_BROKEN_PACKAGES = \
	perl-dbd-mysql \

# Packages that *only* work for wl500g - do not just put new packages here.
WL500G_SPECIFIC_PACKAGES = wiley-feeds libuclibc++ 

# Packages that do not work for wl500g.
WL500G_BROKEN_PACKAGES = \
	 amule asterisk atk bitlbee bsdmainutils bzflag dcraw dict dnsmasq \
	 ecl elinks erlang ficy freetds gambit-c gawk \
	 giftcurs git-core glib gnupg gtk hnb ice \
	 id3lib iperf iptables irssi ivorbis-tools jabber jamvm jikes \
	 ldconfig lftp libdvb libftdi liblcms libtorrent libvorbisidec lsof \
	 mc mdadm mod-fastcgi mod-python monotone mtr mutt \
	 ncursesw nfs-server nfs-utils nget ntfsprogs ntp nvi \
	 nylon pango postfix py-mssql qemu qemu-libc-i386 rtorrent sablevm \
	 sdl ser sm snownews sqsh sudo swi-prolog \
	 tethereal transcode unrar vte w3m wget-ssl wxbase x11 \
	 xauth xaw xchat xcursor xdpyinfo xext xfixes \
	 xft xmu xpm xrender xt xterm xtst \

# Packages that do not work for uclibc
UCLIBC_BROKEN_PACKAGES = \
	 amule bitlbee bzflag elinks erlang ficy gambit-c \
	 gtk ice id3lib iperf iptables ivorbis-tools jabber \
	 jamvm ldconfig libdvb libtorrent libvorbisidec monotone \
	 mtr net-tools nfs-server nfs-utils nget \
	 pango procps qemu qemu-libc-i386 rtorrent sdl ser sm \
	 snownews transcode vte wxbase xauth xaw xchat xcursor xfixes xft \
	 xmu xrender xt xterm

# Packages that *only* work for uclibc - do not just put new packages here.
UCLIBC_SPECIFIC_PACKAGES = $(WL500G_SPECIFIC_PACKAGES) buildroot uclibc ipkg

# Packages that *only* work for mss - do not just put new packages here.
MSS_SPECIFIC_PACKAGES = 

# Packages that do not work for mss.
MSS_BROKEN_PACKAGES = \
	amule apache apr-util asterisk \
	bitlbee \
	clamav \
	elinks erlang \
	gambit-c gawk \
	ivorbis-tools \
	jamvm \
	ldconfig libvorbisidec lsof \
	mod-fastcgi mod-python monotone mtr \
	ntp \
	php-apache py-lxml \
	qemu qemu-libc-i386 \
	sablevm svn \
	transcode \
	tethereal \
	wxbase \

# Packages that *only* work for ds101 - do not just put new packages here.
DS101_SPECIFIC_PACKAGES = 

# Packages that do not work for ds101.
# gnuplot - matrix.c:337: In function `lu_decomp': internal compiler error: Segmentation fault
DS101_BROKEN_PACKAGES = \
	adns amule apache appweb apr-util \
	atftp bash bitchx bzflag \
	ctcs ctorrent cyrus-sasl dspam eaccelerator \
	enhanced-ctorrent freeradius gnuplot hexcurse \
	imagemagick \
	ldconfig lftp libstdc++ lighttpd \
	mc mod-fastcgi mod-python monotone motion mysql \
	net-tools nmap nzbget \
	php php-apache \
	py-mysql \
	qemu qemu-libc-i386 \
	svn \
	tcpwrappers tethereal textutils unrar

# Packages that *only* work for ds101j - do not just put new packages here.
DS101J_SPECIFIC_PACKAGES = bip

# Packages that do not work for ds101j.
DS101J_BROKEN_PACKAGES = \
	apache apr-util \
	ctcs \
	cyrus-sasl \
	enhanced-ctorrent \
	glib \
	imagemagick irssi \
	mod-fastcgi mod-python monotone \
	php-apache \
	qemu qemu-libc-i386 \
	svn \
	atk bitlbee ctrlproxy giftcurs gkrellm irssi pango \

# Packages that *only* work for ds101g+ - do not just put new packages here.
DS101G_SPECIFIC_PACKAGES = perl $(PERL_PACKAGES_CROSS_AND_NATIVE)

# Packages that do not work for ds101g+.
# elinks, gawk, lsof, mtr and ntp need a .mk template update (they emit _armeb.ipks)
DS101G_BROKEN_PACKAGES = \
	appweb \
	bitlbee \
	cherokee \
	eaccelerator \
	flac freeradius \
	gnutls \
	ivorbis-tools \
	ldconfig libgcrypt libvorbisidec lsof \
	mod-python mtr ntop ntp \
	opencdk \
	qemu qemu-libc-i386 \
	rsync \
	ser \
	bogofilter emacs xemacs hugs mzscheme ocaml \
	rsnapshot \
	squid \

# Packages that *only* work for nas100d - do not just put new packages here.
NAS100D_SPECIFIC_PACKAGES = ipkg

# Packages that do not work for nas100d.
NAS100D_BROKEN_PACKAGES = 

# Packages that *only* work for fsg3 - do not just put new packages here.
FSG3_SPECIFIC_PACKAGES = 

# Packages that do not work for fsg3.
FSG3_BROKEN_PACKAGES = \
	adns amule apache appweb apr-util \
	atftp bash bitchx bzflag \
	ctcs ctorrent cyrus-sasl eaccelerator \
	enhanced-ctorrent freeradius hexcurse \
	imagemagick \
	ldconfig lftp libstdc++ lighttpd \
	mc mod-fastcgi mod-python monotone motion mysql \
	net-tools nmap nzbget \
	php php-apache \
	py-mysql \
	qemu qemu-libc-i386 \
	svn \
	tcpwrappers tethereal textutils transcode unrar

# dump: is broken in several ways. It is using the host's e2fsprogs
# includes.  It is also misconfigured: --includedir and --libdir as
# arguments to configure affect installation directories, not where
# things get searched for.  I think it would be best to rewrite this
# .mk from scratch, following template.mk.
# 
# libao - has runtime trouble
# parted - does not work on the slug, even when compiled natively
# lumikki - does not install to /opt
# doxygen - host binary, not stripped
# py-twisted - "twisted.python.dist module not found.  Make sure you have installed the Twisted core package before attempting to install any other Twisted projects. Error: Subprocess exited with result 1 for project conch"
# py-epsilon - depends on py-twisted
# py-axiom py-mantissa py-nevow - depend on py-epsilon
PACKAGES_THAT_NEED_TO_BE_FIXED = dump libao nethack scponly gkrellm parted lumikki mini_httpd \
	doxygen \
	libextractor \

# libiconv - has been made obsolete by gconv-modules
# git - has been made obsolete by git-core
# Metalog - has been made obsolete by syslog-ng
PACKAGES_OBSOLETED = libiconv git metalog perl-spamassassin

ifeq ($(OPTWARE_TARGET),nslu2)
ifeq ($(HOST_MACHINE),armv5b)
PACKAGES = $(COMMON_NATIVE_PACKAGES)
PACKAGES_READY_FOR_TESTING = $(NATIVE_PACKAGES_READY_FOR_TESTING)
# when native building on unslung, it's important to have a working awk 
# in the path ahead of busybox's broken one.
PATH=/opt/bin:/usr/bin:/bin
else
PACKAGES = $(filter-out $(NSLU2_NATIVE_PACKAGES) $(NSLU2_BROKEN_PACKAGES), $(COMMON_CROSS_PACKAGES) $(NSLU2_SPECIFIC_PACKAGES))
PACKAGES_READY_FOR_TESTING = $(CROSS_PACKAGES_READY_FOR_TESTING)
endif
TARGET_ARCH=armeb
TARGET_OS=linux
endif

ifeq ($(OPTWARE_TARGET),wl500g)
PACKAGES = $(filter-out $(WL500G_BROKEN_PACKAGES), $(COMMON_CROSS_PACKAGES) $(WL500G_SPECIFIC_PACKAGES))
PACKAGES_READY_FOR_TESTING = $(CROSS_PACKAGES_READY_FOR_TESTING)
TARGET_ARCH=mipsel
TARGET_OS=linux-uclibc
endif

ifeq ($(OPTWARE_TARGET),mss)
PACKAGES = $(filter-out $(MSS_BROKEN_PACKAGES), $(COMMON_CROSS_PACKAGES) $(MSS_SPECIFIC_PACKAGES))
PACKAGES_READY_FOR_TESTING = $(CROSS_PACKAGES_READY_FOR_TESTING)
TARGET_ARCH=mipsel
TARGET_OS=linux
endif

ifeq ($(OPTWARE_TARGET),ds101)
PACKAGES = $(filter-out $(DS101_BROKEN_PACKAGES), $(COMMON_CROSS_PACKAGES) $(DS101_SPECIFIC_PACKAGES))
PACKAGES_READY_FOR_TESTING = $(CROSS_PACKAGES_READY_FOR_TESTING)
TARGET_ARCH=armeb
TARGET_OS=linux
endif

ifeq ($(OPTWARE_TARGET),ds101j)
PACKAGES = $(filter-out $(DS101J_BROKEN_PACKAGES), $(COMMON_CROSS_PACKAGES) $(DS101J_SPECIFIC_PACKAGES))
PACKAGES_READY_FOR_TESTING = $(CROSS_PACKAGES_READY_FOR_TESTING)
TARGET_ARCH=armeb
TARGET_OS=linux
endif

ifeq ($(OPTWARE_TARGET),ds101g)
ifeq ($(HOST_MACHINE),ppc)
PACKAGES = $(filter-out $(DS101G_BROKEN_PACKAGES), $(COMMON_NATIVE_PACKAGES))
PACKAGES_READY_FOR_TESTING = $(NATIVE_PACKAGES_READY_FOR_TESTING)
else
PACKAGES = $(filter-out $(DS101G_BROKEN_PACKAGES), $(COMMON_CROSS_PACKAGES) $(DS101G_SPECIFIC_PACKAGES))
PACKAGES_READY_FOR_TESTING = $(CROSS_PACKAGES_READY_FOR_TESTING)
endif
TARGET_ARCH=powerpc
TARGET_OS=linux
endif

ifeq ($(OPTWARE_TARGET),nas100d)
PACKAGES = $(filter-out $(NAS100D_BROKEN_PACKAGES), $(COMMON_CROSS_PACKAGES) $(NAS100D_SPECIFIC_PACKAGES))
PACKAGES_READY_FOR_TESTING = $(CROSS_PACKAGES_READY_FOR_TESTING)
TARGET_ARCH=armeb
TARGET_OS=linux
endif

ifeq ($(OPTWARE_TARGET),fsg3)
PACKAGES = $(filter-out $(FSG3_BROKEN_PACKAGES), $(COMMON_CROSS_PACKAGES) $(FSG3_SPECIFIC_PACKAGES))
PACKAGES_READY_FOR_TESTING = $(CROSS_PACKAGES_READY_FOR_TESTING)
TARGET_ARCH=armeb
TARGET_OS=linux
endif

all: directories toolchain packages

testing:
	$(MAKE) PACKAGES="$(PACKAGES_READY_FOR_TESTING)" all
	$(PERL) -w scripts/optware-check-package.pl --target=$(OPTWARE_TARGET) --objdump-path=$(TARGET_CROSS)objdump --base-dir=$(BASE_DIR) $(patsubst %,$(BUILD_DIR)/%*.ipk,$(PACKAGES_READY_FOR_TESTING))

# Common tools which may need overriding
CVS=cvs
SUDO=sudo
WGET=wget --passive-ftp
PERL=perl

# The hostname or IP number of our local dl.sf.net mirror
SOURCEFORGE_MIRROR=easynews.dl.sf.net

# Directory location definitions
BASE_DIR:=$(shell pwd)
SOURCE_DIR=$(BASE_DIR)/sources
DL_DIR=$(BASE_DIR)/downloads
BUILD_DIR=$(BASE_DIR)/builds
STAGING_DIR=$(BASE_DIR)/staging
STAGING_PREFIX=$(STAGING_DIR)/opt
TOOL_BUILD_DIR=$(BASE_DIR)/toolchain
PACKAGE_DIR=$(BASE_DIR)/packages
export TMPDIR=$(BASE_DIR)/tmp

TARGET_OPTIMIZATION=-O2 #-mtune=xscale -march=armv4 -Wa,-mcpu=xscale
TARGET_DEBUGGING= #-g

ifeq ($(OPTWARE_TARGET),nslu2)
CROSS_CONFIGURATION_GCC_VERSION=3.3.5
CROSS_CONFIGURATION_GLIBC_VERSION=2.2.5
CROSS_CONFIGURATION_GCC=gcc-$(CROSS_CONFIGURATION_GCC_VERSION)
CROSS_CONFIGURATION_GLIBC=glibc-$(CROSS_CONFIGURATION_GLIBC_VERSION)
CROSS_CONFIGURATION = $(CROSS_CONFIGURATION_GCC)-$(CROSS_CONFIGURATION_GLIBC)
ifeq ($(HOST_MACHINE),armv5b)
HOSTCC = $(TARGET_CC)
GNU_HOST_NAME = armv5b-softfloat-linux
GNU_TARGET_NAME = armv5b-softfloat-linux
TARGET_CROSS = /opt/$(TARGET_ARCH)/bin/$(GNU_TARGET_NAME)-
TARGET_LIBDIR = /opt/$(TARGET_ARCH)/$(GNU_TARGET_NAME)/lib
TARGET_LDFLAGS = -L/opt/lib
TARGET_CUSTOM_FLAGS=
TARGET_CFLAGS=-I/opt/include $(TARGET_OPTIMIZATION) $(TARGET_DEBUGGING) $(TARGET_CUSTOM_FLAGS)
toolchain:
else
HOSTCC = gcc
GNU_HOST_NAME = $(HOST_MACHINE)-pc-linux-gnu
GNU_TARGET_NAME = armv5b-softfloat-linux
TARGET_CROSS = $(TOOL_BUILD_DIR)/$(GNU_TARGET_NAME)/$(CROSS_CONFIGURATION)/bin/$(GNU_TARGET_NAME)-
TARGET_LIBDIR = $(TOOL_BUILD_DIR)/$(GNU_TARGET_NAME)/$(CROSS_CONFIGURATION)/$(GNU_TARGET_NAME)/lib
TARGET_LDFLAGS = 
TARGET_CUSTOM_FLAGS= -pipe 
TARGET_CFLAGS=$(TARGET_OPTIMIZATION) $(TARGET_DEBUGGING) $(TARGET_CUSTOM_FLAGS)
toolchain: crosstool
endif
endif

ifeq ($(OPTWARE_TARGET),wl500g)
LIBC_STYLE=uclibc
HOSTCC = gcc
GNU_HOST_NAME = $(HOST_MACHINE)-pc-linux-gnu
GNU_TARGET_NAME = mipsel-linux
CROSS_CONFIGURATION = hndtools-mipsel-uclibc
TARGET_CROSS = /opt/brcm/$(CROSS_CONFIGURATION)/bin/mipsel-uclibc-
TARGET_LIBDIR = /opt/brcm/$(CROSS_CONFIGURATION)/lib
TARGET_LDFLAGS = 
TARGET_CUSTOM_FLAGS= -pipe 
TARGET_CFLAGS=$(TARGET_OPTIMIZATION) $(TARGET_DEBUGGING) $(TARGET_CUSTOM_FLAGS)
toolchain:
endif

ifeq ($(OPTWARE_TARGET), oleg)
LIBC_STYLE=uclibc
TARGET_ARCH=mipsel
BUILDROOT_CUSTOM_HEADERS = $(HEADERS_OLEG)
endif

ifeq ($(OPTWARE_TARGET), ddwrt)
LIBC_STYLE=uclibc
TARGET_ARCH=mipsel
BUILDROOT_CUSTOM_HEADERS = $(HEADERS_DDWRT)
endif

ifeq ($(LIBC_STYLE), uclibc)
ifneq ($(OPTWARE_TARGET), wl500g)
PACKAGES = $(filter-out $(UCLIBC_BROKEN_PACKAGES), $(COMMON_CROSS_PACKAGES) $(UCLIBC_SPECIFIC_PACKAGES))
PACKAGES_READY_FOR_TESTING = $(CROSS_PACKAGES_READY_FOR_TESTING)
TARGET_OS=linux-uclibc
HOSTCC = gcc
GNU_HOST_NAME = $(HOST_MACHINE)-pc-linux-gnu
GNU_TARGET_NAME=$(TARGET_ARCH)-linux
CROSS_CONFIGURATION_GCC_VERSION=3.4.6
CROSS_CONFIGURATION_UCLIBC_VERSION=0.9.28
BUILDROOT_GCC=$(CROSS_CONFIGURATION_GCC_VERSION)
UCLIBC_VERSION=$(CROSS_CONFIGURATION_UCLIBC_VERSION)
CROSS_CONFIGURATION_GCC=gcc-$(CROSS_CONFIGURATION_GCC_VERSION)
CROSS_CONFIGURATION_UCLIBC=uclibc-$(CROSS_CONFIGURATION_UCLIBC_VERSION)
CROSS_CONFIGURATION=$(CROSS_CONFIGURATION_GCC)-$(CROSS_CONFIGURATION_UCLIBC)
TARGET_CROSS = $(TOOL_BUILD_DIR)/$(TARGET_ARCH)-$(TARGET_OS)/$(CROSS_CONFIGURATION)/bin/$(TARGET_ARCH)-$(TARGET_OS)-
TARGET_LIBDIR = $(TOOL_BUILD_DIR)/$(TARGET_ARCH)-$(TARGET_OS)/$(CROSS_CONFIGURATION)/lib
TARGET_LDFLAGS = 
TARGET_CUSTOM_FLAGS= -pipe 
TARGET_CFLAGS=$(TARGET_OPTIMIZATION) $(TARGET_DEBUGGING) $(TARGET_CUSTOM_FLAGS)
toolchain: buildroot-toolchain libuclibc++-toolchain
endif
else
LIBC_STYLE=glibc
endif

ifeq ($(OPTWARE_TARGET),mss)
HOSTCC = gcc
GNU_HOST_NAME = $(HOST_MACHINE)-pc-linux-gnu
GNU_TARGET_NAME = mipsel-linux
CROSS_CONFIGURATION = hndtools-mipsel-linux
TARGET_CROSS = /opt/brcm/$(CROSS_CONFIGURATION)/bin/$(GNU_TARGET_NAME)-
TARGET_LIBDIR = /opt/brcm/$(CROSS_CONFIGURATION)/$(GNU_TARGET_NAME)/lib
TARGET_LDFLAGS = 
TARGET_CUSTOM_FLAGS= -pipe 
TARGET_CFLAGS=$(TARGET_OPTIMIZATION) $(TARGET_DEBUGGING) $(TARGET_CUSTOM_FLAGS)
toolchain:
endif

ifeq ($(OPTWARE_TARGET),ds101)
CROSS_CONFIGURATION_GCC_VERSION=3.3.5
CROSS_CONFIGURATION_GLIBC_VERSION=2.2.5
CROSS_CONFIGURATION_GCC=gcc-$(CROSS_CONFIGURATION_GCC_VERSION)
CROSS_CONFIGURATION_GLIBC=glibc-$(CROSS_CONFIGURATION_GLIBC_VERSION)
CROSS_CONFIGURATION = $(CROSS_CONFIGURATION_GCC)-$(CROSS_CONFIGURATION_GLIBC)
HOSTCC = gcc
GNU_HOST_NAME = $(HOST_MACHINE)-pc-linux-gnu
GNU_TARGET_NAME = armv5b-softfloat-linux
TARGET_CROSS = $(TOOL_BUILD_DIR)/$(GNU_TARGET_NAME)/$(CROSS_CONFIGURATION)/bin/$(GNU_TARGET_NAME)-
TARGET_LIBDIR = $(TOOL_BUILD_DIR)/$(GNU_TARGET_NAME)/$(CROSS_CONFIGURATION)/$(GNU_TARGET_NAME)/lib
TARGET_LDFLAGS =
TARGET_CUSTOM_FLAGS= -pipe
TARGET_CFLAGS=$(TARGET_OPTIMIZATION) $(TARGET_DEBUGGING) $(TARGET_CUSTOM_FLAGS)
toolchain: crosstool
endif

ifeq ($(OPTWARE_TARGET),ds101j)
CROSS_CONFIGURATION_GCC_VERSION=3.3.4
CROSS_CONFIGURATION_GLIBC_VERSION=2.3.3
CROSS_CONFIGURATION_GCC=gcc-$(CROSS_CONFIGURATION_GCC_VERSION)
CROSS_CONFIGURATION_GLIBC=glibc-$(CROSS_CONFIGURATION_GLIBC_VERSION)
CROSS_CONFIGURATION = $(CROSS_CONFIGURATION_GCC)-$(CROSS_CONFIGURATION_GLIBC)
HOSTCC = gcc
GNU_HOST_NAME = $(HOST_MACHINE)-pc-linux-gnu
GNU_TARGET_NAME = armv5b-softfloat-linux
TARGET_CROSS = $(TOOL_BUILD_DIR)/$(GNU_TARGET_NAME)/$(CROSS_CONFIGURATION)/bin/$(GNU_TARGET_NAME)-
TARGET_LIBDIR = $(TOOL_BUILD_DIR)/$(GNU_TARGET_NAME)/$(CROSS_CONFIGURATION)/$(GNU_TARGET_NAME)/lib
TARGET_LDFLAGS =
TARGET_CUSTOM_FLAGS= -pipe
TARGET_CFLAGS=$(TARGET_OPTIMIZATION) $(TARGET_DEBUGGING) $(TARGET_CUSTOM_FLAGS)
toolchain: crosstool
endif

ifeq ($(OPTWARE_TARGET),ds101g)
CROSS_CONFIGURATION_GCC_VERSION=3.3.4
CROSS_CONFIGURATION_GLIBC_VERSION=2.3.3
CROSS_CONFIGURATION_GCC=gcc-$(CROSS_CONFIGURATION_GCC_VERSION)
CROSS_CONFIGURATION_GLIBC=glibc-$(CROSS_CONFIGURATION_GLIBC_VERSION)
CROSS_CONFIGURATION = $(CROSS_CONFIGURATION_GCC)-$(CROSS_CONFIGURATION_GLIBC)
ifeq ($(HOST_MACHINE),ppc)
HOSTCC = $(TARGET_CC)
GNU_HOST_NAME = powerpc-603e-linux
GNU_TARGET_NAME = powerpc-603e-linux
TARGET_CROSS = /opt/$(TARGET_ARCH)/bin/$(GNU_TARGET_NAME)-
TARGET_LIBDIR = /opt/$(TARGET_ARCH)/$(GNU_TARGET_NAME)/lib
TARGET_LDFLAGS = -L/opt/lib
TARGET_CUSTOM_FLAGS=
TARGET_CFLAGS=-I/opt/include $(TARGET_OPTIMIZATION) $(TARGET_DEBUGGING) $(TARGET_CUSTOM_FLAGS)
toolchain:
else
HOSTCC = gcc
GNU_HOST_NAME = $(HOST_MACHINE)-pc-linux-gnu
GNU_TARGET_NAME = powerpc-603e-linux
TARGET_CROSS = $(TOOL_BUILD_DIR)/$(GNU_TARGET_NAME)/$(CROSS_CONFIGURATION)/bin/$(GNU_TARGET_NAME)-
TARGET_LIBDIR = $(TOOL_BUILD_DIR)/$(GNU_TARGET_NAME)/$(CROSS_CONFIGURATION)/$(GNU_TARGET_NAME)/lib
TARGET_LDFLAGS =
TARGET_CUSTOM_FLAGS= -pipe
TARGET_CFLAGS=$(TARGET_OPTIMIZATION) $(TARGET_DEBUGGING) $(TARGET_CUSTOM_FLAGS)
toolchain: crosstool
endif
endif

ifeq ($(OPTWARE_TARGET),nas100d)
CROSS_CONFIGURATION_GCC_VERSION=3.3.5
CROSS_CONFIGURATION_GLIBC_VERSION=2.2.5
CROSS_CONFIGURATION_GCC=gcc-$(CROSS_CONFIGURATION_GCC_VERSION)
CROSS_CONFIGURATION_GLIBC=glibc-$(CROSS_CONFIGURATION_GLIBC_VERSION)
CROSS_CONFIGURATION = $(CROSS_CONFIGURATION_GCC)-$(CROSS_CONFIGURATION_GLIBC)
HOSTCC = gcc
GNU_HOST_NAME = $(HOST_MACHINE)-pc-linux-gnu
GNU_TARGET_NAME = armv5b-softfloat-linux
TARGET_CROSS = $(TOOL_BUILD_DIR)/$(GNU_TARGET_NAME)/$(CROSS_CONFIGURATION)/bin/$(GNU_TARGET_NAME)-
TARGET_LIBDIR = $(TOOL_BUILD_DIR)/$(GNU_TARGET_NAME)/$(CROSS_CONFIGURATION)/$(GNU_TARGET_NAME)/lib
TARGET_LDFLAGS =
TARGET_CUSTOM_FLAGS= -pipe
TARGET_CFLAGS=$(TARGET_OPTIMIZATION) $(TARGET_DEBUGGING) $(TARGET_CUSTOM_FLAGS)
toolchain: crosstool
endif

ifeq ($(OPTWARE_TARGET),fsg3)
CROSS_CONFIGURATION_GCC_VERSION=3.3.5
CROSS_CONFIGURATION_GLIBC_VERSION=2.2.5
CROSS_CONFIGURATION_GCC=gcc-$(CROSS_CONFIGURATION_GCC_VERSION)
CROSS_CONFIGURATION_GLIBC=glibc-$(CROSS_CONFIGURATION_GLIBC_VERSION)
CROSS_CONFIGURATION = $(CROSS_CONFIGURATION_GCC)-$(CROSS_CONFIGURATION_GLIBC)
HOSTCC = gcc
GNU_HOST_NAME = $(HOST_MACHINE)-pc-linux-gnu
GNU_TARGET_NAME = armv5b-softfloat-linux
TARGET_CROSS = $(TOOL_BUILD_DIR)/$(GNU_TARGET_NAME)/$(CROSS_CONFIGURATION)/bin/$(GNU_TARGET_NAME)-
TARGET_LIBDIR = $(TOOL_BUILD_DIR)/$(GNU_TARGET_NAME)/$(CROSS_CONFIGURATION)/$(GNU_TARGET_NAME)/lib
TARGET_LDFLAGS =
TARGET_CUSTOM_FLAGS= -pipe
TARGET_CFLAGS=$(TARGET_OPTIMIZATION) $(TARGET_DEBUGGING) $(TARGET_CUSTOM_FLAGS)
toolchain: crosstool
endif


TARGET_CXX=$(TARGET_CROSS)g++
TARGET_CC=$(TARGET_CROSS)gcc
TARGET_CPP="$(TARGET_CC) -E"
TARGET_LD=$(TARGET_CROSS)ld
TARGET_AR=$(TARGET_CROSS)ar
TARGET_AS=$(TARGET_CROSS)as
TARGET_NM=$(TARGET_CROSS)nm
TARGET_RANLIB=$(TARGET_CROSS)ranlib
TARGET_STRIP=$(TARGET_CROSS)strip
TARGET_CONFIGURE_OPTS= \
	AR=$(TARGET_AR) \
	AS=$(TARGET_AS) \
	LD=$(TARGET_LD) \
	NM=$(TARGET_NM) \
	CC=$(TARGET_CC) \
	CPP=$(TARGET_CPP) \
	GCC=$(TARGET_CC) \
	CXX=$(TARGET_CXX) \
	RANLIB=$(TARGET_RANLIB) \
	STRIP=$(TARGET_STRIP)
TARGET_PATH=$(STAGING_PREFIX)/bin:$(STAGING_DIR)/bin:/opt/bin:/opt/sbin:/bin:/sbin:/usr/bin:/usr/sbin

STRIP_COMMAND=$(TARGET_STRIP) --remove-section=.comment --remove-section=.note --strip-unneeded

PATCH_LIBTOOL=sed -i \
	-e 's|^sys_lib_search_path_spec=.*"$$|sys_lib_search_path_spec="$(TARGET_LIBDIR) $(STAGING_LIB_DIR)"|' \
	-e 's|^sys_lib_dlsearch_path_spec=.*"$$|sys_lib_dlsearch_path_spec=""|'

STAGING_INCLUDE_DIR=$(STAGING_PREFIX)/include
STAGING_LIB_DIR=$(STAGING_PREFIX)/lib

STAGING_CPPFLAGS=$(TARGET_CFLAGS) -I$(STAGING_INCLUDE_DIR)
STAGING_LDFLAGS=$(TARGET_LDFLAGS) -L$(STAGING_LIB_DIR) -Wl,-rpath,/opt/lib -Wl,-rpath-link,$(STAGING_LIB_DIR)

# Clear these variables to remove assumptions
AR=
AS=
LD=
NM=
CC=
GCC=
CXX=
RANLIB=
STRIP=
LD_LIBRARY_PATH=

PACKAGES_CLEAN:=$(patsubst %,%-clean,$(PACKAGES))
PACKAGES_SOURCE:=$(patsubst %,%-source,$(PACKAGES))
PACKAGES_DIRCLEAN:=$(patsubst %,%-dirclean,$(PACKAGES))
PACKAGES_STAGE:=$(patsubst %,%-stage,$(PACKAGES))
PACKAGES_IPKG:=$(patsubst %,%-ipk,$(PACKAGES))

ifneq ($(HOSTCC), $(TARGET_CC))
PERL_CROSS_TARGETS=:ds101g:nslu2:
endif

$(PACKAGES) : directories toolchain
$(PACKAGES_STAGE) %-stage : directories toolchain
$(PACKAGES_IPKG) %-ipk : directories toolchain ipkg-utils

.PHONY: index
index: $(PACKAGE_DIR)/Packages

$(PACKAGE_DIR)/Packages: $(BUILD_DIR)/*.ipk
	rsync -avr --delete $(BUILD_DIR)/*_$(TARGET_ARCH).ipk $(PACKAGE_DIR)/
	{ \
		cd $(PACKAGE_DIR); \
		$(IPKG_MAKE_INDEX) . > Packages; \
		gzip -c Packages > Packages.gz; \
	}
	@echo "ALL DONE."

packages: $(PACKAGES_IPKG)
	$(MAKE) index

.PHONY: all clean dirclean distclean directories packages source toolchain \
	autoclean \
	$(PACKAGES) $(PACKAGES_SOURCE) $(PACKAGES_DIRCLEAN) \
	$(PACKAGES_STAGE) $(PACKAGES_IPKG) \
	query-%

query-%:
	@echo $($(*))

include make/*.mk

directories: $(DL_DIR) $(BUILD_DIR) $(STAGING_DIR) $(STAGING_PREFIX) \
	$(STAGING_LIB_DIR) $(STAGING_INCLUDE_DIR) $(TOOL_BUILD_DIR) \
	$(PACKAGE_DIR) $(TMPDIR)

$(DL_DIR):
	mkdir $(DL_DIR)

$(BUILD_DIR):
	mkdir $(BUILD_DIR)

$(STAGING_DIR):
	mkdir $(STAGING_DIR)

$(STAGING_PREFIX):
	mkdir $(STAGING_PREFIX)

$(STAGING_LIB_DIR):
	mkdir $(STAGING_LIB_DIR)

$(STAGING_INCLUDE_DIR):
	mkdir $(STAGING_INCLUDE_DIR)

$(TOOL_BUILD_DIR):
	mkdir $(TOOL_BUILD_DIR)

$(PACKAGE_DIR):
	mkdir $(PACKAGE_DIR)

$(TMPDIR):
	mkdir $(TMPDIR)

source: $(PACKAGES_SOURCE)

check-packages:
	@$(PERL) -w scripts/optware-check-package.pl --target=$(OPTWARE_TARGET) --objdump-path=$(TARGET_CROSS)objdump --base-dir=$(BASE_DIR) $(filter-out $(BUILD_DIR)/crosstool-native-%,$(wildcard $(BUILD_DIR)/*.ipk))

autoclean:
	$(PERL) -w scripts/optware-autoclean.pl -v -C $(BASE_DIR)

clean: $(TARGETS_CLEAN) $(PACKAGES_CLEAN)
	find . -name '*~' -print | xargs /bin/rm -f
	find . -name '.*~' -print | xargs /bin/rm -f
	find . -name '.#*' -print | xargs /bin/rm -f

dirclean: $(PACKAGES_DIRCLEAN)

distclean:
	rm -rf $(BUILD_DIR) $(STAGING_DIR) $(PACKAGE_DIR) nslu2 wl500g mss nas100d ds101 ds101j ds101g fsg3

toolclean:
	rm -rf $(TOOL_BUILD_DIR)

make/%.mk:
	PKG_UP=$$(echo $* | tr [a-z\-] [A-Z_]);			\
	sed -e "s/<foo>/$*/g" -e "s/<FOO>/$${PKG_UP}/g"		\
		 -e '6,11d' make/template.mk > $@
