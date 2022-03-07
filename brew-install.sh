/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/gryff/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

brew install $(<brew-packages.txt)
brew install --cask $(<brew-cask-packages.txt)

