./bin/configure_xml_and_json.js cordovabuild

echo "Setting up all npm packages"
npm install

echo "Updating bower"
npx bower update

npx cordova prepare
