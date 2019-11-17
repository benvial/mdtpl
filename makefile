FILES = paper.md \
		metadata.yaml

OUTPUT = build

BIB = /home/bench/Documents/latex/bibtex/biblio.bib


FLAGS = --bibliography=$(BIB) \
		--csl=bibliography.csl \
		-s \
		-f markdown \
		--filter pandoc-fignos \
		--filter pandoc-eqnos \
	 	--filter pandoc-tablenos \
	  --filter pandoc-citeproc

FLAGS_PDF = --template=template.latex

all: pdf

pdf:
	pandoc -o $(OUTPUT)/paper.pdf $(FLAGS) $(FLAGS_PDF) $(FILES)
	
tex:
	pandoc -o $(OUTPUT)/paper.tex $(FLAGS) $(FLAGS_PDF) $(FILES) --natbib

pdflatex: tex
	cd $(OUTPUT) && pdflatex paper && bibtex paper && pdflatex paper && pdflatex paper


clean:
	rm build/*
