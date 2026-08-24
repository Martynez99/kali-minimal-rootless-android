#!/bin/bash

#############################################
##                                         ##
##  Kali Linux Minimal - Rootless Android ##
##  Installation Script for Termux        ##
##                                         ##
#############################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
KALI_DIR="${HOME}/kali-minimal"
ROOTFS_URL="https://mirror.kali.org/kali-images/kali-latest/kali-rootfs-latest-arm64.tar.xz"
ARCH=$(uname -m)

# Functions
print_info() {
    echo -e "${BLUE}[*]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[+]${NC} $1"
}

print_error() {
    echo -e "${RED}[-]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

# Check architecture
check_architecture() {
    print_info "Checking device architecture..."
    case "$ARCH" in
        aarch64)
            print_success "ARM64 architecture detected"
            ;;
        armv7l)
            print_warning "ARM32 architecture detected - limited support"
            ROOTFS_URL="https://mirror.kali.org/kali-images/kali-latest/kali-rootfs-latest-armhf.tar.xz"
            ;;
        x86_64)
            print_success "x86_64 architecture detected"
            ROOTFS_URL="https://mirror.kali.org/kali-images/kali-latest/kali-rootfs-latest-amd64.tar.xz"
            ;;
        *)
            print_error "Unsupported architecture: $ARCH"
            exit 1
            ;;
    esac
}

# Check dependencies
check_dependencies() {
    print_info "Checking package dependencies..."
    
    local missing_deps=()
    
    # Check for proot
    if ! command -v proot &> /dev/null; then
        print_warning "proot not found"
        missing_deps+=("proot")
    else
        print_success "proot is OK!"
    fi
    
    # Check for tar
    if ! command -v tar &> /dev/null; then
        print_warning "tar not found"
        missing_deps+=("tar")
    else
        print_success "tar is OK!"
    fi
    
    # Check for curl
    if ! command -v curl &> /dev/null; then
        print_warning "curl not found"
        missing_deps+=("curl")
    else
        print_success "curl is OK!"
    fi
    
    # Install missing dependencies
    if [ ${#missing_deps[@]} -gt 0 ]; then
        print_info "Installing missing dependencies: ${missing_deps[*]}"
        pkg install -y "${missing_deps[@]}" || {
            print_error "Failed to install dependencies"
            exit 1
        }
    fi
}

# Create installation directory
create_directory() {
    print_info "Creating installation directory..."
    mkdir -p "$KALI_DIR"
    print_success "Directory created at: $KALI_DIR"
}

# Download rootfs
download_rootfs() {
    local rootfs_file="$KALI_DIR/kali-rootfs.tar.xz"
    
    if [ -f "$rootfs_file" ]; then
        print_warning "Existing rootfs file found at $rootfs_file"
        read -p "Delete and download a new one? [y/N] " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_info "Skipping download..."
            return
        fi
        rm -f "$rootfs_file"
    fi
    
    print_info "Downloading Kali Linux rootfs..."
    print_info "URL: $ROOTFS_URL"
    
    if curl -L --progress-bar -o "$rootfs_file" "$ROOTFS_URL"; then
        print_success "Rootfs downloaded successfully"
    else
        print_error "Failed to download rootfs"
        exit 1
    fi
}

# Extract rootfs
extract_rootfs() {
    local rootfs_file="$KALI_DIR/kali-rootfs.tar.xz"
    
    if [ ! -f "$rootfs_file" ]; then
        print_error "Rootfs file not found: $rootfs_file"
        exit 1
    fi
    
    print_info "Extracting rootfs (this may take a while)..."
    
    if tar -xJf "$rootfs_file" -C "$KALI_DIR"; then
        print_success "Rootfs extracted successfully"
    else
        print_error "Failed to extract rootfs"
        exit 1
    fi
}

# Create launch script
create_launch_script() {
    local launch_script="$KALI_DIR/start-kali.sh"
    
    print_info "Creating launch script..."
    
    cat > "$launch_script" << 'EOF'
#!/bin/bash

KALI_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export KALI_ROOTFS="$KALI_DIR/rootfs"

# Ensure rootfs directory exists
if [ ! -d "$KALI_ROOTFS" ]; then
    echo "Error: Kali rootfs not found at $KALI_ROOTFS"
    exit 1
fi

# Launch Kali with proot
proot -r "$KALI_ROOTFS" -w / -u /system/bin/sh /bin/bash
EOF

    chmod +x "$launch_script"
    print_success "Launch script created at: $launch_script"
}

# Main installation flow
main() {
    echo -e "${BLUE}"
    echo "╔════════════════════════════════════════╗"
    echo "║  Kali Linux Minimal - Rootless Android ║"
    echo "║        Installation Script             ║"
    echo "╚════════════════════════════════════════╝"
    echo -e "${NC}"
    
    check_architecture
    check_dependencies
    create_directory
    download_rootfs
    extract_rootfs
    create_launch_script
    
    echo -e "${GREEN}"
    echo "╔════════════════════════════════════════╗"
    echo "║   Installation Complete!               ║"
    echo "╚════════════════════════════════════════╝"
    echo -e "${NC}"
    
    print_info "To start Kali Linux, run:"
    echo -e "  ${YELLOW}bash $KALI_DIR/start-kali.sh${NC}"
    
    print_info "Installation directory: $KALI_DIR"
}

# Run installation
main "$@"
