# -*- coding: utf-8-unix -*-

VERSION = `date +%s`

clean:
	rm -rf dist

deploy:
	$(MAKE) dist
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

dist:
	$(MAKE) clean
	mkdir dist
	cp *.css *.html *.jpg *.png *.svg dist
	sed -ri "s|\?v=dev\"|?v=$(VERSION)\"|g" dist/*.html
	! grep "?v=dev" dist/*.html
	./bundle-assets.py dist/*.html
	rm dist/*.css

.PHONY: clean deploy dist
