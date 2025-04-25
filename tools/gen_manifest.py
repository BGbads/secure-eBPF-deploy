#!/usr/bin/env python3
import json
import argparse
import os

def generate_manifest(output_path, name, author, description, pid_required=True):
    manifest = {
        "metadata": {
            "name": name,
            "author": author,
            "description": description
        },
        "permissions": {
            "helpers": ["bpf_get_current_pid_tgid", "bpf_printk"],
            "subsystems": ["tracing"]
        },
        "attach_rules": {
            "hooks": ["tracepoint/syscalls/sys_enter_openat"],
            "capabilities": ["CAP_BPF"]
        },
        "system_requirements": {
            "kernel_version": ">=5.8",
            "btf": True,
            "core_compatibility": True
        }
    }

    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    with open(output_path, "w") as f:
        json.dump(manifest, f, indent=4)
    print(f"Manifest written to {output_path}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Generate manifest for eBPF program")
    parser.add_argument("--name", required=True, help="Program name")
    parser.add_argument("--author", required=True, help="Author")
    parser.add_argument("--description", required=True, help="Description")
    parser.add_argument("--out", default="package/manifest.json", help="Output manifest path")

    args = parser.parse_args()
    generate_manifest(args.out, args.name, args.author, args.description)
