INDIR=src/
INPUT_ADOC=book.adoc
INPUTS_ADOC=*.adoc
INFILE=$(INDIR)$(INPUT_ADOC)
INFILES=$(INDIR)$(INPUTS_ADOC)
IMAGES=
OUTNAME=ttdm-workbook
OUTDIR=doc/
OUTFILE=$(OUTDIR)$(OUTNAME)
EXTS=html pdf docx md txt epub mobi xml

all: $(EXTS)

clean:
	for ext in $(EXTS); do rm -f $(OUTFILE).$$ext; done

html: $(OUTFILE).html

$(OUTFILE).html: $(INFILES) $(IMAGES)
	asciidoctor -b html5 -d book -a data-uri $(INFILE) -o $(OUTFILE).html

pdf: $(OUTFILE).pdf

$(OUTFILE).pdf: $(INFILES) $(IMAGES)
	asciidoctor-pdf $(INFILE) -o $(OUTFILE).pdf

xml: $(OUTFILE).xml

$(OUTFILE).xml: $(INFILES) $(IMAGES)
	asciidoctor -b docbook -d book $(INFILE) -o $(OUTFILE).xml

docx: $(OUTFILE).docx

$(OUTFILE).docx: $(OUTFILE).xml
	pandoc --from docbook --to docx --toc --toc-depth=2 --output $(OUTFILE).docx $(OUTFILE).xml

md: $(OUTFILE).md

$(OUTFILE).md: $(OUTFILE).html
	pandoc -f html -t gfm -s --toc --toc-depth=2 -o $(OUTFILE).md $(OUTFILE).html

txt: $(OUTFILE).txt

$(OUTFILE).txt: $(OUTFILE).html
	pandoc -f html -t plain -s --toc --toc-depth=2 -o $(OUTFILE).txt $(OUTFILE).html

epub: $(OUTFILE).epub

$(OUTFILE).epub: $(OUTFILE).xml
	pandoc -f docbook -t epub3 --toc --toc-depth=2 -o $(OUTFILE).epub $(OUTFILE).xml
	ebook-polish -u -i -U $(OUTFILE).epub $(OUTFILE).epub

mobi: $(OUTFILE).mobi

$(OUTFILE).mobi: $(OUTFILE).epub
	ebook-convert $(OUTFILE).epub $(OUTFILE).mobi

