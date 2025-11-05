import struct
import sys

def analyze_dsc_key(dsc_path):
    """Extract and display the encryption key from a DSC file"""
    with open(dsc_path, 'rb') as f:
        data = f.read()
    
    if len(data) < 32:
        print("Error: File too small to be a valid DSC file")
        return
    
    # Read header
    format_str = data[0:16]
    key = struct.unpack('<I', data[16:20])[0]
    original_size = struct.unpack('<I', data[20:24])[0]
    dec_count = struct.unpack('<I', data[24:28])[0]
    
    print(f"File: {dsc_path}")
    print(f"Format: {format_str.decode('ascii', errors='ignore').rstrip(chr(0))}")
    print(f"\nEncryption Key: 0x{key:08X}")
    print(f"Original Size: {original_size:,} bytes")
    print(f"Symbol Count: {dec_count:,}")
    print(f"Compressed Size: {len(data):,} bytes")
    print(f"Compression Ratio: {len(data) / original_size * 100:.1f}%")
    
    print(f"\nUse this key for compression:")
    print(f"  python dsc_compressor.py <input> <output> {key:08X}")


def main():
    if len(sys.argv) < 2:
        print("Usage: python analyze_key.py <dsc_file>")
        print("Example: python analyze_key.py 01_prologue1")
        sys.exit(1)
    
    dsc_file = sys.argv[1]
    analyze_dsc_key(dsc_file)


if __name__ == "__main__":
    main()
