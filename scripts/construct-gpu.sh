#!/bin/bash

rm -r -f gpu-build

mkdir gpu-build

cd gpu-build
HOME_PATH=~/
COMPILER_PATH=$HOME_PATH
echo $COMPILER_PATH
#cmake   -DCMAKE_CXX_COMPILER=$COMPILER_PATH \
cmake	-DCMAKE_CXX_EXTENSIONS=OFF ..
make -j4


