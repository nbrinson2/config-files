# General shell functions

# Test local host home page with bearer token
bear() {
    http :8080 "Authorization: Bearer ${1}"
}

# Change directory and list files
cdl() {
    cd "$@" && ls
}

coin() {
    python3 coin-investment-checker.py --sheet_url "https://docs.google.com/spreadsheets/d/15kEqOgq7k-_wNhcdcDzwmfQcEZmxglkSQa82lw5iMAA/edit?gid=0#gid=0"
}

# SSH into roster riddles EC2 instance
connrost() {
    cd ~/workspace/keys
    ssh -i "nbrinson802.pem" ubuntu@ec2-54-144-154-183.compute-1.amazonaws.com
}

count_lines() {
    local parent_directory="."
    local include_extensions=("ts" "html")
    local exclude_extensions=("spec*")
    local exclude_directories=("node_modules" "target")
    local result_count=50

    echo "Enter the path to the parent directory (default: $parent_directory):"
    read -r input
    if [ -n "$input" ]; then
        parent_directory=$input
    fi

    echo "Enter the file extensions to include (e.g., txt md, default: ${include_extensions[*]}):"
    read -r -a input
    if [ ${#input[@]} -ne 0 ]; then
        include_extensions=("${input[@]}")
    fi

    echo "Enter the file extensions to exclude (e.g., log bak, default: ${exclude_extensions[*]}):"
    read -r -a input
    if [ ${#input[@]} -ne 0 ]; then
        exclude_extensions=("${input[@]}")
    fi

    echo "Enter the directories to exclude (relative to the parent, e.g., dir1 dir2, default: ${exclude_directories[*]}):"
    read -r -a input
    if [ ${#input[@]} -ne 0 ]; then
        exclude_directories=("${input[@]}")
    fi

    echo "Enter the number of results to display (default: $result_count):"
    read -r input
    if [ -n "$input" ]; then
        result_count=$input
    fi

    local find_cmd="find $parent_directory -type d \\( "

    for i in "${!exclude_directories[@]}"; do
        find_cmd+="-name '${exclude_directories[i]}'"
        if [[ $i -ne $((${#exclude_directories[@]} - 1)) ]]; then
            find_cmd+=" -o "
        fi
    done
    find_cmd+=" \\) -prune"

    find_cmd+=" -o -type f \\( \\( "
    for i in "${!include_extensions[@]}"; do
        find_cmd+="-name \"*.${include_extensions[i]}\""
        if [[ $i -ne $((${#include_extensions[@]} - 1)) ]]; then
            find_cmd+=" -o "
        fi
    done
    find_cmd+=" \\) "

    for ext in "${exclude_extensions[@]}"; do
        find_cmd+="-and ! -name \"*.$ext\" "
    done
    find_cmd+=" \\)"

    find_cmd+=" -exec wc -l {} + | sort -nr | head -n $result_count"
    echo "Running command: $find_cmd"

    local results
    results=$(eval "$find_cmd")

    echo "Top $result_count files (by line count):"
    echo "$results"
}

fin() {
    local pattern="$1"
    shift
    local includes=("$@")
    local cmd="find . -type f"

    if [ ${#includes[@]} -eq 0 ]; then
        cmd="$cmd \( -name '*.ts' -o -name '*.html' \)"
    else
        cmd="$cmd \( -false"
        for include in "${includes[@]}"; do
            cmd="$cmd -o -name '$include'"
        done
        cmd="$cmd \)"
    fi

    cmd="$cmd -exec grep -H '$pattern' {} +"
    eval "$cmd"
}

# Generate public and private pem keys
genkey() {
    openssl genrsa -out keypair.pem 2048
    openssl rsa -in keypair.pem -pubout -out public.pem
    openssl pkcs8 -topk8 -inform PEM -outform PEM -nocrypt -in keypair.pem -out private.pem
    rm keypair.pem
}

# Move file to Google Drive Receipt folder
gmove() {
    cp ~/Downloads/"${1}"
}

# Search all directories recursively and return number of occurrences
grpcnt() {
    grep -Rc "$1" "$PWD" | awk -F: '{ sum += $2 } END { print sum }'
}

# Search all directories recursively for files containing multiple strings
grpi() {
    local patterns=()
    local includes=()
    local use_defaults=false
    local exact_match=false

    while [[ "$1" != "" ]]; do
        case $1 in
        -*)
            for ((i = 1; i < ${#1}; i++)); do
                flag="${1:i:1}"
                case $flag in
                d)
                    use_defaults=true
                    ;;
                e)
                    exact_match=true
                    ;;
                p)
                    shift
                    patterns+=("$1")
                    break
                    ;;
                *)
                    echo "Error: Unknown flag -$flag"
                    return 1
                    ;;
                esac
            done
            ;;
        --default)
            use_defaults=true
            ;;
        --pattern)
            shift
            patterns+=("$1")
            ;;
        --exact)
            exact_match=true
            ;;
        --include=*)
            includes+=("${1#*=}")
            ;;
        *)
            if [ ${#patterns[@]} -eq 0 ]; then
                patterns+=("$1")
            else
                includes+=("$1")
            fi
            ;;
        esac
        shift
    done

    if [ ${#patterns[@]} -eq 0 ]; then
        echo "Error: No search pattern provided."
        return 1
    fi

    local cmd="grep -Rl"

    if [ "$exact_match" = true ]; then
        cmd="$cmd -w"
    fi

    cmd="$cmd '${patterns[0]}'"

    for include in "${includes[@]}"; do
        cmd="$cmd --include='$include'"
    done

    if [ "$use_defaults" = true ]; then
        cmd="$cmd --include='*.ts' --include='*.html'"
    fi

    for ((i = 1; i < ${#patterns[@]}; i++)); do
        cmd="$cmd . | xargs grep -l"
        if [ "$exact_match" = true ]; then
            cmd="$cmd -w"
        fi
        cmd="$cmd '${patterns[i]}'"
    done

    eval "$cmd"
}

# Search all directories recursively
grpr() {
    grep -R "$1" "$PWD"
}

# Replace all occurrences of string in every file
grpreplace() {
    if [ "$#" -ne 2 ]; then
        echo "Usage: grpreplace pattern replacement"
        return 1
    fi

    local files
    files=$(grep -Rl "$1" "$PWD")

    for file in $files; do
        sed -i "s/$1/$2/g" "$file"
    done
}

# Search 2 strings in all directories recursively
grpt() {
    grep -R "${1}.*${2}\|${2}.*${1}" "$PWD"
}

grpw() {
    grep -R "$1" $(echo "$()")
}

# Search all directories recursively and exclude given file types and directories
grpx() {
    local pattern=""
    local excludes=()
    local use_defaults=false

    while [[ "$1" != "" ]]; do
        case $1 in
        -d | --default)
            use_defaults=true
            ;;
        *)
            if [ -z "$pattern" ]; then
                pattern="$1"
            else
                excludes+=("$1")
            fi
            ;;
        esac
        shift
    done

    local cmd="grep -Rn '$pattern'"

    for exclude in "${excludes[@]}"; do
        cmd="$cmd --exclude='$exclude' --exclude-dir='$exclude'"
    done

    if [ "$use_defaults" = true ]; then
        cmd="$cmd --exclude-dir='target' --exclude-dir='node_modules'"
    fi

    eval "$cmd ."
}

# Search history for string
hgrep() {
    history | grep "$1"
}

# Display info about bash command
info() {
    curl https://cheat.sh/"${1}"
}

# Display the top 10 most frequently used commands from history
most() {
    history | awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl | head -n10
}

# Unmount and mount developer HDD under plex user
plexmount() {
    umount /media/nbrinson2/all_backups
    sudo mount -o gid=999,uid=999 /dev/sdc1 /media/plex/developer
}

# Create a shell script and add execute functionality
tx() {
    local filename="$1"

    touch "$filename"

    if [[ "$filename" == *.sh ]]; then
        chmod +x "$filename"
    fi
}

# Pull config-files repo and restore local shell config
update_config_local() {
    local src=~/workspace/config-files
    local linux="$src/linux"

    cd "$src" || return
    git pull

    cp "$linux/.bashrc_linux" ~/.bashrc
    if [ -d "$linux/bashrc.d_linux" ]; then
        rm -rf ~/.bashrc.d
        cp -a "$linux/bashrc.d_linux" ~/.bashrc.d
    fi
    [ -f "$linux/.bash_profile_linux" ] && cp "$linux/.bash_profile_linux" ~/.bash_profile
    [ -f "$linux/.inputrc_linux" ] && cp "$linux/.inputrc_linux" ~/.inputrc
    [ -f "$src/.gitconfig" ] && cp "$src/.gitconfig" ~/

    src
}

# Sync local shell config into the config-files git repo
update_config_repo() {
    local dest=~/workspace/config-files
    local linux="$dest/linux"

    mkdir -p "$linux"
    cp ~/.bashrc "$linux/.bashrc_linux"
    cp -a ~/.bashrc.d/ "$linux/bashrc.d_linux"
    [ -f ~/.bash_profile ] && cp ~/.bash_profile "$linux/.bash_profile_linux"
    [ -f ~/.inputrc ] && cp ~/.inputrc "$linux/.inputrc_linux"
    [ -f ~/.gitconfig ] && cp ~/.gitconfig "$dest/"

    cd "$dest" || return

    git add .
    git commit -m "update config files"
    git push
}
