.PHONY: all pdf clean distclean zip

TEX := main.tex
PDF := $(TEX:.tex=.pdf)
VERSION ?= $(shell git describe --tags --abbrev=0 2>/dev/null || echo v0.0.0)
ZIP := mathpaper-$(VERSION).zip

all: pdf

pdf:
	latexmk -pdf -interaction=nonstopmode $(TEX)

clean:
	latexmk -c $(TEX)
	rm -f *.brf *.bbl *.blg

distclean: clean
	latexmk -C $(TEX)
	rm -f $(PDF)

zip: pdf
	$(RM) $(ZIP)
	zip -r $(ZIP) \
		$(PDF) \
		$(TEX) mathpaper.sty references.bib amsrn.bst \
		Makefile README.md .gitignore \
		-x ".git/*" -x "*.zip" -x ".DS_Store"

