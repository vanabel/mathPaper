.PHONY: all pdf clean distclean zip watch watch-xe install install-user

NAME := mathpaper
TEX := main.tex
PDF := $(TEX:.tex=.pdf)
VERSION ?= $(shell git describe --tags --abbrev=0 2>/dev/null || echo v0.0.0)
ZIP := mathpaper-$(VERSION).zip

UTREE = $(shell kpsewhich -var-value TEXMFHOME)
LOCAL = $(shell kpsewhich -var-value TEXMFLOCAL)
# TEXMF standard layout: tex/ (sty), source/ (dtx, ins), doc/ (pdf, examples)
DIR_TEX    = $(LOCAL)/tex/latex/$(NAME)
DIR_SOURCE = $(LOCAL)/source/latex/$(NAME)
DIR_DOC    = $(LOCAL)/doc/latex/$(NAME)
DIR_EXAMPLES = $(DIR_DOC)/examples

all: pdf

pdf:
	latexmk -pdf -interaction=nonstopmode $(TEX)

watch:
	latexmk -pdf -pvc -interaction=nonstopmode $(TEX)

watch-xe:
	latexmk -xelatex -pdf -pvc -interaction=nonstopmode $(TEX)

clean:
	latexmk -c $(TEX)
	rm -f *.brf *.bbl *.blg

distclean: clean
	latexmk -C $(TEX)
	rm -f $(PDF)

zip: pdf
	$(RM) $(ZIP) mathpaper-*.zip
	zip -r $(ZIP) \
		$(PDF) \
		$(TEX) mathpaper.sty references.bib amsrn.bst \
		Makefile README.md .gitignore \
		-x ".git/*" -x "*.zip" -x ".DS_Store"

# Install into TEXMFLOCAL (system-wide). Requires sudo.
# Layout: tex/latex/mathpaper/mathpaper.sty, doc/latex/mathpaper/examples/*.{tex,bib,bst,md,Makefile}
install: $(NAME).sty
	@echo "Installing to $(LOCAL)"
	sudo mkdir -p $(DIR_TEX) $(DIR_SOURCE) $(DIR_DOC) $(DIR_EXAMPLES)
	sudo cp $(NAME).sty $(DIR_TEX)/
	sudo cp README.md $(DIR_DOC)/
	sudo cp $(TEX) references.bib amsrn.bst Makefile $(DIR_EXAMPLES)/
	sudo mktexlsr

# Install into TEXMFHOME (user tree). No sudo.
install-user: $(NAME).sty
	@echo "Installing to $(UTREE)"
	mkdir -p $(UTREE)/tex/latex/$(NAME) $(UTREE)/source/latex/$(NAME) $(UTREE)/doc/latex/$(NAME) $(UTREE)/doc/latex/$(NAME)/examples
	cp $(NAME).sty $(UTREE)/tex/latex/$(NAME)/
	cp README.md $(UTREE)/doc/latex/$(NAME)/
	cp $(TEX) references.bib amsrn.bst Makefile $(UTREE)/doc/latex/$(NAME)/examples/
	mktexlsr

