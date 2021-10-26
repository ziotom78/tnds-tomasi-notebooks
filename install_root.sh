#!/bin/bash

readonly filename="root_v6.24.06.Linux-ubuntu18-x86_64-gcc7.5.tar.gz"

wget https://root.cern/download/${filename} && \
	tar -zxvf ${filename}

source setup.sh
