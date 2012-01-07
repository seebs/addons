SUBDIRS=baggotry getopt libbaggotry lootsorter libdraggable perforate slashprint

default: all

all:
	$(foreach dir,$(SUBDIRS),make -C $(dir) package || exit 1; )
