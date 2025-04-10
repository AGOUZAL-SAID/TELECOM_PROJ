
# #Magic variables
# out.o: src.c src.h
#   $@   # "out.o" (target)
#   $<   # "src.c" (first prerequisite)
#   $^   # "src.c src.h" (all prerequisites)
# %.o: %.c
#   $*   # the 'stem' with which an implicit rule matches ("foo" in "foo.c")

# E-campus link points to https://c2s.telecom-paristech.fr/TELECOM201/documents/projet/TELECOM205_CRAN_scripts.zip

archiveName   = TELECOM205_CRAN_scripts

# https://stackoverflow.com/questions/26694249/makefiles-using-wildcard-vs-find-for-specifying-source-files
scriptFiles   = $(shell find . -type f | grep -v ".git" | grep -v "libiio/" | grep -v "\.solutions")

archive: $(archiveName).zip

updatewebTELECOM205: $(archiveName).zip
	@# https://stackoverflow.com/questions/3743793/makefile-why-is-the-read-command-not-reading-the-user-input
	@# https://stackoverflow.com/a/3743821
	@# attention, ne pas utiliser $$(usrname) à l'appel mais bien $$usrname. sinon bug
	@read -p "Entrer username pour connection serveur: " usrname ; \
	echo "Connexion à ares puis LXC C2S avec $$usrname" ; \
	scp -o ProxyJump=$$usrname@ares.enst.fr $< $$usrname@c2s.lxc.enst.fr:/srv/www/TELECOM201/documents/projet/

$(archiveName).zip: $(scriptFiles)
	@# https://askubuntu.com/questions/28476/how-do-i-zip-up-a-folder-but-exclude-the-git-subfolder
	zip -r $@ . -x '*.git*' -x '*libiio-*' -x '*libiio/*' -x '*.solutions*' -x '*$(archiveName).zip' -x '*Makefile*'
