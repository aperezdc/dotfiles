#
# Makefile
# Adrian Perez, 2013-12-18 17:36
#

SUBDIRS := $(patsubst %/Makefile,%,$(wildcard */Makefile))

all:

ALL_TARGETS :=
DIRS_TARGETS :=
CLEAN_TARGETS :=

define subdir-template
all-$1:
	$$(MAKE) -C $1 all
ALL_TARGETS += all-$1

dirs-$1:
	$$(MAKE) -C $1 dirs
DIRS_TARGETS += dirs-$1

clean-$1:
	$$(MAKE) -C $1 clean
CLEAN_TARGETS += clean-$1

.PHONY: $1-all $1-clean $1-dirs
endef

$(foreach S,$(SUBDIRS),$(eval $(call subdir-template,$S)))

all: $(ALL_TARGETS)
dirs: $(DIRS_TARGETS)
clean: $(CLEAN_TARGETS)
.PHONY: all dirs clean


# vim:ft=make
#

