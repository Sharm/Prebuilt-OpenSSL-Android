#!/bin/bash

. ./options.sh

MYDIR="$PWD"

if [ ! -d "$OPENSSL_SOURCE" ] ; then
  echo "Directory does not exist: $OPENSSL_SOURCE. Please run the download script first."
  exit 1 ;
fi
if [ ! -d "$ANDROID_NDK_ROOT" ] ; then
  echo "Please set ANDROID_NDK_ROOT to your Android NDK root path."
  exit 1 ;
fi

echo ""
echo "*****************************************************************************"
echo "OPENSSL_SOURCE=$OPENSSL_SOURCE"
echo "HOST_PLATFORM=$HOST_PLATFORM"
echo "ANDROID_NDK_ROOT=$ANDROID_NDK_ROOT"
echo "*****************************************************************************"
echo ""
for OPENSSL_SHARED in ${OPT_OPENSSL_SHARED[@]} ; do
  for TYPE in ${OPT_TYPE[@]} ; do
    echo "**** BUILDING FOR: $TYPE, shared: $OPENSSL_SHARED ***************************"
    cd "$MYDIR/$OPENSSL_SOURCE" || exit 1
    echo ""
    echo "**************************************************************"
    echo "*** Configuring OpenSSL for $TYPE, shared: $OPENSSL_SHARED..."
    echo "**************************************************************"
    echo ""
    if [ "$TYPE" = "armv5" ] ; then
      CCPATH="$ANDROID_NDK_ROOT/toolchains/arm-linux-androideabi-${ANDROID_NDK_TOOLCHAIN_VER}/prebuilt/$HOST_PLATFORM/bin/arm-linux-androideabi-gcc"
      ARPATH="$ANDROID_NDK_ROOT/toolchains/arm-linux-androideabi-${ANDROID_NDK_TOOLCHAIN_VER}/prebuilt/$HOST_PLATFORM/bin/arm-linux-androideabi-ar"
      ANDROID_ARCH="arch-arm"
      OPENSSL_CONFIG="android" ;
    elif [ "$TYPE" = "armv7" ] ; then
      CCPATH="$ANDROID_NDK_ROOT/toolchains/arm-linux-androideabi-${ANDROID_NDK_TOOLCHAIN_VER}/prebuilt/$HOST_PLATFORM/bin/arm-linux-androideabi-gcc"
      ARPATH="$ANDROID_NDK_ROOT/toolchains/arm-linux-androideabi-${ANDROID_NDK_TOOLCHAIN_VER}/prebuilt/$HOST_PLATFORM/bin/arm-linux-androideabi-ar"
      ANDROID_ARCH="arch-arm"
      OPENSSL_CONFIG="android-armv7" ;
    elif [ "$TYPE" = "arm64" ] ; then
      CCPATH="$ANDROID_NDK_ROOT/toolchains/aarch64-linux-android-${ANDROID_NDK_TOOLCHAIN_VER}/prebuilt/$HOST_PLATFORM/bin/aarch64-linux-android-gcc"
      ARPATH="$ANDROID_NDK_ROOT/toolchains/aarch64-linux-android-${ANDROID_NDK_TOOLCHAIN_VER}/prebuilt/$HOST_PLATFORM/bin/aarch64-linux-android-ar"
      ANDROID_ARCH="arch-arm64"
      OPENSSL_CONFIG="android64-aarch64" ;
    elif [ "$TYPE" = "x86" ] ; then
      CCPATH="$ANDROID_NDK_ROOT/toolchains/x86-${ANDROID_NDK_TOOLCHAIN_VER}/prebuilt/$HOST_PLATFORM/bin/i686-linux-android-gcc"
      ARPATH="$ANDROID_NDK_ROOT/toolchains/x86-${ANDROID_NDK_TOOLCHAIN_VER}/prebuilt/$HOST_PLATFORM/bin/i686-linux-android-ar"
      ANDROID_ARCH="arch-x86"
      OPENSSL_CONFIG="android-x86" ;
    else
      echo "Wat?"
      exit 1 ;
    fi
    if [ "$OPENSSL_SHARED" = "1" ] ; then
      OPENSSL_CONFIG="shared $OPENSSL_CONFIG"
      SUBDIR="$TYPE-shared" ;
    else
      SUBDIR="$TYPE" ;
    fi
    
    CC=$CCPATH AR=$ARPATH ./Configure $OPENSSL_CONFIG --prefix="$MYDIR/Prebuilt/$SUBDIR" || exit 1

    $MYDIR/patch_makefile.sh || exit 1

    echo ""
    echo "**************************************************************"
    echo "*** Making OpenSSL for $TYPE / $SUBDIR..."
    echo "**************************************************************"
    echo ""
    ANDROID_DEV="$ANDROID_NDK_ROOT/platforms/$ANDROID_NDK_PLATFORM/$ANDROID_ARCH/usr" make -j4 build_libs || exit 1
    
    echo ""
    echo "**************************************************************"
    echo "*** Installing OpenSSL into $SUBDIR..."
    echo "**************************************************************"
    echo ""
    mkdir -p "$MYDIR/Prebuilt/$SUBDIR/lib" || exit 1
    mkdir -p "$MYDIR/Prebuilt/$SUBDIR/include/openssl/" || exit 1
    cp -vf *.a "$MYDIR/Prebuilt/$SUBDIR/lib"
    cp -vf *.so "$MYDIR/Prebuilt/$SUBDIR/lib"
    cp -vfL include/openssl/*.h "$MYDIR/Prebuilt/$SUBDIR/include/openssl/"
    make clean
    cd "$MYDIR" || exit 1

  done
done
echo ""
echo "**************************************************************"
echo "*** All done!"
echo "**************************************************************"
echo ""