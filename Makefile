.PHONY: ws
ws: build/index.html
	websocketd --port 8080 make watch

build/index.html: $(shell find source -type f)
	@make build source='source/index.adoc'
	@rsync --quiet -av --delete source/images build/images/
	@echo Built at $(shell date)

.PHONY: watch
watch:
	@fswatch -r source Makefile \
		| xargs -I@ -n1 make build/index.html \
		| while read event; do \
				if [[ "$$event" == Built* ]]; then \
					echo Refresh away!; \
				fi; \
			done

.PHONY: clean
clean:
	rm -rf build/*

.PHONY: build
build:
	@HOME=~ asciidoctor -v \
		-a toc=left \
		-a imagesdir=images \
		-a source-highlighter=highlight.js \
		-a icons=font \
		-a sectlinks \
		-a prewrap! \
		-a docinfo=shared \
		--safe \
		-D build $$source

.PHONY: local
local:
	@make build source=$$source
	@basename $$source | sed 's/\.adoc/\.html/' | xargs -I@ open build/@

.PHONY: setup
setup:
	@gem install asciidoctor ascidoctor-diagram
	@brew install fswatch websocketd rsync plantuml
