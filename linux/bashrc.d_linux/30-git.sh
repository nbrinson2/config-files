# Git aliases and helpers

alias gitb='git branch -a --sort=-committerdate'
alias gitba='git branch -a -v --sort=-committerdate'
alias stat='git status'

# Git add / commit / push
acp() {
    git add .
    git commit -m "$1"
    git push
}

# Initialize a new git repo locally and push it to remote
assign_new_repo() {
    git init -b master
    git add . && git commit -m "initial commit"
    git remote add origin "$1"
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

# Git checkout to branch
check() {
    git checkout "$1"
}

chkmain() {
    if git show-ref --verify --quiet refs/heads/main; then
        git checkout main
        echo "Checked out to 'main' branch."
    elif git show-ref --verify --quiet refs/heads/master; then
        git checkout master
        echo "Checked out to 'master' branch."
    else
        echo "Neither 'main' nor 'master' branch exists in this repository."
    fi
}

delbranch() {
    local branch
    branch=$(git rev-parse --abbrev-ref HEAD)

    if [[ "$branch" == "main" || "$branch" == "master" ]]; then
        echo "Refusing to delete the protected branch '$branch'."
        return 1
    fi

    if git show-ref --verify --quiet refs/heads/main; then
        git checkout main
    elif git show-ref --verify --quiet refs/heads/master; then
        git checkout master
    else
        echo "Neither 'main' nor 'master' branch found. Cannot switch away from '$branch'."
        return 1
    fi

    git branch -D "$branch"
    git push origin --delete "$branch"
    echo "Branch '$branch' deleted locally and remotely."
}

newbranch() {
    if [ -z "$1" ]; then
        echo "Please provide a branch name."
        return 1
    fi

    git checkout -b "$1"
    git push -u origin "$1"
    echo "New branch '$1' created and pushed to the remote repository. Tracking set up."
}

newrepo() {
    local repo_name

    if [ -z "$1" ]; then
        # No args: turn the current folder into a repo
        repo_name="$(basename "$PWD")"
    else
        repo_name="$1"
        mkdir "$repo_name"
        cd "$repo_name" || return
    fi

    touch README.md
    git init
    hub create
    git add README.md
    git commit -m "first commit"
    git remote add origin "git@github.com:nbrinson2/${repo_name}.git"

    if [ $? -eq 0 ]; then
        git push -u origin master
    else
        echo "Failed to add remote repository."
        return 1
    fi
}

parse_git_branch() {
    git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
