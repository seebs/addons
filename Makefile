SUBDIRS= baggotry docexport enfiltrate getopt goofball \
	libaccounts libbaggotry libdraggable lootsorter perforate \
	rangefinder riftrc slashprint swaggotry

default: all

all:
	$(foreach dir,$(SUBDIRS),make -C $(dir) package || exit 1; )

checkout:
	$(foreach dir,$(SUBDIRS),[ -d "$(dir)" ] || git clone git@github.com:seebs/$(dir); )
