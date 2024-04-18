#!/usr/bin/env bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

git clone https://github.com/arichardson/juliet-test-suite-c.git

cd juliet-test-suite-c
git checkout e2e8cf80cd7d52f824e9a938bbb3aa658d23d6c9 -b softboundcets
patch -p1 < "${DIR}/0001-Add-SoftBound-CETS-and-ASan-configuration.patch" 
