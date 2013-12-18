#
# Makefile
# Adrian Perez, 2013-12-18 17:25
#

O := ~/.local/bin

all: $O/xsetclasshint

clean:
	$(RM) $O/xsetclasshint

$O/xsetclasshint: xsetclasshint.c
	$(CC) -o $@ $< -lX11

dirs:
	mkdir -p $O

.PHONY: dirs

# vim:ft=make
#
