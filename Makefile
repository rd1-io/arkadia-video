REMOTE  := origin
BRANCH  := main
DOCS    := docs

.PHONY: release

release:
	git add $(DOCS)/*.md
	git commit -m "docs: update project documentation $$(date '+%Y-%m-%d')" || true
	git push -u $(REMOTE) $(BRANCH)
