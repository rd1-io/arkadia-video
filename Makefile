REMOTE  := origin
BRANCH  := main
DOCS    := docs
PDFDIR  := pdf
CSS     := $(DOCS)/style.css
LOGO    := $(DOCS)/logo.png
HEADER  := $(DOCS)/header.html

MD_FILES  := $(sort $(wildcard $(DOCS)/*.md))
PDF_FILES := $(patsubst $(DOCS)/%.md,$(PDFDIR)/%.pdf,$(MD_FILES))

.PHONY: release build-pdf clean

release: build-pdf
	git add $(DOCS)/*.md $(PDFDIR)/*.pdf $(CSS) $(LOGO)
	git commit -m "docs: update project documentation $$(date '+%Y-%m-%d')" || true
	git push -u $(REMOTE) $(BRANCH)

build-pdf: $(PDF_FILES)

$(PDFDIR)/%.pdf: $(DOCS)/%.md $(CSS) $(LOGO) $(HEADER) | $(PDFDIR)
	pandoc "$<" \
		--from markdown \
		--to html5 \
		--css "$(CSS)" \
		--include-before-body "$(HEADER)" \
		--embed-resources --standalone \
		--metadata title=" " \
		-o "$<.tmp.html"
	weasyprint "$<.tmp.html" "$@"
	@rm -f "$<.tmp.html"

$(PDFDIR):
	mkdir -p $(PDFDIR)

clean:
	rm -rf $(PDFDIR)
