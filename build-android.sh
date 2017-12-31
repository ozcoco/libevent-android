#!/bin/bash

sudo make clean

sudo make distclean


MY_ARCH_SET=(arm arm-v7a arm64-v8a x86 x86_64)

len=${#MY_ARCH_SET[@]}

index=0

echo "**************************************************"

until [ ! $index -lt $len ]
do

        echo "${index} -> ${MY_ARCH_SET[$index]}"

        index=`expr $index + 1`
done


echo "**************************************************"


echo "Please input arch number:"

read MY_NUM

echo "Compile ${MY_ARCH_SET[$MY_NUM]}"

if [ $MY_NUM == 1 ]
then

common "arm" ${MY_NUM}

arm_v7a

elif [ $MY_NUM == 2 ]
then


common "arm64" ${MY_NUM}

else

common ${MY_ARCH_SET[$MY_NUM]} ${MY_NUM}

fi


common(){

MY_INSTALL_DIR="/tmp/my-android-toolchain/$2"

sudo rm -R /tmp/my-android-toolchain

sudo /home/oz/Android/Sdk/ndk-bundle/build/tools/make-standalone-toolchain.sh --system=linux-x86_64 --platform=android-14 --arch=$1 --install=${MY_INSTALL_DIR}
export PATH=${MY_INSTALL_DIR}/bin:$PATH
export CC=arm-linux-androideabi-gcc
export CXX=arm-linux-androideabi-g++

}


arm_v7a(){

export CFLAGS= -march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3-d16

}

if [ $? == 0 ]
then

sudo ./configure --prefix=$PWD/build/${MY_ARCH_SET[$MY_NUM]}
sudo make
sudo make install
echo "Compile finish"

fi
