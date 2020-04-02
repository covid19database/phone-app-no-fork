# error out if any command fails
set -e

COCOAPODS_VERSION=1.7.5
EXPECTED_PLUGIN_COUNT=15

# Setup the development environment
source setup/setup_ios.sh

./bin/configure_xml_and_json.js cordovabuild

echo "Setting up all npm packages"
npm install

echo "Updating bower"
npx bower update

echo "Installing cocoapods"
export PATH=~/.gem/ruby/2.6.0/bin:$PATH
gem install --no-document --user-install cocoapods -v $COCOAPODS_VERSION
pod setup

npx cordova prepare

INSTALLED_COUNT=`npx cordova plugin list | wc -l`
while [ $INSTALLED_COUNT -ne 15 ];
do
    sleep 5
    npx cordova prepare
done
