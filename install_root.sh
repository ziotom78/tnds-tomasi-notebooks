#!/bin/bash

readonly filename="root_v6.25.01.Linux-ubuntu18-x86_64-gcc7.5.tar.gz"

wget https://root.cern/download/${filename} && \
	tar -zxvf ${filename} && rm -f ${filename}

cat <<EOF
To run "root-config", you must first run

    source setup.sh
EOF
