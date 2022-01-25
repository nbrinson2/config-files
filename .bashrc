#Navigation
alias ls="ls -altr --color"
alias source="source ~/.bashrc"
alias work="cd /c/workspace"
alias sb="cd /c/workspace/sportsbiz/deepsportreact"
alias vimbashrc="vim ~/.bashrc"
alias ngservesb="node --max_old_space_size=8048 ./node_modules/@angular/cli/bin/ng serve"

#Other
update_config_repo() {
	cp ~/.bashrc /c/workspace/config-files/
	cp ~/.bash_profile /c/workspace/config-files/
	cp ~/.gitconfig /c/workspace/config-files/
	cp ~/.viminfo /c/workspace/config-files/
	cp ~/get-pip.py /c/workspace/config-files/

	cd /c/workspace/config-files

	git add .
	git commit -m "update config files"
	git push
}

restart_ex() {
	TASKKILL //F //IM explorer.exe
	start explorer.exe
}
