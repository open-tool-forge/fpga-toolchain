#!/usr/bin/env bash

set -e

dir_name=z3
commit=master
git_url=https://github.com/Z3Prover/z3.git

git_clone $dir_name $git_url $commit

cd $BUILD_DIR/$dir_name
mkdir -p build
cd build

if [ $ARCH = "darwin" ]
then
    cmake ../
    $MAKE -j$J
elif [ ${ARCH:0:7} = "windows" ]
then
    LDFLAGS="-static" cmake -G "MinGW Makefiles" -DBUILD_LIBZ3_SHARED=OFF ../
    $MAKE -j$J
else
    LDFLAGS="-static" cmake -DBUILD_LIBZ3_SHARED=OFF ../
    cmake -DZ3_BUILD_LIBZ3_SHARED=OFF ../
    $MAKE -j$J
fi

test_bin z3$EXE
cp z3$EXE $PACKAGE_DIR/$NAME/bin