#!/bin/bash

# Check if Homebrew is installed, and install if not
if ! command -v brew &> /dev/null
then
    echo "Homebrew not found, installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew is already installed!"
fi

# Ensure Homebrew is up-to-date
echo "Updating Homebrew..."
brew update

# Install Git using Homebrew
echo "Installing Git..."
brew install git

# Install Flutter using Homebrew
echo "Installing Flutter..."
brew install --cask flutter

# Check if Flutter installed correctly and add to PATH
if command -v flutter &> /dev/null
then
    echo "Flutter installed successfully!"
else
    echo "Flutter installation failed!"
    exit 1
fi

# Add Flutter to the PATH in shell profile
echo "Adding Flutter to your PATH..."
FLUTTER_PATH=$(brew --prefix flutter)
SHELL_PROFILE="$HOME/.zshrc"

if [ -f "$SHELL_PROFILE" ]; then
    echo "export PATH=\"\$PATH:$FLUTTER_PATH/bin\"" >> $SHELL_PROFILE
    echo "Flutter path added to $SHELL_PROFILE"
else
    echo "No shell profile found, manually add the following line to your shell profile:"
    echo "export PATH=\"\$PATH:$FLUTTER_PATH/bin\""
fi

# Source the shell profile to apply changes
echo "Sourcing the shell profile..."
source $SHELL_PROFILE

# Run Flutter Doctor to check installation status
echo "Running Flutter Doctor to verify installation..."
flutter doctor

# Check if Flutter is fully installed and dependencies are resolved
if flutter doctor | grep -q "No issues found"; then
    echo "Flutter has been installed and verified successfully!"
else
    echo "There were issues during installation. Please check the output above."
fi
