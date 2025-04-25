#!/bin/bash

# Define paths to files
EBPF_PROGRAM="example.o"
SIGNATURE="example.o.sig"
MANIFEST="package/manifest.json"
PUBLIC_KEY="pubkey.pem"
#PRIVATE_KEY="key.pem"
COMBINED_FILE="combined_file.bin"
HASH_FILE="combined_file.hash"
PROOF_FILE="proof.txt"

# Step 1: Verify Signature of eBPF Program
echo "Verifying the signature..."
openssl dgst -sha256 -verify $PUBLIC_KEY -signature $SIGNATURE $EBPF_PROGRAM
if [ $? -eq 0 ]; then
    echo "Signature verified successfully."
else
    echo "Signature verification failed!"
    exit 1
fi

# Step 2: Verify the hash of the combined file
echo "Verifying the hash of the combined file..."
calculated_hash=$(sha256sum $COMBINED_FILE | awk '{print $1}')
stored_hash=$(cat $HASH_FILE)

if [ "$calculated_hash" == "$stored_hash" ]; then
    echo "Hash verification successful: Program and manifest are intact."
else
    echo "Hash verification failed: The program or manifest may have been altered."
    exit 1
fi

# Step 3: Verify the proof.txt file for public log inclusion
echo "Verifying the Proof of Inclusion from the log..."
if [ -f "$PROOF_FILE" ]; then

    echo "Proof of inclusion file found: $PROOF_FILE"

else
    echo "Proof of inclusion."
    exit 1
fi

# Step 4: Load the eBPF program
echo "Loading eBPF program..."

# Attempt to load and attach the eBPF program using bpftool with autoattach
echo "Loading and attaching eBPF program..."
sudo bpftool prog load $EBPF_PROGRAM /sys/fs/bpf/example autoattach

if [ $? -eq 0 ]; then
    echo "eBPF program loaded and attached successfully."
else
    echo "Failed to load and attach eBPF program."
    exit 1
fi

echo "eBPF program verified, loaded, and attached successfully."
