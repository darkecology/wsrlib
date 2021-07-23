VERSION?=1.50
DIR=$(shell pwd)
SUBDIR=rsl-v$(VERSION)

all:
	mkdir -p $(DIR)/install
	tar xzvf $(SUBDIR).tar.gz
#	cd $(SUBDIR) && patch -p1 < ../patch.txt
#	cd $(SUBDIR) && patch -p1 < ../patch2.txt
#	cd $(SUBDIR) && patch -p1 < ../patch3.txt
#	cd $(SUBDIR) && patch -p1 < ../patch4.txt
#	cd $(SUBDIR) &&	patch -p1 < ../patch5.txt
#	cd $(SUBDIR) &&	patch -p1 < ../patch6.txt
#	cd $(SUBDIR) &&	patch -p1 < ../patch7.txt
	cd $(SUBDIR) &&	patch -p1 < ../patch8.txt
#	cd $(SUBDIR) &&	patch -p1 < ../patch9.txt
#	cd $(SUBDIR) &&	patch -p1 < ../patch10.txt
	cd $(SUBDIR) &&	patch -p1 < ../patch11.txt
	cd $(SUBDIR) &&	patch -p1 < ../patch12.txt  # From https://patch-diff.githubusercontent.com/raw/adokter/rsl/pull/13.patch
	cd $(SUBDIR) &&	patch -p1 < ../patch13.txt
	cd $(SUBDIR) &&	patch -p1 < ../patch14.txt
	cd $(SUBDIR) &&	patch -p1 < ../patch15.txt # KBBX20060113_170337.gz
	cd $(SUBDIR) &&	patch -p1 < ../patch16.txt # KCCX20130112_070503_V06.gz
	cd $(SUBDIR) && (CFLAGS="-g" ./configure --prefix=$(DIR)/install)
	cd $(SUBDIR) && ( make; make install )

clean:
	-make -C $(SUBDIR) clean
	-rm $(SUBDIR)/Makefile
	-rm -rf $(DIR)/install
	-rm -rf $(SUBDIR)
