import hashlib
import argparse


def combine_and_hash(signed_file, manifest_file, output_file):

    with open(signed_file, 'rb') as f:
        signed_program = f.read()

    with open(manifest_file, 'rb') as f:
        manifest = f.read()

    combined = signed_program + manifest

    combined_hash = hashlib.sha256(combined).hexdigest()

    with open(output_file, 'wb') as f:
        f.write(combined)

    return combined_hash


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Combine signed program and manifest, and compute hash")
    parser.add_argument("--signed-file", required=True,
                        help="Path to signed program file")
    parser.add_argument("--manifest-file", required=True,
                        help="Path to manifest file")
    parser.add_argument("--output", required=True,
                        help="Path to output combined file")

    args = parser.parse_args()

    combined_hash = combine_and_hash(
        args.signed_file, args.manifest_file, args.output)
    print(f"Combined hash: {combined_hash}")
