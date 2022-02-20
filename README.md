<img src="https://raw.githubusercontent.com/yegor256/plum/master/logo.svg" height="64px"/>

[![make](https://github.com/yegor256/plum/actions/workflows/make.yml/badge.svg?branch=master)](https://github.com/yegor256/plum/actions/workflows/make.yml)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/yegor256/ctors-vs-size/blob/master/LICENSE.txt)

Here we automatically collect statistics for some programming
languages (well, for most of them). 
It's published: [/index.html](https://yegor256.github.io/plum/).
If you want to add a new language to the collection, feel free
to submit a pull request, changing [`catalog.yml`](https://github.com/yegor256/plum/blob/master/catalog.yml) file.

To make it locally, just run:

```bash
$ make
```

Should work, if you have all dependencies installed, as suggested in the
[Dockerfile](https://github.com/yegor256/plum/blob/master/Dockerfile).
