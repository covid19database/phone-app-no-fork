# error out if any command fails
set -e

COCOAPODS_VERSION=1.9.1
EXPECTED_PLUGIN_COUNT=15

# Setup the development environment
source setup/setup_shared.sh

./bin/configure_xml_and_json.js cordovabuild

echo "Setting up all npm packages"
npm install

echo "Updating bower"
npx bower update

echo "Installing cocoapods"
export PATH=~/.gem/ruby/2.6.0/bin:$PATH
gem install --no-document --user-install cocoapods -v $COCOAPODS_VERSION

npx cordova prepare

INSTALLED_COUNT=`npx cordova plugin list | wc -l`
echo "Found $INSTALLED_COUNT plugins, expected 15"
if [ $INSTALLED_COUNT -lt 15 ];
then
    echo "Found $INSTALLED_COUNT plugins, expected 15, retrying" 
    sleep 5
    npx cordova prepare
elif [ $INSTALLED_COUNT -gt 15 ];
    echo "Found extra plugins!"
    npx cordova plugin list
    echo "Failing for investigation"
    exit 1
else
    echo "All plugins installed successfully!"
fi
