#Navigation
alias ls="ls -altr"
alias source="source ~/.bashrc"
alias work="cd /c/workspace"
alias sb="cd /c/workspace/sportsbiz/deepsportreact"
alias vimbashrc="vim ~/.bashrc"

#Other
function update-config-repo {
	cp ~/.bashrc /c/workspace/config-files/
	cp ~/.bash_profile /c/workspace/config-files/
	cp ~/.gitconfig /c/workspace/config-files/
	cp ~/.viminfo /c/workspace/config-files/
	cp ~/get-pip.py /c/workspace/config-files/

	cd /c/workspace/config-files

	git add .
	git commit -m "update config files"
}
