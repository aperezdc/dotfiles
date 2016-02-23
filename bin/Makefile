#
# Makefile
# Adrian Perez, 2013-12-18 17:28
#

O := ~/.local/bin
all_bin := $(shell for i in * ; do test -x "$$i" && echo "$$i" ; done)
all_lnk := $(addprefix $O/,$(all_bin))

all: $(all_lnk)

clean:
	$(RM) $(all_lnk)

$O/%: %
	ln -s $(CURDIR)/$< $@

dirs:
	mkdir -p $O

.PHONY: dirs

# vim:ft=make
#
