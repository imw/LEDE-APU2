#!/bin/bash

firstbuild=0
clonedir=./lede
cpu_num=$(grep -c processor /proc/cpuinfo)

# Print messages in cyan blue
Msg() {
  echo -e "\e[96m$1\e[39m"
}

# Do we want menuconfig's and an option to save configs?
if [ "$1" = "modify" ]; then
  modify=1
else
  modify=0
fi

# Do we want to build at present?
if [ "$1" = "build" ]; then
  build=1
else
  build=0
fi

Msg "Starting Build Process!"

if [ ! -d "$clonedir" ]; then
  firstbuild=1
  Msg "Cloning Repo..."
  git clone https://github.com/lede-project/source $clonedir
fi

if [ "$firstbuild" -eq "0" ]; then
  Msg "Cleaning Builddir..."
  cd $clonedir
  rm -rf ./bin
  make clean
  cd - > /dev/null
fi

Msg "Applying overlay..."
if [ `rsync -avzr --log-format=%f ./overlay/* $clonedir/ | wc -l` -gt "4" ] || [ "$firstbuild" -eq "1" ]; then
  Msg "Installing feeds..."
  cd $clonedir
  ./scripts/feeds update -a
  ./scripts/feeds install -a
  cd - > /dev/null
fi


if [ -f "../config/diffconfig" ]; then
  Msg "Applying and Expanding config..."
  cd $clonedir
  cp ../config/diffconfig ./.config
  make defconfig
  cd - > /dev/null
fi

if [ "$modify" -eq "1" ]; then
  cd $clonedir
  Msg "Loading Menuconfig"
  make menuconfig -j$cpu_num V=s
  cd - > /dev/null
fi

if [ "$build" -eq "1" ]; then
  Msg "Building Time!!!"
  cd $clonedir
  make -j$cpu_num V=s

  if [ $? -ne 0 ]; then
    cd - > /dev/null
    Msg "Build Failed!"
    exit 1
  else
    cd - > /dev/null
    Msg "Compile Complete!"
  fi
fi

Msg "Build.sh Finished!"
