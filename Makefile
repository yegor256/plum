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

.SHELLFLAGS: -e -o pipefail -c
.ONESHELL:
.PHONY: clean

SHELL = bash
TARGET = target
BEFORE = $(TARGET)/index.xml
SAXON = "/usr/local/opt/Saxon.jar"
METRICS = $(notdir $(wildcard metrics/*))
LANGS := $(shell cat catalog.yml | yq 'keys' | cut -f2 -d' ')
XMLS = $(foreach lang,$(addprefix $(TARGET)/data/,$(LANGS)),$(foreach metric,$(METRICS),$(lang)/$(metric).xml))

all: $(TARGET)/index.html
	echo "Languages: $(LANGS)"

$(TARGET)/index.html: $(TARGET)/index.xml main.xsl
	java -jar $(SAXON) "-s:$(TARGET)/index.xml" -xsl:main.xsl "-o:$(TARGET)/index.html"

$(TARGET)/index.xml: $(XMLS) Makefile
	echo "XMLs: $(XMLS)"
	{
		printf "<plum date='$$(date +"%Y-%m-%d")'><catalog>"
		ruby -e "require 'yaml'; require 'gyoku'; puts Gyoku.xml(YAML.load_file('catalog.yml'));"
		printf "</catalog>"
		printf "<scripts>"
		for m in $(METRICS); do
			printf "<script id='$$(echo $${m} | cut -d. -f1)'>"
			"./metrics/$${m}"
			printf "</script>"
		done
		printf "</scripts>"
		printf "<metrics>"
		for f in $$(find $(TARGET)/data -name '*.xml'); do
			cat $${f}
		done
		printf "</metrics></plum>"
	} > $(TARGET)/index.xml

%.xml:
	path=$(subst $(TARGET)/data/,,$@)
	metric=$$(echo "$${path}" | cut -d/ -f2 | cut -d. -f1)
	lang=$$(echo "$${path}" | cut -d/ -f1)
	script="metrics/$$(echo "$${path}" | cut -d/ -f2 | sed 's/\.xml//')"
	mkdir -p "$$(dirname "$@")"
	id=$$(echo "$${path}" | cut -d/ -f2 | sed 's/\..*//')
	before=$$(xmllint -xpath "//m[@lang='$${lang}' and @script='$${id}']/v/text()" $(BEFORE))
	if [[ "$${before}" =~ ^[0-9]+$$ ]]; then
		before="<v hint='Taken from cache'>$${before}</v>"
	else
		before="<v hint='$$(echo $${before} | jq -Rr @html)'>n/a</v>"
	fi
	if [ "$(GH_TOKEN)" ]; then export GH_TOKEN=$(GH_TOKEN); fi
	if [ "$(SERPAPI_KEY)" ]; then export SERPAPI_KEY=$(SERPAPI_KEY); fi
	after=$$("$${script}" "$${lang}" 2>&1)
	if [[ ! "$$(echo $${after} | xmllint -xpath '/v/text()' -)" =~ ^[0-9]+$$ ]]; then
		echo "Broken output from $${script} for '$${lang}':\n$${after}"
		after="$${before}"
	fi
	printf "<m lang='$${lang}' script='$${id}'>$${after}</m>" > $@
	sleep 1

$(TARGET):
	mkdir -p $@

clean:
	rm -rf $(TARGET)

