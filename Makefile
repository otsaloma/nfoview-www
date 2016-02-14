# -*- coding: us-ascii-unix -*-

VERSION = `date +%Y%m%d%H%M`

clean:
	rm -rf dist

dist:
	$(MAKE) clean
	mkdir dist
	cp --preserve *.html *.css *.png *.ico dist
	sed -ri "s|\?v=1\"|?v=$(VERSION)\"|g" dist/*.html
	$(if $(shell grep "?v=1" dist/*.html),$(error "v=1 remain!"))

push:
	$(MAKE) dist
	$(if $(shell git status --porcelain),\
	  $(error "Uncommited changes!"))
	@echo "Uploading..."
	aws s3 sync dist/ s3://otsaloma.io/nfoview/ \
	 --acl public-read \
	 --cache-control "public, max-age=86400"
	@echo "Listing remote files..."
	aws s3 ls s3://otsaloma.io/nfoview/

.PHONY: clean dist push
