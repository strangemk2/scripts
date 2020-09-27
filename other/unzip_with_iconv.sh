# Unzip with iconv
# Patch from https://bugs.archlinux.org/task/15256
wget http://ftp.debian.org/debian/pool/main/u/unzip/unzip_6.0.orig.tar.gz
wget http://ftp.debian.org/debian/pool/main/u/unzip/unzip_6.0-25.debian.tar.xz
wget https://bugs.archlinux.org/task/15256?getfile=3685 -O unzip60-alt-iconv-utf8.patch

tar xf unzip_6.0.orig.tar.gz
tar xf unzip_6.0-25.debian.tar.xz
cd unzip60

patch -p1 < ../debian/patches/01-manpages-in-section-1-not-in-section-1l.patch
patch -p1 < ../debian/patches/03-include-unistd-for-kfreebsd.patch
patch -p1 < ../debian/patches/04-handle-pkware-verification-bit.patch
patch -p1 < ../debian/patches/05-fix-uid-gid-handling.patch
patch -p1 < ../debian/patches/06-initialize-the-symlink-flag.patch
patch -p1 < ../debian/patches/07-increase-size-of-cfactorstr.patch
patch -p1 < ../debian/patches/08-allow-greater-hostver-values.patch
patch -p1 < ../debian/patches/09-cve-2014-8139-crc-overflow.patch
patch -p1 < ../debian/patches/10-cve-2014-8140-test-compr-eb.patch
patch -p1 < ../debian/patches/11-cve-2014-8141-getzip64data.patch
patch -p1 < ../debian/patches/12-cve-2014-9636-test-compr-eb.patch
patch -p1 < ../debian/patches/13-remove-build-date.patch
patch -p1 < ../debian/patches/14-cve-2015-7696.patch
patch -p1 < ../debian/patches/15-cve-2015-7697.patch
patch -p1 < ../debian/patches/16-fix-integer-underflow-csiz-decrypted.patch
patch -p1 < ../debian/patches/17-restore-unix-timestamps-accurately.patch
patch -p1 < ../debian/patches/18-cve-2014-9913-unzip-buffer-overflow.patch
patch -p1 < ../debian/patches/19-cve-2016-9844-zipinfo-buffer-overflow.patch
patch -p1 < ../debian/patches/20-cve-2018-1000035-unzip-buffer-overflow.patch
patch -p1 < ../debian/patches/21-fix-warning-messages-on-big-files.patch
patch -p1 < ../debian/patches/22-cve-2019-13232-fix-bug-in-undefer-input.patch
patch -p1 < ../debian/patches/23-cve-2019-13232-zip-bomb-with-overlapped-entries.patch
patch -p1 < ../debian/patches/24-cve-2019-13232-do-not-raise-alert-for-misplaced-central-directory.patch
patch -p1 < ../unzip60-alt-iconv-utf8.patch
sed -i '' 1,100s/^LFLAGS1.*$/"LFLAGS1 = -liconv"/ unix/Makefile

make -f unix/Makefile generic_gcc
