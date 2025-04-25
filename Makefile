# BPF_CLANG=clang
# BPF_CFLAGS=-O2 -g -target bpf -I.

# SRC=example.bpf.c
# OBJ=example.o

# all: $(OBJ)

# $(OBJ): $(SRC)
# 	$(BPF_CLANG) $(BPF_CFLAGS) -c $< -o $@


# clean:
# 	rm -f $(OBJ)
	
EBPF_PROGRAM = example.o
MANIFEST = package/manifest.json
SIGNATURE = example.o.sig
PRIVATE_KEY = key.pem
PUBLIC_KEY = pubkey.pem
COMBINED_FILE = combined_file.bin
HASH_FILE = combined_file.hash

NAME = "trace_openat"
AUTHOR = "Your Name"
DESCRIPTION = "Traces sys_enter_openat for specific PID"

# Targets
all: example.o manifest sign combined_file save_hash

example.o: example.bpf.c
	clang -I. -O2 -target bpf -c example.bpf.c -o example.o

manifest: example.o
	@echo "Running manifest generation script..."
	python3 tools/gen_manifest.py --name $(NAME) --author $(AUTHOR) --description $(DESCRIPTION) --out $(MANIFEST)
	@echo "Manifest generated successfully."

sign: example.o
	@echo "Signing the eBPF program..."
	openssl dgst -sha256 -sign $(PRIVATE_KEY) -out $(SIGNATURE) $(EBPF_PROGRAM)
	@echo "eBPF program signed successfully."

combined_file: $(SIGNATURE) $(MANIFEST)
	@echo "Combining signed program and manifest..."
	python3 tools/combine_and_hash.py --signed-file $(SIGNATURE) --manifest-file $(MANIFEST) --output $(COMBINED_FILE)
	@echo "Combined file generated successfully."

save_hash: $(COMBINED_FILE)
	@echo "Saving hash of the combined file..."
	sha256sum $(COMBINED_FILE) | awk '{print $$1}' > $(HASH_FILE)
	@echo "Hash saved successfully to $(HASH_FILE)."

clean:
	# Clean up generated files
	rm -f $(EBPF_PROGRAM) $(MANIFEST) $(SIGNATURE) $(COMBINED_FILE) $(HASH_FILE)
	@echo "Cleaned up generated files."
