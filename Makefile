BUILDTOOLS_ROOT ?= $(abspath ../buildtools)
NAME := node-bertrpc
RPK := out/$(NAME).rpk
RXPACKAGE = rxpackage.json

TAR=out/$(NAME).tar

TMP_DIR=out/$(NAME)

IGNORE_FILES = logs out out.o package.json

all default : $(RPK)

include $(BUILDTOOLS_ROOT)/make/buildtools.mk

SRC := $(call get_blush_files, $(IGNORE_FILES))
DST := $(call make_cp_targets, $(SRC), $(TMP_DIR))

$(RPK): Makefile $(RXPACKAGE)
	rxbuild package -r $(RXPACKAGE) $@ $(TAR)

$(TAR): $(DST)
	tar -cf $(TAR) -C out $(NAME)

$(DST): $(TMP_DIR)

$(TMP_DIR):
	mkdir -p $@

$(RXPACKAGE): rxpackage_template.json $(TAR) package.json $(MAKE_RXPACKAGE_JSON)
	$(MAKE_RXPACKAGE_JSON) $(RXPACKAGE) $(TMP_DIR)/package.json

clean:
	rm -rf out
	rm rxpackage.json
