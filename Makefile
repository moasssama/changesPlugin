SCRIPT=autoload/changes.vim plugin/changesPlugin.vim
DOC=doc/ChangesPlugin.txt
PLUGIN=changes

.PHONY: $(PLUGIN).vba

all: uninstall vimball install README

vimball: $(PLUGIN).vba

clean:
	rm -f *.vba */*.orig *.~* .VimballRecord

dist-clean: clean

install:
	vim -N -c':so %' -c':q!' ${PLUGIN}.vba

uninstall:
	vim -N -c':RmVimball' -c':q!' ${PLUGIN}.vba

undo:
	for i in */*.orig; do mv -f "$$i" "$${i%.*}"; done

README:
	cp -f $(DOC) README

changes.vba:
	rm -f $(PLUGIN).vba
	vim -N -c 'ru! vimballPlugin.vim' -c ':call append("0", ["autoload/changes.vim", "doc/ChangesPlugin.txt", "plugin/changesPlugin.vim"])' -c '$$d' -c ':%MkVimball ${PLUGIN} .' -c':q!'
     
release:
	perl -i.orig -pne 'if (/Version:/) {s/\.(\d)*/sprintf(".%d", 1+$$1)/e}' ${SCRIPT}
	perl -i -pne 'if (/GetLatestVimScripts:/) {s/(\d+)\s+:AutoInstall:/sprintf("%d :AutoInstall:", 1+$$1)/e}' ${SCRIPT}
	#perl -i -pne 'if (/Last Change:/) {s/\d+\.\d+\.\d\+$$/sprintf("%s", `date -R`)/e}' ${SCRIPT}
	perl -i -pne 'if (/Last Change:/) {s/(:\s+).*$$/sprintf(": %s", `date -R`)/e}' ${SCRIPT}
	perl -i.orig -pne 'if (/Version:/) {s/\.(\d)+.*\n/sprintf(".%d %s", 1+$$1, `date -R`)/e}' ${DOC}