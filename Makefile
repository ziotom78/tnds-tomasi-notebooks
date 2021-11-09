PANDOC := /usr/bin/pandoc
PANDOC_IMAGINE := $(HOME)/bin/pandoc_imagine.py
.phony: all http

all: \
	tomasi-lezione-06.html \
	tomasi-lezione-05.html \
	tomasi-lezione-04.html \
	tomasi-lezione-03.html \
	tomasi-lezione-02.html \
	tomasi-lezione-01.html \
	carminati-esercizi-11.html \
	carminati-esercizi-10.html \
	carminati-esercizi-09.html \
	carminati-esercizi-08.html \
	carminati-esercizi-06.html \
	carminati-esercizi-05.html \
	carminati-esercizi-03.html \
	carminati-esercizi-02.html \
	carminati-esercizi-01.html \
	index.html

index.html: index.md
	$(PANDOC) --standalone -o $@ $<

carminati-esercizi-%.html: carminati-esercizi-%.md
	$(PANDOC) \
	    	--standalone \
		--katex \
		--toc \
		--template ./template.html5 \
		-f markdown+tex_math_single_backslash+subscript+superscript \
		-t html5 \
		-o $@ $<

tomasi-lezione-%.html: tomasi-lezione-%.md
	$(PANDOC) \
	    	--standalone \
		--filter $(PANDOC_IMAGINE) \
		-A asciinema-include.html \
		--katex \
		-f markdown+tex_math_single_backslash+subscript+superscript \
		-t revealjs \
		-o $@ $<

http:
	python3 -m http.server
