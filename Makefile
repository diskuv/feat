# ------------------------------------------------------------------------------

# The name of the repository.
THIS     := feat

# The libraries topologically sorted
THIS_COMMAS := feat-core,feat,feat-num
THIS_SPACES := feat-core feat feat-num

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
	@ dune build @all

.PHONY: install
install:
	@ dune build -p $(THIS_COMMAS)
	@ dune install -p $(THIS_COMMAS)

.PHONY: clean
clean:
	@ rm -f *~ src/*~ dune-workspace.versions
	@ dune clean

.PHONY: test
test:
	@ dune runtest

.PHONY: uninstall
uninstall:
	@ for t in $(THIS_SPACES) ; do ocamlfind remove $$t; done || true

.PHONY: reinstall
reinstall: uninstall
	@ make install

.PHONY: show
show: reinstall
	@ echo "#require \"feat-core\";;\n#require \"feat\";;\n#require \"feat-num\";;\n#show FeatCore;;\n#show Feat;;\n#show FeatNum;;" | ocaml

.PHONY: pin
pin:
	@ for t in $(THIS_SPACES) ; do opam pin add $$t .; done

.PHONY: unpin
unpin:
	@ for t in $(THIS_SPACES) ; do opam pin remove $$t; done

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
	@ make uninstall
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
	@ for t in $(THIS_SPACES) ; do opam publish -v $(DATE) $$t $(ARCHIVE) .; done

DOCDIR = _build/default/_doc/_html
DOC    = $(DOCDIR)/index.html
CSS    = $(DOCDIR)/odoc.css

# ------------------------------------------------------------------------------

.PHONY: doc
doc:
	@ dune build @doc
	@ sed -i.bak 's/font-weight: 500;/font-weight: bold;/' $(CSS) && rm -f $(CSS).bak
	@ echo "You can view the documentation by typing 'make view'".

.PHONY: view
view: doc
	@ echo Attempting to open $(DOC)...
	@ if command -v firefox > /dev/null ; then \
	  firefox $(DOC) ; \
	else \
	  open -a /Applications/Firefox.app/ $(DOC) ; \
	fi

.PHONY: export
export: doc
	ssh yquem.inria.fr rm -rf public_html/$(THIS)/doc
	scp -r $(DOCDIR) yquem.inria.fr:public_html/$(THIS)/doc

# ------------------------------------------------------------------------------

# [make versions] compiles and tests under many versions of OCaml,
# whose list is specified below.

VERSIONS := \
  4.03.0 \
  4.04.2 \
  4.05.0 \
  4.06.1 \
  4.07.1 \
  4.08.1 \
  4.09.1 \
  4.09.0+bytecode-only \
  4.10.0 \
  4.11.1 \

.PHONY: switches
switches:
	@ for v in $(VERSIONS) ; do \
	    opam switch create $$v || \
	    opam install --switch $$v --yes zarith seq fix.20201120 num; \
	  done

.PHONY: versions
versions:
	@(echo "(lang dune 2.0)" && \
	  for v in $(VERSIONS) ; do \
	    echo "(context (opam (switch $$v)))" ; \
	  done) > dune-workspace.versions
	@ dune build --workspace dune-workspace.versions @install

.PHONY: handiwork
handiwork:
	@ current=`opam switch show` ; \
	  for v in $(VERSIONS) ; do \
	    opam switch $$v && \
	    eval $$(opam env --switch=$$v) && \
	    opam install --yes zarith seq fix.20201120 num; \
	  done ; \
	  opam switch $$current
