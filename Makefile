# dmenu-xyw - dynamic menu
# See LICENSE file for copyright and license details.

include config.mk

SRC = drw.c dmenu-xyw.c stest.c util.c
OBJ = ${SRC:.c=.o}

all: options dmenu-xyw stest

options:
	@echo dmenu-xyw build options:
	@echo "CFLAGS   = ${CFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"
	@echo "CC       = ${CC}"

.c.o:
	@echo CC $<
	@${CC} -c ${CFLAGS} $<

config.h:
	@echo creating $@ from config.def.h
	@cp config.def.h $@

${OBJ}: arg.h config.h config.mk drw.h

dmenu-xyw: dmenu-xyw.o drw.o util.o
	@echo CC -o $@
	@${CC} -o $@ dmenu-xyw.o drw.o util.o ${LDFLAGS}

stest: stest.o
	@echo CC -o $@
	@${CC} -o $@ stest.o ${LDFLAGS}

clean:
	@echo cleaning
	@rm -f dmenu-xyw stest ${OBJ} dmenu-xyw-${VERSION}.tar.gz
	@rm -f config.h

dist: clean
	@echo creating dist tarball
	@mkdir -p dmenu-xyw-${VERSION}
	@cp LICENSE Makefile README arg.h config.def.h config.mk dmenu-xyw.1 \
		drw.h util.h dmenu-xyw_path dmenu-xyw_run stest.1 ${SRC} \
		dmenu-xyw-${VERSION}
	@tar -cf dmenu-xyw-${VERSION}.tar dmenu-xyw-${VERSION}
	@gzip dmenu-xyw-${VERSION}.tar
	@rm -rf dmenu-xyw-${VERSION}

install: all
	@echo installing executables to ${DESTDIR}${PREFIX}/bin
	@mkdir -p ${DESTDIR}${PREFIX}/bin
	@cp -f dmenu-xyw dmenu-xyw_path dmenu-xyw_run stest ${DESTDIR}${PREFIX}/bin
	@chmod 755 ${DESTDIR}${PREFIX}/bin/dmenu-xyw
	@chmod 755 ${DESTDIR}${PREFIX}/bin/dmenu-xyw_path
	@chmod 755 ${DESTDIR}${PREFIX}/bin/dmenu-xyw_run
	@chmod 755 ${DESTDIR}${PREFIX}/bin/stest
	@echo installing manual pages to ${DESTDIR}${MANPREFIX}/man1
	@mkdir -p ${DESTDIR}${MANPREFIX}/man1
	@sed "s/VERSION/${VERSION}/g" < dmenu-xyw.1 > ${DESTDIR}${MANPREFIX}/man1/dmenu-xyw.1
	@sed "s/VERSION/${VERSION}/g" < stest.1 > ${DESTDIR}${MANPREFIX}/man1/stest.1
	@chmod 644 ${DESTDIR}${MANPREFIX}/man1/dmenu-xyw.1
	@chmod 644 ${DESTDIR}${MANPREFIX}/man1/stest.1

uninstall:
	@echo removing executables from ${DESTDIR}${PREFIX}/bin
	@rm -f ${DESTDIR}${PREFIX}/bin/dmenu-xyw
	@rm -f ${DESTDIR}${PREFIX}/bin/dmenu-xyw_path
	@rm -f ${DESTDIR}${PREFIX}/bin/dmenu-xyw_run
	@rm -f ${DESTDIR}${PREFIX}/bin/stest
	@echo removing manual page from ${DESTDIR}${MANPREFIX}/man1
	@rm -f ${DESTDIR}${MANPREFIX}/man1/dmenu-xyw.1
	@rm -f ${DESTDIR}${MANPREFIX}/man1/stest.1

.PHONY: all options clean dist install uninstall
