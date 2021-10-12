PANDOC := /usr/bin/pandoc
PANDOC_IMAGINE := $(HOME)/bin/pandoc_imagine.py
.phony: all

all: \
	tomasi-lezione-02.html \
	tomasi-lezione-01.html \
	index.html

index.html: index.md ${JS_FILES}
	$(PANDOC) --standalone -o $@ $<

%.html: %.md
	$(PANDOC) \
	    	--standalone \
		--filter $(PANDOC_IMAGINE) \
		--css ./css/custom.css \
		--css ./css/asciinema-player.css \
		-A asciinema-include.html \
		--katex \
		-V theme=white \
		-V progress=true \
		-V slideNumber=true \
		-V background-image=./media/background.png \
		-V width=1440 \
		-V height=810 \
		-f markdown+tex_math_single_backslash+subscript+superscript \
		-t revealjs \
		-o $@ $<
