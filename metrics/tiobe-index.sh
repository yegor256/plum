#!/bin/bash
# The MIT License (MIT)
#
# Copyright (c) 2022 Yegor Bugayenko
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

set -e

lang=$1

if [ ! "$lang" ]; then
    echo "TIOBE Index"
    exit
fi

name=$(cat catalog.yml | yq ".${lang}.tiobe-name")
if [ "${name}" == "null" ]; then
    name=$(cat catalog.yml | yq ".${lang}.name")
fi

temp=$(dirname $0)/../target
mkdir -p "${temp}"
if [ ! -e "${temp}/tiobe.xml" ]; then
    wget -nv https://www.tiobe.com/tiobe-index/ -O "${temp}/tiobe.html"
    tidy -bare -asxml -q -o "${temp}/tiobe.xml" "${temp}/tiobe.html" || echo 'Ignore all errors'
fi

rank=$(sed '2 s/xmlns=".*"//g' "${temp}/tiobe.xml" | xmllint -xpath "//tr[td='${name}' and td[contains(text(),'%')]]/td[1]/text()" - 2>&1)

printf "<v>${rank}</v>"
