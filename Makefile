BIN = ./node_modules/.bin

#
# INSTALL
#
install: node_modules/

node_modules/: package.json
	echo "> Installing ..."
	npm --loglevel=error --ignore-scripts install > /dev/null
	touch $@

#
# CLEAN
#

clean:
	echo "> Cleaning ..."
	rm -rf build/

mrproper: clean
	echo "> Cleaning deep ..."
	rm -rf node_modules/

#
# BUILD
#

build: clean install
	echo "> Building ..."
	$(BIN)/babel --source-maps --out-dir build/ src/

build-watch: clean install
	echo "> Building forever ..."
	$(BIN)/babel --source-maps --out-dir build/ src/ --watch

#
# PUBLISH
#

_publish : NODE_ENV ?= production
_publish: build

publish-fix: _publish
	$(BIN)/release-it --increment patch

publish-feature: _publish
	$(BIN)/release-it --increment minor

publish-breaking: _publish
	$(BIN)/release-it --increment major

#
# MAKEFILE
#

.PHONY: \
	install \
	clean mrproper \
	build build-watch \
	publish-fix publish-feature publish-breaking

.SILENT:
