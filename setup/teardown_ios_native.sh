export COCOAPODS_VERSION=1.9.1
source setup/teardown_shared.sh

echo "Uninstalling cocoapods"
yes n | gem uninstall cocoapods -v $COCOAPODS_VERSION

echo "Removing the cocoapods directory (~ 2.5G on my system)"
rm -rf ~/.cocoapods

echo "Removing all modules, plugins and platforms to make a fresh start"
rm -rf node_modules
rm -rf plugins
rm -rf platforms
