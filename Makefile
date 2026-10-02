.PHONY: all pdf help watch live watch-xe stop clean distclean zip install install-user

NAME := mathpaper

# Entry .tex (override: make MAIN=other.tex  or  put MAIN=... in Makefile.local)
-include Makefile.local
MAIN ?= main.tex
PDF  := $(MAIN:.tex=.pdf)
JOB  := $(basename $(MAIN))
# Portable version probe (git + perl; single-quoted so shells do not expand $v).
VERSION ?= $(shell perl -e 'my $$v=qx(git describe --tags --abbrev=0); chomp $$v; print length($$v)?$$v:"v0.0.0"')
ZIP := mathpaper-$(VERSION).zip

# Engine: pdf (default) or xe.  Override: make ENGINE=xe  or Makefile.local
ENGINE ?= pdf
ifeq ($(ENGINE),xe)
  LATEXMK_ENGINE := -xelatex
else
  LATEXMK_ENGINE := -pdf
endif

LATEXMK := latexmk $(LATEXMK_ENGINE) -interaction=nonstopmode

# ---------------------------------------------------------------------------
# Cross-platform: macOS / Linux / Windows (GNU Make)
# - Native Windows (cmd): OS=Windows_NT and SHELL is not a POSIX sh
# - Git Bash / MSYS2 / Cygwin on Windows: treat as Unix-like
# Cleanup uses Perl (ships with TeX Live / MiKTeX) so recipes stay portable.
# ---------------------------------------------------------------------------
ifeq ($(OS),Windows_NT)
  _SHELL_NAME := $(notdir $(SHELL))
  ifneq ($(filter sh.exe sh bash.exe bash dash.exe dash zsh.exe zsh fish.exe fish,$(_SHELL_NAME)),)
    UNIX_LIKE := 1
  else ifdef MSYSTEM
    UNIX_LIKE := 1
  else
    UNIX_LIKE :=
  endif
else
  UNIX_LIKE := 1
endif

UTREE = $(shell kpsewhich -var-value TEXMFHOME)
LOCAL = $(shell kpsewhich -var-value TEXMFLOCAL)
DIR_TEX      = $(LOCAL)/tex/latex/$(NAME)
DIR_SOURCE   = $(LOCAL)/source/latex/$(NAME)
DIR_DOC      = $(LOCAL)/doc/latex/$(NAME)
DIR_EXAMPLES = $(DIR_DOC)/examples

all: pdf

help:
	@echo "Entry: $(MAIN)  (override: make MAIN=other.tex or Makefile.local)"
	@echo "Engine: $(ENGINE)  (override: make ENGINE=xe)"
	@echo "make          build $(PDF) once"
	@echo "make watch    continuous build (latexmk -pvc); same as make live"
	@echo "make live     same as make watch"
	@echo "make watch-xe continuous build with XeLaTeX (ENGINE=xe)"
	@echo "make stop     stop latexmk/TeX for this project (Unix / Git Bash)"
	@echo "make clean    remove intermediate files"
	@echo "make distclean  clean + remove $(PDF)"
	@echo "make zip      package release zip"
	@echo "make install / install-user  install sty into TEXMF (Unix)"

pdf:
	@echo ">> MAIN=$(MAIN)  ENGINE=$(ENGINE)"
	$(LATEXMK) $(MAIN)

watch live:
	@echo ">> MAIN=$(MAIN)  ENGINE=$(ENGINE)"
	@echo ">> watch: save .tex to rebuild and refresh PDF (Ctrl+C to quit)"
	$(LATEXMK) -pvc -view=pdf $(MAIN)

watch-xe:
	@$(MAKE) ENGINE=xe watch

# Stop this project's latexmk / pdflatex / xelatex / bibtex (scoped by CURDIR / MAIN / JOB).
# Relies on POSIX ps; on native Windows cmd, ask the user to Ctrl+C the watch window.
stop:
ifeq ($(UNIX_LIKE),1)
	@echo ">> stopping LaTeX build for $(MAIN) in $(CURDIR)"
	@perl -e ' \
	  use strict; use warnings; \
	  my $$dir  = q($(CURDIR)); \
	  my $$main = q($(MAIN)); \
	  my $$job  = q($(JOB)); \
	  my $$self = $$$$; \
	  my $$tool_tok = qr{(?:^|\s)(?:\S*/)?(?:latexmk|pdflatex|xelatex|xetex|lualatex|biber|bibtex|makeindex)(?:\s|$$)}; \
	  my $$shell = qr{(?:^|/)(?:zsh|bash|sh|dash|fish|csh|tcsh)(?:\s|$$)}; \
	  my %want; \
	  open my $$ps, "-|", "ps", "-axo", "pid=,args=" or die $$!; \
	  while (<$$ps>) { \
	    chomp; \
	    next unless /^\s*(\d+)\s+(.*)\z/; \
	    my ($$pid, $$args) = ($$1 + 0, $$2); \
	    next if $$pid == $$self; \
	    next if $$args =~ $$shell; \
	    next unless $$args =~ $$tool_tok; \
	    next unless index($$args, $$dir) >= 0 \
	             || index($$args, $$main) >= 0 \
	             || $$args =~ /(?:^|\s|\/)\Q$$job\E\.(?:tex|bcf|idx|ind|ilg|aux|fls|fdb_latexmk)\b/; \
	    $$want{$$pid} = $$args; \
	  } \
	  close $$ps; \
	  for my $$pid (split /\n/, qx(pgrep -x make 2>/dev/null)) { \
	    $$pid += 0; \
	    next unless $$pid; \
	    next if $$pid == $$self; \
	    my $$cwd = qx(lsof -a -p $$pid -d cwd -Fn 2>/dev/null); \
	    next unless $$cwd =~ /^n\Q$$dir\E\s*\z/m; \
	    my $$args = qx(ps -p $$pid -o args= 2>/dev/null); \
	    chomp $$args; \
	    next unless $$args =~ /(?:^|\s)(?:watch|live|watch-xe|pdf)(?:\s|$$)/; \
	    $$want{$$pid} = $$args; \
	  } \
	  unless (%want) { print ">> no matching processes\n"; exit 0; } \
	  for my $$pid (sort { $$a <=> $$b } keys %want) { \
	    print "   TERM $$pid  $$want{$$pid}\n"; \
	    kill "TERM", $$pid; \
	  } \
	  select undef, undef, undef, 0.4; \
	  for my $$pid (keys %want) { \
	    next unless kill 0, $$pid; \
	    my $$args = qx(ps -p $$pid -o args= 2>/dev/null); \
	    chomp $$args; \
	    print "   KILL $$pid  $$args\n"; \
	    kill "KILL", $$pid; \
	  } \
	  print ">> stopped\n"; \
	'
else
	@echo ">> make stop needs a POSIX shell (Git Bash / MSYS2)."
	@echo ">> On native Windows: press Ctrl+C in the watch window, or close that terminal."
endif

clean:
	latexmk -c $(MAIN)
	@perl -e 'unlink grep { -e $$_ } @ARGV; exit 0' \
		$(JOB).brf $(JOB).bbl $(JOB).blg $(JOB).bcf $(JOB).run.xml

distclean: clean
	latexmk -C $(MAIN)
	@perl -e 'unlink grep { -e $$_ } @ARGV; exit 0' $(PDF)

# Package release .zip: prefer Info-ZIP `zip`, else `7z`/`7za` (common on Windows).
ZIP_FILES := $(PDF) $(MAIN) mathpaper.sty references.bib amsrn.bst \
	Makefile Makefile.local.example README.md .gitignore .latexmkrc

zip: pdf
	@perl -e ' \
	  use strict; use warnings; \
	  use File::Spec; \
	  my $$out = q($(ZIP)); \
	  my @files = qw($(ZIP_FILES)); \
	  for my $$f (@files) { die "missing $$f\n" unless -e $$f; } \
	  unlink $$out if -e $$out; \
	  for my $$old (glob("mathpaper-*.zip")) { unlink $$old; } \
	  sub which { \
	    my ($$name) = @_; \
	    my $$sep = ($$^O eq "MSWin32") ? ";" : ":"; \
	    my @ext = ($$^O eq "MSWin32") ? (".exe", ".bat", ".cmd", "") : (""); \
	    for my $$dir (split /\Q$$sep\E/, ($$ENV{PATH} // "")) { \
	      for my $$ext (@ext) { \
	        my $$p = File::Spec->catfile($$dir, $$name . $$ext); \
	        return $$p if -e $$p; \
	      } \
	    } \
	    return; \
	  } \
	  my $$zip = which("zip"); \
	  my $$seven = which("7z") || which("7za"); \
	  my $$rc; \
	  if ($$zip) { \
	    print ">> packing with zip: $$zip\n"; \
	    $$rc = system($$zip, "-r", $$out, @files, "-x", ".git/*", "-x", "*.zip", "-x", ".DS_Store"); \
	  } elsif ($$seven) { \
	    print ">> packing with 7z: $$seven\n"; \
	    $$rc = system($$seven, "a", "-tzip", "-x!.git", "-x!*.zip", "-x!.DS_Store", $$out, @files); \
	  } else { \
	    die "need `zip` or `7z`/`7za` on PATH\n"; \
	  } \
	  exit($$rc == 0 ? 0 : 1); \
	'

# Install into TEXMFLOCAL (system-wide). Requires sudo (Unix).
install: $(NAME).sty
ifeq ($(UNIX_LIKE),)
	@echo ">> make install is for Unix/macOS; on Windows copy mathpaper.sty into your TEXMF tree manually."
	@exit 1
else
	@echo "Installing to $(LOCAL)"
	sudo mkdir -p $(DIR_TEX) $(DIR_SOURCE) $(DIR_DOC) $(DIR_EXAMPLES)
	sudo cp $(NAME).sty $(DIR_TEX)/
	sudo cp README.md $(DIR_DOC)/
	sudo cp $(MAIN) references.bib amsrn.bst Makefile $(DIR_EXAMPLES)/
	sudo mktexlsr
endif

# Install into TEXMFHOME (user tree). No sudo.
install-user: $(NAME).sty
ifeq ($(UNIX_LIKE),)
	@echo ">> make install-user is for Unix/macOS; on Windows copy mathpaper.sty into TEXMFHOME manually."
	@exit 1
else
	@echo "Installing to $(UTREE)"
	mkdir -p $(UTREE)/tex/latex/$(NAME) $(UTREE)/source/latex/$(NAME) $(UTREE)/doc/latex/$(NAME) $(UTREE)/doc/latex/$(NAME)/examples
	cp $(NAME).sty $(UTREE)/tex/latex/$(NAME)/
	cp README.md $(UTREE)/doc/latex/$(NAME)/
	cp $(MAIN) references.bib amsrn.bst Makefile $(UTREE)/doc/latex/$(NAME)/examples/
	mktexlsr
endif
