MAIN := $(shell ls -t *tex | cut -d '.' -f 1 | grep -v "[0-9]\{12\}" | grep -v v\[0-9\] | head -1)

LATEXMK := latexmk
LATEXMK_FLAGS := -pdf -interaction=nonstopmode -halt-on-error
SECTIONS := $(wildcard sections/*.tex)

.PHONY: all pdf clean distclean help

all: pdf

pdf: $(MAIN).pdf

$(MAIN).pdf: $(MAIN).tex $(SECTIONS) references.bib cas-dc.cls cas-common.sty cas-model2-names.bst
	$(LATEXMK) $(LATEXMK_FLAGS) $(MAIN).tex

pub:
	make
	@if [ "$(shell git tag --points-at HEAD)" == "" ]; then\
		gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress -dEmbedAllFonts=true -sOutputFile=${MAIN}_`git log -1 --pretty=format:"%h_%ai" | tr -d '-' | tr -d ' ' | tr -d ':' | cut -d '+' -f 1`.pdf -f ${MAIN}.pdf;\
	else\
		gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress -dEmbedAllFonts=true -sOutputFile=${MAIN}_"$(shell git tag --points-at HEAD)".pdf -f ${MAIN}.pdf;\
	fi

clean:
	$(LATEXMK) -c $(MAIN).tex

distclean:
	$(LATEXMK) -C $(MAIN).tex

help:
	@echo "Available targets:"
	@echo "  make          Build main.pdf"
	@echo "  make pdf      Build main.pdf"
	@echo "  make clean    Remove intermediate LaTeX files"
	@echo "  make distclean Remove intermediate files and main.pdf"
