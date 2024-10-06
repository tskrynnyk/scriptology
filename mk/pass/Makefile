SHELL := /bin/bash

include .env

PASSWORD_STORE_DIR ?= $$HOME/.password-store
PRIVATE_KEY = pass.pk

all: help

help:
	@echo -e 'Usage:\n\ton local: make local\n\ton remote: make remote'

local: $(PRIVATE_KEY) send-to-remote

send-to-remote:
	@#scp $^ $(REMOTE_HOST):.
	cd .. && scp -r pass $(REMOTE_HOST):.

$(PRIVATE_KEY):
	gpg --export-secret-keys '$(PASS_KEY)' >$@

remote: import-secret-key set-pass-dir-env $(PASSWORD_STORE_DIR) set-git-helper

import-secret-key:
	gpg --list-secret-keys '$(PASS_KEY)' &>/dev/null || gpg --import $(PRIVATE_KEY)

set-pass-dir-env:
	[[ "$(PASSWORD_STORE_DIR)" =~ '.password-store' ]] \
		|| sed -i '2s#^#export PASSWORD_STORE_DIR=$(PASSWORD_STORE_DIR)\n#' ~/.bash_profile

$(PASSWORD_STORE_DIR):
	git clone https://$(GIT_USER):$(GIT_PASSWD)@$(GIT_URL) $@ \
		&& chmod -R u=rwX,g=,o= $@ \
		&& cd $@ \
		&& git remote set-url origin https://$(GIT_URL)

set-git-helper:
	git config --global credential.helper '!pass-git-helper $$@'
	mkdir -p ~/.config/pass-git-helper
	echo -e '[DEFAULT]\nusername_extractor=regex_search\nregex_username=^login: (.*)$$\n' \
		>~/.config/pass-git-helper/git-pass-mapping.ini

clean:
	rm -f $(PRIVATE_KEY)

distclean:
	rm -rf $(PASSWORD_STORE_DIR)
	rm -rf ~/.config/pass-git-helper
	sed -i '/export PASSWORD_STORE_DIR/d' ~/.bash_profile
	gpg --yes --delete-secret-key '$(PASS_KEY)'
	git config --global --unset credential.helper

.PHONY: clean distclean local send-to-remote remote import-secret-key set-pass-dir-env set-git-helper


