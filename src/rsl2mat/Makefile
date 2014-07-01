UNAME=$(shell uname)
CWD=$(shell pwd)

RSL ?=$(CWD)/rsl/install
CPP = g++
CC  = gcc34
MEX = $(MATLABDIR)/bin/mex
EXT = $(shell $(MATLABDIR)/bin/mexext)

MFLAGS =
MFLAGS += -largeArrayDims
MFLAGS += -I${RSL}/include -Iprivate
MFLAGS += -Wl,-rpath,${RSL}/lib -L${RSL}/lib -lrsl

CFLAGS =
CFLAGS += -fPIC
OPT=
MEXFLAGS = $(MFLAGS) CXX\#$(CPP) CXXFLAGS\#"$(CFLAGS)"

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

rsl2mat.$(EXT): rsl2mat.cpp util.c
	$(MEX) $(MEXFLAGS) rsl2mat.cpp util.c

clean:
	rm rsl2mat.$(EXT)

.PHONY: opt all debug clean
