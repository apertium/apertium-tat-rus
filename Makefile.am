###############################################################################
## Makefile for Tatar--Russian
###############################################################################

VERSION=0.2.0
LANG1=tat
LANG2=rus
PREFIX1=$(LANG1)-$(LANG2)
PREFIX2=$(LANG2)-$(LANG1)

BASENAME=apertium-$(PREFIX1)

TARGETS_COMMON = $(PREFIX1).autobil.bin \
	$(PREFIX1).automorf.bin $(PREFIX1).autogen.bin $(PREFIX1).t1x.bin $(PREFIX1).t2x.bin $(PREFIX1).t3x.bin \
	$(PREFIX2).automorf.bin $(PREFIX1).autopgen.bin \
	$(PREFIX1).lrx.bin \
        $(PREFIX1).rlx.bin 

# $(PREFIX1).autopgen.bin
# $(PREFIX2).lrx.bin
# $(PREFIX2).autogen.bin $(PREFIX2).t1x.bin $(PREFIX2).t2x.bin

# Use this goal for creating .deps, otherwise make -j2 will give problems:
.deps/.d:
	if [ ! -d .deps ]; then mkdir .deps; fi
	touch $@

# Prevent the .d file from being removed automatically:
.PRECIOUS: .deps/.d

###############################################################################
## Tatar→Russian monolingual transducers
###############################################################################

.deps/$(PREFIX1).autobil.prefixes: $(PREFIX1).autobil.bin .deps/.d
	lt-print $(PREFIX1).autobil.bin | sed 's/ /@_SPACE_@/g' > .deps/$(PREFIX1).autobil.att
	hfst-txt2fst -e ε <  .deps/$(PREFIX1).autobil.att > .deps/$(PREFIX1).autobil.hfst
	hfst-project -p upper .deps/$(PREFIX1).autobil.hfst > .deps/$(PREFIX1).autobil.upper
	echo " ?* " | hfst-regexp2fst > .deps/any-symbol.hfst
	hfst-concatenate -1 .deps/$(PREFIX1).autobil.upper -2 .deps/any-symbol.hfst -o .deps/$(PREFIX1).autobil.prefixes

#$(PREFIX1).automorf.bin: $(AP_LIB1)/$(LANG1).automorf.att.gz .deps/$(PREFIX1).autobil.prefixes .deps/.d
#	$(ZCAT) $< | hfst-txt2fst > .deps/$(LANG1).automorf.hfst
#	hfst-compose-intersect -1 .deps/$(LANG1).automorf.hfst -2 .deps/$(PREFIX1).autobil.prefixes -o .deps/$(PREFIX1).automorf.trimmed
#	hfst-fst2txt -i .deps/$(PREFIX1).automorf.trimmed -o .deps/$(PREFIX1).automorf.trimmed.att
#	lt-comp lr .deps/$(PREFIX1).automorf.trimmed.att $@


$(PREFIX1).automorf.bin: $(AP_LIB1)/$(LANG1).automorf.att.gz .deps/$(PREFIX1).autobil.prefixes .deps/.d
	$(ZCAT) $< > .deps/$(PREFIX1).automorf.att
	lt-comp lr .deps/$(PREFIX1).automorf.att $@

# $(PREFIX1).autogen.hfst: $(AP_LIB2)/$(LANG2).autogen.hfst
# 	cp $< $@

$(PREFIX1).autogen.bin: $(AP_LIB2)/$(LANG2).autogen.bin
	cp $< $@

###############################################################################
## Russian→Tatar monolingual transducers
###############################################################################

$(PREFIX2).automorf.bin: $(AP_LIB2)/$(LANG2).autogen.bin
	cp $< $@

$(PREFIX2).autogen.hfst: $(AP_LIB1)/$(LANG1).autogen.hfst
	cp $< $@

$(PREFIX2).autogen.bin: $(AP_LIB1)/$(LANG1).autogen.bin
	cp $< $@

###############################################################################
## Bilingual dictionaries
###############################################################################

$(PREFIX1).autobil.bin: $(BASENAME).$(PREFIX1).dix
	apertium-validate-dictionary $<
	lt-comp lr $< $@

#$(PREFIX2).autobil.bin: $(BASENAME).$(PREFIX1).dix
#	apertium-validate-dictionary $<
#	lt-comp rl $< $@

###############################################################################
## Prob files for tagger
###############################################################################

$(PREFIX1).prob: $(AP_LIB1)/$(LANG1).prob
	cp $< $@

###############################################################################
## Disambiguation rules
###############################################################################

$(PREFIX1).rlx.bin: $(AP_SRC1)/apertium-$(LANG1).$(LANG1).rlx
	cg-comp $< $@

###############################################################################
## Lexical selection rules
###############################################################################

$(PREFIX1).lrx.bin: $(BASENAME).$(PREFIX1).lrx
	lrx-comp $< $@

###############################################################################
## Structural transfer rules
###############################################################################

$(PREFIX1).t1x.bin: $(BASENAME).$(PREFIX1).t1x
	apertium-validate-transfer $<
	apertium-preprocess-transfer $< $@

$(PREFIX1).t2x.bin: $(BASENAME).$(PREFIX1).t2x
	apertium-validate-interchunk $<
	apertium-preprocess-transfer $< $@

$(PREFIX1).t3x.bin: $(BASENAME).$(PREFIX1).t3x
	apertium-validate-postchunk $<
	apertium-preprocess-transfer $< $@

###############################################################################
## Postgeneration dictionaries
###############################################################################

$(PREFIX1).autopgen.bin: $(AP_SRC2)/apertium-$(LANG2).post-$(LANG2).dix
	apertium-validate-dictionary $<
	lt-comp lr $< $@

#$(PREFIX2).autopgen.bin: $(AP_SRC2)/apertium-$(LANG2).post-$(LANG2).dix
#	apertium-validate-dictionary $<
#	lt-comp lr $< $@

###############################################################################
## Translation modes
###############################################################################

# All modes are created by this one goal
modes/$(PREFIX1).mode: modes.xml
	apertium-validate-modes modes.xml
	apertium-gen-modes modes.xml
	cp *.mode modes/

EXTRA_DIST= \
           $(BASENAME).$(PREFIX1).dix \
           $(BASENAME).post-$(LANG2).dix \
           $(BASENAME).$(PREFIX1).lrx \
           $(BASENAME).$(PREFIX1).t1x \
           $(BASENAME).$(PREFIX1).t2x \
           $(BASENAME).$(PREFIX1).t3x \
           modes.xml

apertium_modesdir=$(prefix)/share/apertium/modes/
apertium_tat_rusdir=$(prefix)/share/apertium/$(BASENAME)/

apertium_tat_rus_DATA=$(TARGETS_COMMON) \
                    $(PREFIX1).prob \
		    modes.xml

# $(PREFIX2).prob

# All modes are created by the same goal, listing several will just give problems with make -j2
noinst_DATA=modes/$(PREFIX1).mode


install-data-local:
	mv modes modes~
	$(prefix)/bin/apertium-gen-modes modes.xml $(BASENAME)
	rm -rf modes
	mv modes~ modes
	test -d $(DESTDIR)$(apertium_modesdir) || mkdir $(DESTDIR)$(apertium_modesdir)
	$(INSTALL_DATA) $(PREFIX1).mode $(DESTDIR)$(apertium_modesdir)
#	$(INSTALL_DATA) $(PREFIX2).mode $(DESTDIR)$(apertium_modesdir)
	rm $(PREFIX1).mode
#	rm $(PREFIX2).mode
	$(INSTALL_DATA) $(BASENAME).$(PREFIX1).t1x $(DESTDIR)$(apertium_tat_rusdir)
	$(INSTALL_DATA) $(BASENAME).$(PREFIX1).t2x $(DESTDIR)$(apertium_tat_rusdir)
	$(INSTALL_DATA) $(BASENAME).$(PREFIX1).t3x $(DESTDIR)$(apertium_tat_rusdir)
#	$(INSTALL_DATA) $(BASENAME).$(PREFIX2).t1x $(DESTDIR)$(apertium_tat_rusdir)
#	$(INSTALL_DATA) $(BASENAME).$(PREFIX2).t2x $(DESTDIR)$(apertium_tat_rusdir)
#	$(INSTALL_DATA) $(BASENAME).$(PREFIX2).t3x $(DESTDIR)$(apertium_tat_rusdir)

CLEANFILES = $(TARGETS_COMMON)
clean-local:
	-rm -rf .deps modes
