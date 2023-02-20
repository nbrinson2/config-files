#Constants
ENV_PATH="/c/workspace/env"
SCRIPTS_PATH="/Scripts/activate"
DELIM='.'

#Navigation
alias ls="ls -altr --color"
alias source="source ~/.bashrc"
alias work="cdls /c/workspace"
alias sbb="cdls /c/workspace/sportsbiz/deepsportv2/"
alias sbf="cdls /c/workspace/sportsbiz/deepsportv2/src/main/frontend"
alias ngservesb="node --max_old_space_size=8048 ./node_modules/@angular/cli/bin/ng serve"
alias crypto="cdls /c/workspace/crypto-noobs-v2/crypto-noobs-v2"
alias viba="vim ~/.bashrc"
alias ngservesb="node --max_old_space_size=8048 ./node_modules/@angular/cli/bin/ng serve"
alias pixel="flutter emulators --launch Pixel_2_XL_API_29"
alias chrome="start chrome"
alias nplus="/c/Program\ Files\ \(x86\)/Notepad++/notepad++.exe"
alias histg="history | grep"
alias rmd="rm -drf"
alias fhere="find . -name"
alias ..="cd .."
alias .2="cd ../../"
alias .3="cd ../../../"
alias .4="cd ../../../../"
alias .5="cd ../../../../../"
alias cpbash="cp .bashrc ~/"

# Pipe ls command to view large directories
alias lsl="ls -lrt | less"

# Sort by file size
alias lf="ls --human-readable --size -1 -S --classify"

# Number of files in directory
alias count="find . -type f | wc -l"

# Copy with progress bar
alias cpv="rsync -ah --info=progress2"

# Show storage allocation
alias df="df -Tha --total"

# Memory allocation
alias du="du -ach | sort -h"

# Search processes for argument that is passed
alias psg="ps aux | grep -v grep | grep -i -e VSZ -e"

# Create and list any necessary parent directories
alias mkdir="mkdir -pv"

# Continue download in case of issues
alias wget="wget -c"


#Functions
ssh_nbrinson8() {
	work
	cd keys/
	ssh -i "nbrinson8.pem" ubuntu@ec2-3-231-27-20.compute-1.amazonaws.com
}

split() {
	IFS='.' read -ra my_array <<< "$1"
	return "${my_array[0]}"
}

javab() {
	javac "$1"
	
	IFS='.' read -ra my_array <<< "$1"
	java "${my_array[0]}"
}

act() {
	. "${ENV_PATH}$1${SCRIPTS_PATH}"
}

virt() {
	python -m venv "$1"
}

grpr() {
	grep -R "$1" $PWD
}

react() {
	npx create-react-app $1
}

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

	cd /c/workspace/config-files

	git add .
	git commit -m "update config files"
	git push
}

update_config_local() {
	cp /c/workspace/config-files/.bashrc ~/
	cp /c/workspace/config-files/.bash_profile ~/
	cp /c/workspace/config-files/.gitconfig ~/

	source
}

restart_ex() {
	TASKKILL //F //IM explorer.exe
	start explorer.exe
}

gitacp () {
	git add .
	git commit -m "$1"
	git push
}

most () {
history | awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl |  head -n10
		
}

trash () {
	if [ -d "~/TrashCan" ] 
	then
		mv --force -t ~/TrashCan $1
	else
		mkdir ~/TrashCan
		mv --force -t ~/TrashCan $1
	fi
}


mcd () {
	mkdir -p $1
	cd $1
}

extract() {
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
    return 1
 else
    for n in $@
    do
      if [ -f "$n" ] ; then
          case "${n%,}" in
            *.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar) 
                         tar xvf "$n"       ;;
            *.lzma)      unlzma ./"$n"      ;;
            *.bz2)       bunzip2 ./"$n"     ;;
            *.rar)       unrar x -ad ./"$n" ;;
            *.gz)        gunzip ./"$n"      ;;
            *.zip)       unzip ./"$n"       ;;
            *.z)         uncompress ./"$n"  ;;
            *.7z|*.arj|*.cab|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.rpm|*.udf|*.wim|*.xar)
                         7z x ./"$n"        ;;
            *.xz)        unxz ./"$n"        ;;
            *.exe)       cabextract ./"$n"  ;;
            *)
                         echo "extract: '$n' - unknown archive method"
                         return 1
                         ;;
          esac
      else
          echo "'$n' - file does not exist"
          return 1
      fi
    done
fi
}

BOOBS() {
	echo "BOOBS"
}
