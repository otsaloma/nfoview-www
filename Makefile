# -*- coding: utf-8-unix -*-

VERSION = `date +%Y%m%d%H%M`

clean:
	rm -rf dist

dist:
	$(MAKE) clean
	mkdir dist
	cp *.css *.html *.ico *.js *.png *.svg dist
	sed -ri "s|\?v=dev\"|?v=$(VERSION)\"|g" dist/*.html dist/*.js
	! grep "?v=dev" dist/*.html dist/*.js
	./bundle-assets.py dist/*.html

push:
	$(MAKE) dist
	$(if $(shell git status --porcelain),\
	  $(error "Uncommited changes!"))
	@echo "Uploading HTML files..."
	aws s3 sync dist/ s3://otsaloma.io/nfoview/ \
	--exclude "*" \
	--include "*.html" \
	--acl public-read \
	--cache-control "public, max-age=3600"
	@echo "Uploading everything else..."
	aws s3 sync dist/ s3://otsaloma.io/nfoview/ \
	--exclude "*.html" \
	--acl public-read \
	--cache-control "public, max-age=86400"

.PHONY: clean dist push
