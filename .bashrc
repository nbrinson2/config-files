#Navigation
alias ls="ls -altr --color"
alias source="source ~/.bashrc"
alias work="cdls /c/workspace"
alias sb="cdls /c/workspace/sportsbiz/deepsportreact"
alias viba="vim ~/.bashrc"
alias ngservesb="node --max_old_space_size=8048 ./node_modules/@angular/cli/bin/ng serve"

#Functions
cdls() { cd "$@" && ls; }

assign_new_repo() {
	git init -b master
	git add . && git commit -m "initial commit"
	git remote add origin $1
	git remote -v
	echo "Does the URL match your new repo?"
	read -n 1 -p "Y or N: " userinput
	if [ "$userinput" = "Y" ]; then
		git push origin master
	elif [ "$userinput" = "N" ]; then
		echo "Deinitializing git"
		rm -fr .git
	else
		echo "You have entered an invalid selection!!!"
		echo "Please try again"
		echo "Deinitializing git"
		rm -fr .git
	fi
}

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
