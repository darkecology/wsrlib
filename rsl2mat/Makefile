UNAME=$(shell uname)
CWD=$(shell pwd)

RSL ?=$(CWD)/rsl/install
CPP ?= g++
CC  ?= /usr/bin/gcc
MEX = $(MATLABDIR)/bin/mex
EXT = $(shell $(MATLABDIR)/bin/mexext)

MFLAGS =
MFLAGS += -largeArrayDims
MFLAGS += -I${RSL}/include
MFLAGS += -Iprivate
MFLAGS += -L${RSL}/lib
MFLAGS += -lrsl

LDFLAGS =
LDFLAGS += -Wl,-rpath,${RSL}/lib

CXXFLAGS = 
CXXFLAGS += -fPIC
CXXFLAGS += -Wno-write-strings
CXXFLAGS += -I${RSL}/include
CXXFLAGS += -L${RSL}/lib
CXXFLAGS += -lrsl
OPT=

default: opt

all: rsl2mat.$(EXT)

debug: CFLAGS += -g -DDEBUG
debug: MFLAGS += -g
debug: all

opt-debug: OPT += -03
opt-debug: CFLAGS += -g -DDEBUG
opt-debug: all

opt: OPT += -O3
opt: all

util.o: util.c
	$(MEX) $(MFLAGS) CXXFLAGS='$$CXXFLAGS $(CXXFLAGS)' LDFLAGS='$$LDFLAGS $(LDFLAGS)' -c util.c

rsl2mat.$(EXT): rsl2mat.cpp util.o
	$(MEX) $(MFLAGS) CXXFLAGS='$$CXXFLAGS $(CXXFLAGS)' LDFLAGS='$$LDFLAGS $(LDFLAGS)' rsl2mat.cpp util.o

clean:
	rm rsl2mat.$(EXT)
	rm util.o
	rm rslinfo.o
	rm rslinfo

.PHONY: opt all debug clean

debug-rslinfo: CFLAGS += -g -DDEBUG
debug-rslinfo: rslinfo

rslinfo: rslinfo.o
	$(CC) -v -Wl,-rpath,$(RSL)/lib -L$(RSL)/lib -lrsl rslinfo.o -o $@

rslinfo.o: rslinfo.c
	$(CC) $(CFLAGS) -c -I$(RSL)/include rslinfo.c -o $@
