# Script for build shadowsocks-libev on macos

export WORK=/var/tmp/ss
export DEST=$HOME/ss

mkdir $WORK
cd $WORK

git clone https://github.com/enki/libev
wget https://github.com/jedisct1/libsodium/releases/download/1.0.17/libsodium-1.0.17.tar.gz
wget https://github.com/ARMmbed/mbedtls/archive/mbedtls-2.16.1.tar.gz
wget https://github.com/ARMmbed/mbed-crypto/archive/mbedcrypto-1.0.0.tar.gz
wget https://github.com/c-ares/c-ares/releases/download/cares-1_15_0/c-ares-1.15.0.tar.gz
wget https://github.com/vmg/libpcre/archive/pcre-8.36.tar.gz

tar xf libsodium-1.0.17.tar.gz
tar xf mbedtls-2.16.1.tar.gz
tar xf mbedcrypto-1.0.0.tar.gz
tar xf c-ares-1.15.0.tar.gz
tar xf pcre-8.36.tar.gz

cd $WORK/libev
./configure --prefix=$DEST
make -j8 && make install

cd $WORK/libsodium-1.0.17
./configure --prefix=$DEST
make -j8 && make install

cd $WORK/mbedtls-mbedtls-2.16.1
mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX:PATH=$DEST ..
make -j8 && make install

cd $WORK/mbed-crypto-mbedcrypto-1.0.0
mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX:PATH=$DEST ..
make -j8 && make install

cd $WORK/c-ares-1.15.0
./configure --prefix=$DEST
make -j8 && make install

cd $WORK/libpcre-pcre-8.36
mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX:PATH=$DEST ..
make -j8 && make install

cd $WORK
git clone https://github.com/shadowsocks/shadowsocks-libev.git
cd shadowsocks-libev
git submodule update --init --recursive
cd build
cmake -DCMAKE_INCLUDE_PATH=$DEST/include -DCMAKE_LIBRARY_PATH=$DEST/lib -DWITH_STATIC=OFF -DCMAKE_INSTALL_PREFIX:PATH=$DEST -DCMAKE_INSTALL_RPATH=$DEST/lib ..
make -j8 && make install

cp -a lib/*.dylib $DEST/lib/

cd $DEST/bin
install_name_tool -add_rpath $DEST/lib ss-local
install_name_tool -add_rpath $DEST/lib ss-server

rm -rf $WORK
