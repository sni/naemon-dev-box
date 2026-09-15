#!/usr/bin/bash

set -eu

type go
go version

make clean
make
