BUILDTOOLS_NO_MACRO=t
BUILDTOOLS_NO_GCC=t
BUILDTOOLS_NO_C=t
BUILDTOOLS_NO_PROTOBUF=t
BUILDTOOLS_NO_PIQI=t
BUILDTOOLS_NO_PYTHON=t
BUILDTOOLS_NO_JAVA=t
BUILDTOOLS_NO_ERLANG=t
BUILDTOOLS_NO_FLEX=t
BUILDTOOLS_ROOT ?= $(abspath ../buildtools)
NAME := node-bertrpc
APK := out/$(NAME).apk
APACKAGE = apackage.json

TAR=out/$(NAME).tar

TMP_DIR=out/$(NAME)

IGNORE_FILES = logs out out.o package.json

all default : $(APK)

include $(BUILDTOOLS_ROOT)/make/buildtools.mk

SRC := $(call get_blush_files, $(IGNORE_FILES))
DST := $(call make_cp_targets, $(SRC), $(TMP_DIR))

$(APK): Makefile $(TAR)
	abuild package -r $(APACKAGE) $@ $(TAR)

$(TAR): $(DST) $(APACKAGE)
	tar -cf $(TAR) -C out $(NAME)

$(DST): $(TMP_DIR)

$(TMP_DIR):
	mkdir -p $@

$(APACKAGE): apackage_template.json package.json $(MAKE_APACKAGE_JSON)
	$(MAKE_APACKAGE_JSON) $(APACKAGE) $(TMP_DIR)/package.json

clean:
	rm -rf out
	rm -f apackage.json
