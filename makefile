FILES = paper.md \
		metadata.yaml

OUTPUT = build

BIB = $(HOME)/.bib/biblio.bib


FLAGS = --filter pandoc-xnos \
		--bibliography=$(BIB) \
		-s \
		-f markdown


FLAGS_PDF = --template=template.latex

all: pdf

# pdf:
# 	pandoc -o $(OUTPUT)/paper.pdf $(FLAGS) $(FLAGS_PDF) $(FILES)

tex:
	pandoc -o $(OUTPUT)/paper.tex $(FLAGS) $(FLAGS_PDF) $(FILES) --natbib

pdf: tex
	cd $(OUTPUT) && pdflatex paper && bibtex paper && pdflatex paper && pdflatex paper


clean:
	rm build/*
