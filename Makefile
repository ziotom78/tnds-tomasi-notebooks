PANDOC := /usr/bin/pandoc
PANDOC_IMAGINE := $(HOME)/bin/pandoc-imagine
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
	carminati-esercizi-04.html \
	carminati-esercizi-03.html \
	carminati-esercizi-02.html \
	carminati-esercizi-01.html \
	temi-svolti.html \
	prepararsi-esame.html \
	miscellanea.html \
	qt-creator.html \
	configure-your-laptop.html \
	index.html

index.html: index.md
	$(PANDOC) \
		--katex \
		--to html5+smart \
		--toc \
		--toc-depth 2 \
		--template ./template.html5 \
		--css css/theme.css \
		--css css/skylighting-solarized-theme.css \
		--css ./css/asciinema-player.css \
		-A asciinema-include.html \
		--wrap=none \
		-f markdown+tex_math_single_backslash+subscript+superscript \
		-o $@ \
		$<

carminati-esercizi-%.html: carminati-esercizi-%.md
	$(PANDOC) \
		--katex \
		--to html5+smart \
		--toc \
		--toc-depth 2 \
		--template ./template.html5 \
		--css css/theme.css \
		--css css/skylighting-solarized-theme.css \
		--wrap=none \
		-f markdown+tex_math_single_backslash+subscript+superscript \
		-o $@ $<

temi-svolti.html: temi-svolti.md
	$(PANDOC) \
		--katex \
		--to html5+smart \
		--toc \
		--toc-depth 2 \
		--template ./template.html5 \
		--css css/theme.css \
		--css css/skylighting-solarized-theme.css \
		--wrap=none \
		-f markdown+tex_math_single_backslash+subscript+superscript \
		-o $@ $<

prepararsi-esame.html: prepararsi-esame.md
	$(PANDOC) \
		--katex \
		--to html5+smart \
		--toc \
		--toc-depth 2 \
		--template ./template.html5 \
		--css css/theme.css \
		--css css/skylighting-solarized-theme.css \
		--wrap=none \
		-f markdown+tex_math_single_backslash+subscript+superscript \
		-o $@ $<

miscellanea.html: miscellanea.md
	$(PANDOC) \
		--katex \
		--to html5+smart \
		--toc \
		--toc-depth 2 \
		--template ./template.html5 \
		--css css/theme.css \
		--css css/skylighting-solarized-theme.css \
		--wrap=none \
		-f markdown+tex_math_single_backslash+subscript+superscript \
		-o $@ $<

configure-your-laptop.html: configure-your-laptop.md
	$(PANDOC) \
		--katex \
		--to html5+smart \
		--toc \
		--toc-depth 2 \
		--template ./template.html5 \
		--css css/theme.css \
		--css css/skylighting-solarized-theme.css \
		--wrap=none \
		-f markdown+tex_math_single_backslash+subscript+superscript \
		-o $@ $<

qt-creator.html: qt-creator.md
	$(PANDOC) \
		--katex \
		--to html5+smart \
		--toc \
		--toc-depth 2 \
		--template ./template.html5 \
		--css css/theme.css \
		--css css/skylighting-solarized-theme.css \
		--wrap=none \
		-f markdown+tex_math_single_backslash+subscript+superscript \
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
