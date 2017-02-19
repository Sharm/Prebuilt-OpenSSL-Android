#!/bin/bash

# Get current dir
DIR=$( cd "$( dirname "$0" )" && pwd )

. $DIR/options.sh

echo ""
echo "**************************************************************"
echo "*** Patching $DIR/$OPENSSL_SOURCE/Makefile for remove .so.1.0.0"
echo "**************************************************************"
echo ""


sed -i '/LIBNAME=$$i LIBVERSION=$(SHLIB_MAJOR)\.$(SHLIB_MINOR) \\/c \' $DIR/$OPENSSL_SOURCE/Makefile
sed -i '/LIBCOMPATVERSIONS=";$(SHLIB_VERSION_HISTORY)" \\/c \LIBNAME=$$i \\' $DIR/$OPENSSL_SOURCE/Makefile
