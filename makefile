
.PHONY: all autobuild clean

SHELL := /bin/bash

TEXCMD = pydflatex
BIBTEXCMD = bibtex
CHECKCMD = pydflatex -l

ifndef VERBOSE
.SILENT:
endif


ifndef TEXOUTPUT
NOOUT = > /dev/null 2>&1
endif

NAME = paper

FILES = $(SRC)/$(NAME).md \
		$(SRC)/metadata.yaml

OUTPUT = build
SRC = src

BIB = biblio.bib
BIBSTYLE = biblio
TEXSTYLE = IEEEtran
MACROS = macros

FLAGS = --filter pandoc-xnos \
		--bibliography=biblio.bib \
		--natbib \
		-s \
		-f markdown

FLAGSDOCX = --bibliography=biblio.bib

FLAGS_PDF = --template=$(SRC)/template.latex



watch: autobuild read
	bash autobuild watch

autobuild:
	bash autobuild

all: pdf


bib:
	rm -f $(SRC)/biblio.bib
	cat $(HOME)/.bib/clean.bib $(SRC)/extra.bib >> $(SRC)/biblio.bib
	cp $(SRC)/biblio.bib $(OUTPUT)/biblio.bib
	

init: bib
	mkdir -p $(OUTPUT)
	cp -rf $(SRC)/fig $(OUTPUT)
	cp -f $(SRC)/$(TEXSTYLE).cls $(OUTPUT)
	cp -f $(SRC)/$(BIBSTYLE).bst $(OUTPUT)
	cp -f $(SRC)/$(MACROS).tex $(OUTPUT)

tex: init
	pandoc -o $(OUTPUT)/$(NAME).tex $(FLAGS) $(FLAGS_PDF) $(FILES)

pdf: tex
	cd $(OUTPUT) && \
	$(TEXCMD) $(NAME) $(NOOUT) && \
	$(BIBTEXCMD) $(NAME) $(NOOUT) && \
	$(TEXCMD) $(NAME) $(NOOUT) && \
	$(TEXCMD) $(NAME) $(NOOUT)

read:
	xdg-open $(OUTPUT)/$(NAME).pdf $(NOOUT)
	
read-docx:
	xdg-open $(OUTPUT)/$(NAME).docx $(NOOUT)

clean:
	rm -rf build/*

docx: tex
	cd $(OUTPUT) && pandoc -o $(NAME).docx -t docx $(FLAGSDOCX) $(NAME).tex;
	
check:
	$(CHECKCMD) $(OUTPUT)/$(NAME).tex || true
