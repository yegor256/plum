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
set -x

lang=$1

if [ ! "$lang" ]; then
    echo "Tweets"
    exit
fi

tag=$(cat catalog.yml | yq ".${lang}.twitter-tag")
if [ "${tag}" == "null" ]; then
    tag=$(cat catalog.yml | yq ".${lang}.stackoverflow-tag")
fi

count=$(curl "https://api.twitter.com/2/tweets/counts/all?query=$(printf ${tag} | jq -sRr @uri)" -H "Authorization: Bearer ${TWITTER_TOKEN}" | jq '.count')

printf "<v>${count}</v>"