# Global variables {{{1
# ================
# Where make should look for things
VPATH = lib
vpath %.csl styles
vpath %.yaml .:spec
vpath default.% lib/pandoc-templates

# Branch-specific targets and recipes {{{1
# ===================================

%.docx : article_docx.yaml %.md | styles
	docker run --user "`id -u`:`id -g`" \
		-v "`pwd`:/data" pandoc/crossref:2.10.1 \
		-o $@ -d $^

%.md : docx2md.yaml %.docx
	docker run --user "`id -u`:`id -g`" \
		-v "`pwd`:/data" pandoc/core:2.10.1 \
		-o $@ -d $^

styles :
	git clone https://github.com/citation-style-language/styles.git

# Install and cleanup {{{1
# ===================

clean :
	-rm -r styles .*.lb *.aux *.bbl *.bcf *.blg *-blx.aux *-blx.bib *.cb \
		*.cb2 *.dvi *.fls *.fmt *.fot *.lof *.log *.lot *.out *.run.xml \
		*.toc *.xdv

# vim: set foldmethod=marker :
