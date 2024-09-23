#!/bin/bash

# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]; then
  echo "Please run this script as root (e.g., sudo)"
  exit 1
fi

# Update the package list
echo "Updating package list..."
apt update -y

# Install KVM and related packages
echo "Installing KVM and dependencies..."
apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager

# Add current user to the libvirt and kvm groups
echo "Adding user $(whoami) to libvirt and kvm groups..."
sudo usermod -aG libvirt $(whoami)
sudo usermod -aG kvm $(whoami)

# Enable and start libvirtd service
echo "Enabling and starting libvirtd service..."
systemctl enable libvirtd
systemctl start libvirtd

# Check if KVM is supported
if egrep -c '(vmx|svm)' /proc/cpuinfo > /dev/null; then
  echo "KVM installation successful and supported on this system."
else
  echo "KVM is installed but hardware virtualization is not supported on this system."
fi

# Install VirtualBox
echo "Installing VirtualBox..."
apt install -y virtualbox virtualbox-ext-pack

# Install QEMU
echo "Installing QEMU..."
apt install -y qemu qemu-kvm libvirt-daemon libvirt-clients bridge-utils

# Post-install message
echo "Installation completed!"
echo "Please reboot your system for all changes to take effect."
