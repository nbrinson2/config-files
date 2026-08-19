# Environment variables and PATH helpers

export EDITOR=vim
export TZ="America/New_York"

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/home/nbrinson2/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
export PATH="$PATH:/opt/heroku/bin"
export PATH="$PATH:/opt/sonar-scanner/bin"

removeFromPath() {
    export PATH=$(echo "$PATH" | sed -E -e "s;:$1;;" -e "s;$1:?;;")
}

# Enhanced setjdk for Linux
# Supports: java17, java21, zulu21, zulu17, 17, 21, and exact folder names
setjdk() {
    if [ $# -ne 1 ]; then
        echo "Usage: setjdk <version>"
        echo "Examples:"
        echo "  setjdk 21       → uses java-21-openjdk-amd64 or zulu-21-amd64"
        echo "  setjdk java21   → same"
        echo "  setjdk zulu21   → prefers zulu-21-amd64"
        echo "  setjdk 17       → uses java-17-openjdk-amd64 or zulu-17-amd64"
        echo "  setjdk zulu-21-amd64  → exact folder name"
        echo ""
        echo "Available JDKs in /usr/lib/jvm:"
        ls -1 /usr/lib/jvm | grep -E '^(java|openjdk|zulu|temurin|jdk|jdk-)[0-9]+' | sort
        return 1
    fi

    local input="$1"
    local candidate=""
    local version=""
    local prefer=""

    case "$input" in
        java17|jdk17|17) version="17" ;;
        java21|jdk21|21) version="21" ;;
        zulu17)          version="17"; prefer="zulu" ;;
        zulu21)          version="21"; prefer="zulu" ;;
        *)               version="$input" ;;
    esac

    if [[ -d "/usr/lib/jvm/$input" && -x "/usr/lib/jvm/$input/bin/java" ]]; then
        candidate="/usr/lib/jvm/$input"
    else
        if [[ -n "$prefer" && "$prefer" == "zulu" ]]; then
            if [[ -d "/usr/lib/jvm/zulu-${version}-amd64" ]]; then
                candidate="/usr/lib/jvm/zulu-${version}-amd64"
            elif [[ -d "/usr/lib/jvm/zulu${version}-amd64" ]]; then
                candidate="/usr/lib/jvm/zulu${version}-amd64"
            fi
        fi

        if [[ -z "$candidate" ]]; then
            if [[ -d "/usr/lib/jvm/java-${version}-openjdk-amd64" ]]; then
                candidate="/usr/lib/jvm/java-${version}-openjdk-amd64"
            elif [[ -d "/usr/lib/jvm/openjdk-${version}" ]]; then
                candidate="/usr/lib/jvm/openjdk-${version}"
            elif [[ -d "/usr/lib/jvm/java-${version}.0-openjdk-amd64" ]]; then
                candidate="/usr/lib/jvm/java-${version}.0-openjdk-amd64"
            fi
        fi

        if [[ -z "$candidate" ]]; then
            candidate=$(find /usr/lib/jvm -maxdepth 1 -type d -name "*${version}*" -print | head -n 1)
            if [[ -n "$candidate" && ! -x "$candidate/bin/java" ]]; then
                candidate=""
            fi
        fi
    fi

    if [[ -z "$candidate" || ! -x "$candidate/bin/java" ]]; then
        echo "Error: No valid JDK found for '$input'"
        echo "Try one of these:"
        ls -1 /usr/lib/jvm | grep -E 'jdk|java|zulu|openjdk' | grep -E "${version:-[0-9]+}"
        return 1
    fi

    if [ -n "${JAVA_HOME+x}" ] && [ -d "$JAVA_HOME" ] && [[ "$PATH" == *"$JAVA_HOME"* ]]; then
        export PATH=$(echo "$PATH" | tr ':' '\n' | grep -v "^${JAVA_HOME}/bin$" | tr '\n' ':' | sed 's/:$//')
    fi

    export JAVA_HOME="$candidate"
    export PATH="$JAVA_HOME/bin:$PATH"

    echo "Switched to: $JAVA_HOME"
    java -version | head -n 2
}
