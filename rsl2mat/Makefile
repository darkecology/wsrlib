
# --------------------------------------------------------------------
# Portions of this the Makefile were copied from VLFeat, which is
# licensed under a BSD license. Please see the following copyright
# and license information
#
# Copyright (C) 2007-11, Andrea Vedaldi and Brian Fulkerson
# Copyright (C) 2012-13, The VLFeat Team
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the
#    distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# --------------------------------------------------------------------


# --------------------------------------------------------------------
# Error Messages
# --------------------------------------------------------------------

err_no_arch  =
err_no_arch +=$(shell echo "** Unknown host architecture '$(UNAME)'. This identifier"   1>&2)
err_no_arch +=$(shell echo "** was obtained by running 'uname -sm'. Edit the Makefile " 1>&2)
err_no_arch +=$(shell echo "** to add the appropriate configuration."                   1>&2)

err_no_matlab = 
err_no_matlab +=$(shell echo "** Cannot locate MATLAB installation, which is located by "   1>&2)
err_no_matlab +=$(shell echo "** calling 'which mexext' in the shell to locate MATLAB's "   1>&2)
err_no_matlab +=$(shell echo "** mexext executable. Please add the matlab binary path  "    1>&2)
err_no_matlab +=$(shell echo "** <MATLABROOT>/bin to your system path."                     1>&2)

# --------------------------------------------------------------------
#  Auto-detect architecture
# --------------------------------------------------------------------

Darwin_PPC_ARCH := mac
Darwin_Power_Macintosh_ARCH := mac
Darwin_i386_ARCH := maci64
Darwin_x86_64_ARCH := maci64
Linux_i386_ARCH := glnx86
Linux_i686_ARCH := glnx86
Linux_unknown_ARCH := glnx86
Linux_x86_64_ARCH := glnxa64

UNAME := $(shell uname -sm)
ARCH ?= $($(shell echo "$(UNAME)" | tr \  _)_ARCH)

# sanity check
ifeq ($(ARCH),)
die:=$(error $(err_no_arch))
endif

# --------------------------------------------------------------------
#  Locate MATLAB installation
# --------------------------------------------------------------------

MEXEXT ?= mexext
MATLABDIR ?= $(subst /bin/mexext,,$(realpath $(shell which '$(MEXEXT)')))
MEX = $(MATLABDIR)/bin/mex

ifeq ($(MATLABDIR),)
die:=$(error $(err_no_matlab))
endif


#
#  End of section copied from VLFeat
# --------------------------------------------------------------------


# --------------------------------------------------------------------
# Set paths
# --------------------------------------------------------------------

UNAME=$(shell uname)
CWD=$(shell pwd)

RSL ?=$(CWD)/rsl/install
EXT = $(shell $(MATLABDIR)/bin/mexext)

# --------------------------------------------------------------------
# Set flags: mex, compiler, and linker
#
# Note: this section is not architecture specific, but it could be
# if necessary. (See vlfeat and matconvnet for good models...)
# --------------------------------------------------------------------

MEXFLAGS = 
MEXFLAGS += -largeArrayDims
MEXFLAGS += -I${RSL}/include
MEXFLAGS += -Iprivate
MEXFLAGS += -L${RSL}/lib
MEXFLAGS += -lrsl

LDFLAGS =
LDFLAGS += -Wl,-rpath,${RSL}/lib

CXXFLAGS = 
CXXFLAGS += -fPIC
CXXFLAGS += -Wno-write-strings
CXXFLAGS += -I${RSL}/include

# --------------------------------------------------------------------
# Set additional options for debug and verbatim output
# --------------------------------------------------------------------

ifneq ($(DEBUG),)
MEXFLAGS += -g
else
MEXFLAGS += -DNDEBUG -O
# we still want debug symbols
MEXFLAGS += CXXOPTIMFLAGS='$$CXXOPTIMFLAGS -g'
MEXFLAGS += LDOPTIMFLAGS='$$LDOPTIMFLAGS -g'
endif

ifdef VERB
MEXFLAGS += -v
NVCCFLAGS += -v
endif

# --------------------------------------------------------------------
# RSL2MAT targets
# --------------------------------------------------------------------

.PHONY: all, clean

all: rsl2mat.$(EXT)

util.o: util.c
	$(MEX) $(MEXFLAGS) CXXFLAGS='$$CXXFLAGS $(CXXFLAGS)' LDFLAGS='$$LDFLAGS $(LDFLAGS)' -c util.c

rsl2mat.$(EXT): rsl2mat.cpp util.o
	$(MEX) $(MEXFLAGS) CXXFLAGS='$$CXXFLAGS $(CXXFLAGS)' LDFLAGS='$$LDFLAGS $(LDFLAGS)' rsl2mat.cpp util.o

clean:
	-rm rsl2mat.$(EXT)
	-rm util.o
	-rm rslinfo.o
	-rm rslinfo

rslinfo: rslinfo.o
	$(CC) -v -Wl,-rpath,$(RSL)/lib -L$(RSL)/lib -lrsl rslinfo.o -o $@

rslinfo.o: rslinfo.c
	$(CC) -g -DDEBUG -c -I$(RSL)/include rslinfo.c -o $@
