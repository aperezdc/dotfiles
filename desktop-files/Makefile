#
# Makefile
# Adrian Perez, 2013-12-18 17:34
#

O := ~/.local/share/applications

all_desktop := $(wildcard *.desktop)
all_symlink := $(addprefix $O/,$(all_desktop))

all: $(all_symlink)

clean:
	$(RM) $(all_symlink)

$O/%: %
	ln -s $(CURDIR)/$< $@

dirs:
	mkdir -p $O

.PHONY: dirs

# vim:ft=make
#
