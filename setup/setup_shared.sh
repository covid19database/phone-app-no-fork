export NVM_VERSION=0.35.3
export NODE_VERSION=9.4.0

echo "Is this in a CI environment? $CI"

echo "Installing the correct version of nvm"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v$NVM_VERSION/install.sh | bash

echo "Setting up the variables to run nvm"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

echo "Installing the correct node version"
nvm install $NODE_VERSION

echo "Upgrade the version of npm to the correct one"
npm install -g npm@6.0.0

git remote add upstream https://github.com/covid19database/phone-app.git
