# VERSION=
# PACKAGE=
# EMBEDS=
RIFT=/c/games/RIFT Game/Interface/AddOns
PTS=/c/games/RIFT PTS/Interface/AddOns
DATESTAMP=$(shell date +"%y%m%d-%H:%M:%S")
HERE=$(PWD)

package: $(PACKAGE)

$(PACKAGE): $(PACKAGE).lua RiftAddon.toc $(foreach embed,$(EMBEDS),../$(embed)/*.lua ../$(embed)/*.toc) Makefile $(EXTRAFILES)
	rm -rf $(PACKAGE)
	mkdir $(PACKAGE)
	rm -f $(PACKAGE)-$(VERSION).zip
	sed -e "s/VERSION/$(VERSION)-$(DATESTAMP)/" < RiftAddon.toc > $(PACKAGE)/RiftAddon.toc
	sed -e "s/VERSION/$(VERSION)-$(DATESTAMP)/" < $(PACKAGE).lua > $(PACKAGE)/$(PACKAGE).lua
	if [ -n "$(EXTRAFILES)" ]; then cp $(EXTRAFILES) $(PACKAGE); fi
	$(foreach embed,$(EMBEDS),DESTDIR="$(CURDIR)/$(PACKAGE)" make --no-print-directory -C ../$(embed) embed; )
	cp *.txt $(PACKAGE)/.
	cp ../bsd.txt $(PACKAGE)/COPYRIGHT.txt

embed: $(PACKAGE)
	@$(if $(DESTDIR),echo "Embedding $(PACKAGE) in $(DESTDIR).",echo "DESTDIR must be set to embed."; exit 1)
	cp -r $(PACKAGE) $(DESTDIR)/.
	
release: package
	zip -r $(PACKAGE)-$(VERSION).zip $(PACKAGE)

install: package
	[ -n "$(PACKAGE)" ] && rm -rf "$(RIFT)"/"$(PACKAGE)"
	mkdir -p "$(RIFT)"/$(PACKAGE)
	cp -r $(PACKAGE)/* "$(RIFT)"/$(PACKAGE)

pts: package
	[ -n "$(PACKAGE)" ] && rm -rf "$(PTS)"/"$(PACKAGE)"
	mkdir -p "$(PTS)"/$(PACKAGE)
	cp -r $(PACKAGE)/* "$(PTS)"/$(PACKAGE)
