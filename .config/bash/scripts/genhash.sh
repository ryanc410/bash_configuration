#!/usr/bin/env bash
# gen-hash.sh

read -rsp "Enter the Password you want to HASH: " PASS1
echo
read -rsp "Confirm Password: " PASS2
echo
if [[ "$PASS1"  != "$PASS2" ]]; then
	echo "Passwords do not match."
	exit 1
fi

HASH=$(php -r 'echo password_hash($argv[1], PASSWORD_DEFAULT);' "$PASS1")

echo
echo "Generated Password HASH:"
echo "$HASH"
