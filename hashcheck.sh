#!/bin/bash

# Check if correct number of arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <file_path> <expected_hash>"
    exit 1
fi

file_path=$1
expected_hash=$2

# Function to calculate the hash of the file
calculate_hash() {
    local hash_type
    local actual_hash

    # Determine the hash type based on the length of the expected hash value
    case ${#expected_hash} in
        32)
            hash_type="md5"
            ;;
        40)
            hash_type="sha1"
            ;;
        64)
            hash_type="sha256"
            ;;
        128)
            hash_type="sha512"
            ;;
        *)
            echo "Unsupported hash type. Please provide the expected hash value."
            exit 1
            ;;
    esac

    # Calculate the actual hash of the file
    actual_hash=$(openssl dgst -"$hash_type" -hex "$file_path" | awk '{print $NF}')

    # Compare the actual and expected hashes
    if [ "$actual_hash" = "$expected_hash" ]; then
        echo "$hash_type checksum is correct."
    else
        echo "$hash_type checksum is incorrect."
    fi
}

calculate_hash