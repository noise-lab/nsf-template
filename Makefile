REPORT=proposal
LATEX=pdflatex
BIBTEX=bibtex --min-crossrefs=1000
REF1=ref
REF2=rfc

TEX = $(wildcard *.tex)
CLS = $(wildcard *.cls)
SRCS = $(TEX)
REFS=$(REF1).bib $(REF2).bib

all: pdf

pdf: figures $(SRCS) $(CLS)
	$(LATEX) $(REPORT)
	$(BIBTEX) $(REPORT)
	perl -pi -e "s/%\s+//" $(REPORT).bbl
	$(LATEX) $(REPORT)
	$(LATEX) $(REPORT)

$(REPORT).ps: $(REPORT).dvi figures
#	dvips -Pcmz -t letter $(REPORT).dvi -o $(REPORT).ps
	dvips -Ppdf -G0 -t letter $(REPORT).dvi -o $(REPORT).ps

web: pdf
	scp -C $(REPORT).pdf feamster@central.gtnoise.net:/var/www/tmp/

spell:
	for i in *.tex; do ispell $$i; done

double:
	for i in *.tex; do double.pl $$i; done

split:  pdf
	pdftk $(REPORT).pdf cat 1 output $(REPORT)-0.pdf
	pdftk $(REPORT).pdf cat 2-16 output $(REPORT)-1.pdf
	pdftk $(REPORT).pdf cat 17-21 output $(REPORT)-2.pdf

#not relevant here
figures:
	cd figures; make

view: $(REPORT).dvi
	xdvi $(REPORT).dvi

print: $(REPORT).dvi
	dvips $(REPORT).dvi

printer: $(REPORT).ps
	lpr $(REPORT).ps

tidy:
	rm -f *.dvi *.aux *.log *.blg *.bbl

clean:
	rm -f *~ *.dvi *.aux *.log *.blg *.bbl *.brf *.out $(REPORT).ps $(REPORT).pdf

