# ------------------------------------------------------------------------------

# The name of the library.
THIS     := feat

# The version number is automatically set to the current date,
# unless DATE is defined on the command line.
DATE     := $(shell /bin/date +%Y%m%d)

# The repository URL (https).
REPO     := https://gitlab.inria.fr/fpottier/$(THIS)

# The archive URL (https).
ARCHIVE  := $(REPO)/repository/$(DATE)/archive.tar.gz

# ------------------------------------------------------------------------------

.PHONY: all
all:
	dune build -p $(THIS)

.PHONY: install
install: all
	dune install -p $(THIS)

.PHONY: clean
clean:
	rm -f *~ src/*~
	dune clean

.PHONY: uninstall
uninstall:
	ocamlfind remove $(THIS) || true

.PHONY: reinstall
reinstall: uninstall
	@ make install

.PHONY: show
show: reinstall
	@ echo "#require \"feat\";;\n#show Feat;;" | ocaml

.PHONY: pin
pin:
	opam pin add $(THIS) .

.PHONY: unpin
unpin:
	opam pin remove $(THIS)

# This requires a version of headache that supports UTF-8; please use
# https://github.com/fpottier/headache

HEADACHE := headache
LIBHEAD  := $(shell pwd)/headers/library-header
FIND     := $(shell if command -v gfind >/dev/null ; then echo gfind ; else echo find ; fi)

.PHONY: headache
headache:
	@ $(FIND) src -regex ".*\.ml\(i\|y\|l\)?" \
	    -exec $(HEADACHE) -h $(LIBHEAD) "{}" ";"

.PHONY: release
release:
# Make sure the current version can be compiled and installed.
	@ make uninstall
	@ make clean
	@ make install
# Check the current package description.
	@ opam lint
# Check if everything has been committed.
	@ if [ -n "$$(git status --porcelain)" ] ; then \
	    echo "Error: there remain uncommitted changes." ; \
	    git status ; \
	    exit 1 ; \
	  else \
	    echo "Now making a release..." ; \
	  fi
# Create a git tag.
	@ git tag -a $(DATE) -m "Release $(DATE)."
# Upload. (This automatically makes a .tar.gz archive available on gitlab.)
	@ git push
	@ git push --tags

.PHONY: publish
publish:
# Publish an opam description.
	@ opam publish -v $(DATE) $(THIS) $(ARCHIVE) .
