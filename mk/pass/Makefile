SHELL := /bin/bash

include .env

PASSWORD_STORE_DIR ?= $$HOME/.password-store
PUBLIC_KEY  = pub.key
PRIVATE_KEY = priv.key

all: help

help:
	@echo -e 'Required:\n\tpass git-pass-helper pinentry-gtk passff-host\n'
	@echo -e 'Usage:\n\ton local:  make setup\n\ton remote: make [install|uninstall]'

setup: send-to-remote

send-to-remote: $(PUBLIC_KEY) $(PRIVATE_KEY)
	@#scp $^ $(REMOTE_HOST):.
	cd .. && scp -P $(REMOTE_PORT) -r pass $(REMOTE_HOST):.

$(PUBLIC_KEY):
	gpg --export '$(PASS_KEY)' >$@

$(PRIVATE_KEY):
	gpg --export-secret-keys '$(PASS_KEY)' >$@

install: import-secret-key set-pass-dir-env get-pass-db configure-git-helper

import-secret-key:
	gpg --list-secret-keys '$(PASS_KEY)' &>/dev/null || gpg --import $(PRIVATE_KEY)

set-pass-dir-env:
	if [[ ! "$(PASSWORD_STORE_DIR)" =~ '.password-store' ]]; then \
		sed -i '2s#^#export PASSWORD_STORE_DIR=$(PASSWORD_STORE_DIR)\n#' ~/.bash_profile; \
		echo -e 'export PASSWORD_STORE_DIR=$(PASSWORD_STORE_DIR)\n' >>~/.xprofile; \
	fi

get-pass-db: $(PASSWORD_STORE_DIR)

configure-git-helper:
	git config --global credential.helper '!pass-git-helper $$@'
	mkdir -p ~/.config/pass-git-helper
	echo -e '[DEFAULT]\nusername_extractor=regex_search\nregex_username=^login: (.*)$$\n' \
		>~/.config/pass-git-helper/git-pass-mapping.ini

$(PASSWORD_STORE_DIR):
	git clone https://$(GIT_USER):$(GIT_PASSWD)@$(GIT_URL) $@ \
		&& chmod -R u=rwX,g=,o= $@ \
		&& cd $@ \
		&& git remote set-url origin https://$(GIT_URL)

uninstall:
	rm -rf $(PASSWORD_STORE_DIR)
	rm -rf ~/.config/pass-git-helper
	sed -i '/export PASSWORD_STORE_DIR/d' ~/.bash_profile
	sed -i '/export PASSWORD_STORE_DIR/d' ~/.xprofile
	gpg --list-secret-keys '$(PASS_KEY)' &>/dev/null \
		&& gpg --yes --delete-secret-key '$(PASS_KEY)'
	git config --global --unset credential.helper

clean:
	rm -f $(PUBLIC_KEY) $(PRIVATE_KEY)

.PHONY: clean distclean local send-to-remote remote import-secret-key set-pass-dir-env set-git-helper


