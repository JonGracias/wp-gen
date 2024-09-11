import hashlib
import sys


def main(key):
    # Input string
    input_string = key

    # Create an MD5 hash object
    md5_hash = hashlib.md5()

    # Update the hash object with the bytes of the string
    md5_hash.update(input_string.encode('utf-8'))

    # Get the hexadecimal representation of the hash
    hash_result = md5_hash.hexdigest()

    print(hash_result)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python hash_generator.py <key>")
        sys.exit(1)
    key = sys.argv[1]
    main(key)
