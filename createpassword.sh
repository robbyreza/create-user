#!/bin/bash

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root or with sudo."
  exit 1
fi

# Check if the file containing usernames is provided as an argument
if [ "$#" -eq 0 ]; then
  echo "Usage: $0 <usernames_file>"
  exit 1
fi

usernames_file="$1"

# Check if the file exists
if [ ! -f "$usernames_file" ]; then
  echo "Error: File $usernames_file not found."
  exit 1
fi

# Read each username from the file and create the user with password "blabla"
while IFS= read -r username; do
  # Check if the user already exists
  if id "$username" &>/dev/null; then
    echo "User '$username' already exists. Skipping."
  else
    # Create user and set password
    useradd -m -s /bin/bash "$username"
    echo "$username:blabla" | chpasswd

    # Print a message indicating user creation
    echo "User '$username' created with password 'blabla'."
  fi
done < "$usernames_file"

echo "User creation completed."
