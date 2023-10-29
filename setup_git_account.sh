#!/bin/bash

# Function to generate SSH key and add it to ssh-agent
generate_and_add_key() {
    local email="$1"
    local key_path="$2"

    ssh-keygen -t rsa -C "$email" -f "$key_path"
    ssh-add "$key_path"
}

# Function to display SSH key, prompt the user to add it to Git host
display_key_and_wait() {
    local key_path="$1"
    
    echo "---------------------------------------------"
    echo "Please add the following SSH public key to your Git account:"
    cat "${key_path}.pub"
    echo "---------------------------------------------"
    read -p "Press [Enter] once you've added the key..."
}

# Main script execution

# Start the SSH agent
eval "$(ssh-agent -s)"

# For the personal account
generate_and_add_key nickbrinson3@gmail.com ~/.ssh/id_rsa_personal
display_key_and_wait ~/.ssh/id_rsa_personal

# Set up the SSH config
cat > ~/.ssh/config <<EOL
# Personal account
Host github.com-personal
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_rsa_personal

EOL

echo "SSH configuration for nickbrinson3@gmail.com has been set up!"

