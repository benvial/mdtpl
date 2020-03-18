
NAME = paper

FILES = $(NAME).md \
		metadata.yaml

OUTPUT = build
SRC = src

BIB = $(HOME)/.bib/biblio.bib

FLAGS = --filter pandoc-xnos \
		--bibliography=$(BIB) \
		-s \
		-f markdown


FLAGS_PDF = --template=$(SRC)/template.latex

watch:
	bash $(SRC)/autobuild

all: pdf

# pdf:
# 	pandoc -o $(OUTPUT)/paper.pdf $(FLAGS) $(FLAGS_PDF) $(FILES)

init:
	mkdir -p $(OUTPUT)
	cp -n $(SRC)/IEEEtran.cls $(OUTPUT)
	cp -n $(SRC)/IEEEtran.bst $(OUTPUT)

tex: init
	pandoc -o $(OUTPUT)/$(NAME).tex $(FLAGS) $(FLAGS_PDF) $(FILES) --natbib

pdf: tex
	cd $(OUTPUT) && pdflatex $(NAME) && bibtex $(NAME) && pdflatex $(NAME) && pdflatex $(NAME)

read:
	xdg-open $(OUTPUT)/$(NAME).pdf

clean:
	rm build/*
