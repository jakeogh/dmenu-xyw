# dmenu-xyw - dynamic menu
# See LICENSE file for copyright and license details.

include config.mk

SRC = drw.c dmenu-xyw.c stest.c util.c
OBJ = $(SRC:.c=.o)

all: options dmenu-xyw stest

options:
	@echo dmenu-xyw build options:
	@echo "CFLAGS   = $(CFLAGS)"
	@echo "LDFLAGS  = $(LDFLAGS)"
	@echo "CC       = $(CC)"

.c.o:
	$(CC) -c $(CFLAGS) $<

config.h:
	cp config.def.h $@

$(OBJ): arg.h config.h config.mk drw.h

dmenu-xyw: dmenu-xyw.o drw.o util.o
	$(CC) -o $@ dmenu-xyw.o drw.o util.o $(LDFLAGS)

stest: stest.o
	$(CC) -o $@ stest.o $(LDFLAGS)

clean:
	rm -f dmenu-xyw stest $(OBJ) dmenu-xyw-$(VERSION).tar.gz

dist: clean
	mkdir -p dmenu-xyw-$(VERSION)
	cp LICENSE Makefile README arg.h config.def.h config.mk dmenu-xyw.1\
		drw.h util.h dmenu-xyw_path dmenu-xyw_run stest.1 $(SRC)\
		dmenu-xyw-$(VERSION)
	tar -cf dmenu-xyw-$(VERSION).tar dmenu-xyw-$(VERSION)
	gzip dmenu-xyw-$(VERSION).tar
	rm -rf dmenu-xyw-$(VERSION)

install: all
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp -f dmenu-xyw dmenu-xyw_path dmenu-xyw_run stest $(DESTDIR)$(PREFIX)/bin
	chmod 755 $(DESTDIR)$(PREFIX)/bin/dmenu-xyw
	chmod 755 $(DESTDIR)$(PREFIX)/bin/dmenu-xyw_path
	chmod 755 $(DESTDIR)$(PREFIX)/bin/dmenu-xyw_run
	chmod 755 $(DESTDIR)$(PREFIX)/bin/stest
	mkdir -p $(DESTDIR)$(MANPREFIX)/man1
	sed "s/VERSION/$(VERSION)/g" < dmenu-xyw.1 > $(DESTDIR)$(MANPREFIX)/man1/dmenu-xyw.1
	sed "s/VERSION/$(VERSION)/g" < stest.1 > $(DESTDIR)$(MANPREFIX)/man1/stest.1
	chmod 644 $(DESTDIR)$(MANPREFIX)/man1/dmenu-xyw.1
	chmod 644 $(DESTDIR)$(MANPREFIX)/man1/stest.1

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/dmenu-xyw\
		$(DESTDIR)$(PREFIX)/bin/dmenu-xyw_path\
		$(DESTDIR)$(PREFIX)/bin/dmenu-xyw_run\
		$(DESTDIR)$(PREFIX)/bin/stest\
		$(DESTDIR)$(MANPREFIX)/man1/dmenu-xyw.1\
		$(DESTDIR)$(MANPREFIX)/man1/stest.1

.PHONY: all options clean dist install uninstall
