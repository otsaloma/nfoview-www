# -*- coding: us-ascii-unix -*-

VERSION = `date +%Y%m%d%H%M`

clean:
	rm -rf dist

dist:
	$(MAKE) clean
	mkdir dist
	cp --preserve *.html *.js *.css *.png *.ico dist
	sed -ri "s|\?v=1\"|?v=$(VERSION)\"|g" dist/*.html dist/*.js
	$(if $(shell grep "?v=1" dist/*.html dist/*.js),$(error "v=1 remain!"))

# All non-HTML resources are loaded with a version parameter thus
# forcing browsers to fetch the resource again when a new version
# is deployed on the server.
push:
	$(MAKE) dist
	$(if $(shell git status --porcelain),\
	  $(error "Uncommited changes!"))
	@echo "Uploading HTML files..."
	aws s3 sync dist/ s3://otsaloma.io/nfoview/ \
	--exclude "*" \
	--include "*.html" \
	--acl public-read \
	--cache-control "public, max-age=300"
	@echo "Uploading everything else..."
	aws s3 sync dist/ s3://otsaloma.io/nfoview/ \
	--exclude "*.html" \
	--acl public-read \
	--cache-control "public, max-age=86400"
	@echo "Listing remote files..."
	aws s3 ls s3://otsaloma.io/nfoview/

.PHONY: clean dist push
