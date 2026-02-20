# NVMain-PIM Python 2 Environment Setup

This guide describes how to set up and build NVMain-PIM in a Python 2 environment.

## Overview

NVMain-PIM uses **SCons** as its build system. The project's SConstruct and SConscript files use Python 2 syntax (`iteritems()`, `print >>f`, `file()`). Modern SCons (4.x) requires Python 3, so you need **SCons 2.x** for Python 2 compatibility.

## Prerequisites

- **Python 2.7** (e.g., `python2` or `python2.7`)
- **g++** with C++11 support (for `-std=c++0x`)

## Quick Setup (Automated)

```bash
chmod +x setup_python2.sh
./setup_python2.sh
```

## Manual Setup

### 1. Install pip for Python 2

If Python 2 doesn't have pip:

```bash
curl -sS https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip.py
python2 get-pip.py --user
```

Add `~/.local/bin` to your PATH:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

### 2. Install SCons 2.x for Python 2

```bash
pip2 install "scons>=2.0,<3.0"
# or: python2 -m pip install --user "scons>=2.0,<3.0"
```

### 3. Clean Previous Builds (Important!)

If you previously built with Python 3's SCons, the `.sconsign.dblite` file uses pickle protocol 4 which Python 2 cannot read. Remove it:

```bash
rm -rf build .sconsign.dblite .scons_*
```

### 4. Build NVMain

**Always use Python 2 to run SCons:**

```bash
python2 ~/.local/bin/scons --build-type=fast
```

Build types:
- `--build-type=fast` (default): Optimized build (`-O3`), produces `nvmain.fast`
- `--build-type=debug`: Debug symbols (`-O0 -ggdb3`), produces `nvmain.debug`
- `--build-type=prof`: Profiling support, produces `nvmain.prof`

## Running NVMain

```bash
./nvmain.fast CONFIG_FILE TRACE_FILE [Cycles [PARAM=value ...]]
```

Example configs are in the `Config/` directory.

## Python Scripts in the Project

The project includes Python 2 scripts:
- `Tests/Regressions.py`
- `Scripts/FaultInjector.py`
- `Scripts/StatsParser.py`

Run them with: `python2 Scripts/StatsParser.py` etc.

## Troubleshooting

### "ValueError: unsupported pickle protocol: 4"

You have a `.sconsign.dblite` created by Python 3's SCons. Remove it and rebuild:

```bash
rm -f .sconsign.dblite
python2 ~/.local/bin/scons --build-type=fast
```

### "scons: command not found" or wrong SCons version

Do **not** rely on `scons` from PATH (it may invoke Python 3). Always use:

```bash
python2 ~/.local/bin/scons --build-type=fast
```

### PATH not set for pip2

If `pip2` or `scons` are not found, add to `~/.bashrc`:

```bash
export PATH="$HOME/.local/bin:$PATH"
```
