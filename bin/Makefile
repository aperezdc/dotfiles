#
# Makefile
# Adrian Perez, 2013-12-18 17:28
#

O := ~/.local/bin
all_bin := $(shell find . -maxdepth 1 -type f -executable -print0 | xargs -0 -n 1 basename)
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
