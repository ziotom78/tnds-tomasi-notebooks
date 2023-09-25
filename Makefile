PANDOC := /usr/bin/pandoc
PANDOC_IMAGINE := $(HOME)/bin/pandoc_imagine.py
.phony: all http

all: \
    tomasi-c++-python-julia.html \
	tomasi-lezione-11.html \
	tomasi-lezione-08.html \
	tomasi-lezione-06.html \
	tomasi-lezione-05.html \
	tomasi-lezione-04.html \
	tomasi-lezione-03.html \
	tomasi-lezione-02.html \
	tomasi-lezione-01.html \
	carminati-esercizi-12.html \
	carminati-esercizi-10.html \
	carminati-esercizi-08.html \
	carminati-esercizi-07.html \
	carminati-esercizi-06.html \
	carminati-esercizi-05.html \
	carminati-esercizi-03.html \
	carminati-esercizi-02.html \
	carminati-esercizi-01.html \
	index.html

index.html: index.md
	$(PANDOC) \
		--standalone \
		-A asciinema-include.html \
                --template ./template.html5 \
		-o $@ \
		$<

carminati-esercizi-%.html: carminati-esercizi-%.md
	$(PANDOC) \
	    	--standalone \
		--katex \
		--toc \
                --template ./template.html5 \
		-f markdown+tex_math_single_backslash+subscript+superscript \
		-t html5 \
		-o $@ $<

tomasi-c++-python-julia.html: tomasi-c++-python-julia.md
	$(PANDOC) \
	  	--standalone \
		--filter pandoc-imagine \
		--katex \
		--css ./css/asciinema-player.css \
		-A asciinema-include.html \
		-V theme=white \
		-V progress=true \
		-V slideNumber=true \
		-V history=true \
		-V background-image=./media/background.png \
		-V width=1440 \
		-V height=810 \
		-f markdown+tex_math_single_backslash+subscript+superscript \
		-t revealjs \
		-o $@ $<

tomasi-lezione-%.html: tomasi-lezione-%.md
	$(PANDOC) \
	    	--standalone \
		--filter $(PANDOC_IMAGINE) \
		-A asciinema-include.html \
                --template ./template-revealjs.html5 \
		--katex \
		-f markdown+tex_math_single_backslash+subscript+superscript \
		-t revealjs \
		-o $@ $<

http:
	python3 -m http.server
