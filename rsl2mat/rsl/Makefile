VERSION=1.43
DIR=$(shell pwd)
SUBDIR=rsl-v$(VERSION)

all:
	mkdir -p $(DIR)/install
	tar xzvf $(SUBDIR).tar.gz
	patch -p0 < patch.txt
	patch -p0 < patch2.txt
	patch -p0 < patch3.txt
	patch -p0 < patch4.txt
	patch -p0 < patch5.txt
	cd $(SUBDIR) && (CFLAGS="-g" ./configure --prefix=$(DIR)/install)
	cd $(SUBDIR) && ( make; make install )

clean:
	make -C $(SUBDIR) clean
	rm $(SUBDIR)/Makefile
	rm -rf $(DIR)/install
	rm -rf $(SUBDIR)
