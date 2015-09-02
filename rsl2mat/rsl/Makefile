VERSION=1.48
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
	cd $(SUBDIR) &&	patch -p1 < ../patch7.txt
	cd $(SUBDIR) &&	patch -p1 < ../patch8.txt
	cd $(SUBDIR) && (CFLAGS="-g" ./configure --prefix=$(DIR)/install)
	cd $(SUBDIR) && ( make; make install )

clean:
	-make -C $(SUBDIR) clean
	-rm $(SUBDIR)/Makefile
	-rm -rf $(DIR)/install
	-rm -rf $(SUBDIR)
