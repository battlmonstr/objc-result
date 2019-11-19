.PHONY: docs

docs: OCResult/OCResult.h OCResult/OCResult+BlockAdapters.h
	rm -rf docs
	headerdoc2html -o docs $^
	gatherheaderdoc docs index.html
