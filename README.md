# Outcoin - Lightweight Outcoin client

```
Licence: MIT Licence
Author: Outcoin Development Team
Language: Python (>= 3.10)
Homepage: https://outcoin.org/
```

[![Build Status](https://api.cirrus-ci.com/github/outcoin-chain/outcoin-core/outcoin-core.svg?branch=master)](https://cirrus-ci.com/github/outcoin-chain/outcoin-core/outcoin-core)
[![Test coverage statistics](https://coveralls.io/repos/github/outcoin-chain/outcoin-core/outcoin-core/badge.svg?branch=master)](https://coveralls.io/github/outcoin-chain/outcoin-core/outcoin-core?branch=master)
[![Help translate Outcoin online](https://d322cqt584bo4o.cloudfront.net/outcoin/localized.svg)](https://crowdin.com/project/outcoin)


## Getting started

_(If you've come here looking to simply run Outcoin,
[you may download it here](https://outcoin.org/#download).)_

Outcoin itself is pure Python, and so are most of the required dependencies,
but not everything. The following sections describe how to run from source, but here
is a TL;DR:

```
$ sudo apt-get install libsecp256k1-dev
$ OUTCOIN_ECC_DONT_COMPILE=1 python3 -m pip install --user ".[gui,crypto]"
```

### Not pure-python dependencies

#### Qt GUI

If you want to use the Qt interface, install the Qt dependencies:
```
$ sudo apt-get install python3-pyqt6
```

#### libsecp256k1

For elliptic curve operations,
[libsecp256k1](https://github.com/bitcoin-core/secp256k1)
is a required dependency.

If you "pip install" Outcoin, by default libsecp will get compiled locally,
as part of the `outcoin-ecc` dependency. This can be opted-out of,
by setting the `OUTCOIN_ECC_DONT_COMPILE=1` environment variable.
For the compilation to work, besides a C compiler, you need at least:
```
$ sudo apt-get install automake libtool
```
If you opt out of the compilation, you need to provide libsecp in another way, e.g.:
```
$ sudo apt-get install libsecp256k1-dev
```

#### cryptography

Due to the need for fast symmetric ciphers,
[cryptography](https://github.com/pyca/cryptography) is required.
Install from your package manager (or from pip):
```
$ sudo apt-get install python3-cryptography
```

#### hardware-wallet support

If you would like hardware wallet support,
[see this](https://github.com/outcoin-chain/outcoin-docs/blob/master/hardware-linux.rst).


### Running from tar.gz

If you downloaded the official package (tar.gz), you can run
Outcoin from its root directory without installing it on your
system; all the pure python dependencies are included in the 'packages'
directory. To run Outcoin from its root directory, just do:
```
$ ./run_electrum
```

You can also install Outcoin on your system, by running this command:
```
$ sudo apt-get install python3-setuptools python3-pip
$ python3 -m pip install --user .
```

This will download and install the Python dependencies used by
Outcoin instead of using the 'packages' directory.
It will also place an executable named `electrum` in `~/.local/bin`,
so make sure that is on your `PATH` variable.


### Development version (git clone)

_(For OS-specific instructions, see [here for Windows](contrib/build-wine/README_windows.md),
and [for macOS](contrib/osx/README_macos.md))_

Check out the code from GitHub:
```
$ git clone https://github.com/outcoin-chain/outcoin-core/outcoin-core.git
$ cd outcoin-core
$ git submodule update --init
```

Run install (this should install dependencies):
```
$ python3 -m pip install --user -e .
```

Create translations (optional):
```
$ sudo apt-get install gettext
$ ./contrib/locale/build_locale.sh electrum/locale/locale electrum/locale/locale
```

Finally, to start Outcoin:
```
$ ./run_electrum
```

### Run tests

Run unit tests with `pytest`:
```
$ pytest tests -v
```

To run a single file, specify it directly like this:
```
$ pytest tests/test_bitcoin.py -v
```

## Creating Binaries

- [Linux (tarball)](contrib/build-linux/sdist/README.md)
- [Linux (AppImage)](contrib/build-linux/appimage/README.md)
- [macOS](contrib/osx/README.md)
- [Windows](contrib/build-wine/README.md)
- [Android](contrib/android/Readme.md)


## Contributing

Any help testing the software, reporting or fixing bugs, reviewing pull requests
and recent changes, writing tests, or helping with outstanding issues is very welcome.
Implementing new features, or improving/refactoring the codebase, is of course
also welcome, but to avoid wasted effort, especially for larger changes,
we encourage discussing these on the issue tracker or IRC first.

Besides [GitHub](https://github.com/outcoin-chain/outcoin-core/outcoin-core),
most communication about Outcoin development happens on Discord, in the
`#outcoin` channel. The easiest way to participate on Discord is
with the web client, [discord.com/outcoin-chain](https://discord.com/outcoin-chain).

Please improve translations on [Crowdin](https://crowdin.com/project/outcoin).
