#!/bin/bash

OPENSSL_PACKAGE="openssl-1.0.2s.tar.gz"
OPENSSL_NAME=`echo $OPENSSL_PACKAGE|sed 's#\.tar.gz##g'`
OPENSSL_URL="http://www.openssl.org/source/$OPENSSL_PACKAGE"
OPENSSL_PREFIX="$PWD/Source" ;
OPENSSL_ROOT="$OPENSSL_PREFIX/$OPENSSL_NAME"

echo ""
echo "**************************************************************"
echo "*** Downloading OpenSSL..."
echo "**************************************************************"
echo ""
echo "OPENSSL_PACKAGE=$OPENSSL_PACKAGE"
echo "OPENSSL_NAME=$OPENSSL_NAME"
echo "OPENSSL_URL=$OPENSSL_URL"
echo "OPENSSL_PREFIX=$OPENSSL_PREFIX"

if [ ! -d "$OPENSSL_ROOT" ]; then
  echo "Downloading OpenSSL sources from $OPENSSL_URL."
  if [ "$OSTYPE_MAJOR" = "darwin" ] ; then
    pushd "$OPENSSL_PREFIX"
    curl --insecure -S -L -O "$OPENSSL_URL"
    popd ;
  else
    wget "$OPENSSL_URL" --no-verbose --directory-prefix="$OPENSSL_PREFIX" ;
  fi
  echo "Extracting OpenSSL sources to: $OPENSSL_PREFIX"
  tar -xzf "$OPENSSL_PREFIX/$OPENSSL_PACKAGE" -C "$OPENSSL_PREFIX"
  echo "Cleaning up $OPENSSL_PREFIX/$OPENSSL_PACKAGE."
  rm "$OPENSSL_PREFIX/$OPENSSL_PACKAGE"
  #echo "Patching $OPENSSL_ROOT/crypto/bio/bss_fd.c"
  #echo "#ifdef INCLUDE_BSS_FILE"       >> "$OPENSSL_ROOT/crypto/bio/bss_fd.c"
  #echo "#include \"bio/bss_file.c\""   >> "$OPENSSL_ROOT/crypto/bio/bss_fd.c"
  #echo "#endif"                        >> "$OPENSSL_ROOT/crypto/bio/bss_fd.c"
else
  echo "Found existing OpenSSL sources in $OPENSSL_ROOT."
fi