# Secure-eBPF-depoyment-example
This repository provides a simple working example of our proposed framwork

## Dependencies
To run the example, make sure you have the following installed
1. clang: compile the eBPF program 
2. bpftool: load and attach eBPF program
3. python3: run scripts
4. openssl: Sign and verify the binary  

## Generating key pair
openssl genrsa -out key.pem 4096
openssl rsa -in key.pem -pubout -out pubkey.pem

## Compiling
details is provided in the Makefile just run:
make

## Clean
to clean up tools run:
make clean

## For verification 

chmod +x verify_and_load.sh
./verify_and_load.sh

The script performs the following steps
1. veriies the eBPF signature using OpenSSL
2. verifies the integrity of both program and manifest via a stored SHa-256 hash
3. checks for proof of inclusion (this is shown as proof.text for this example, integration with real logs like Rekor is left for future work.)
4. loads and auto attach the program using bpftool