.PHONY: all pdf clean distclean

TEX := main.tex
PDF := $(TEX:.tex=.pdf)

all: pdf

pdf:
	latexmk -pdf -interaction=nonstopmode $(TEX)

clean:
	latexmk -c $(TEX)
	rm -f *.brf *.bbl *.blg

distclean: clean
	latexmk -C $(TEX)
	rm -f $(PDF)

