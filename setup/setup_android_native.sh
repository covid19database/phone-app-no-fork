echo "Ensure we exit on error"
set -e

# we can build android on both ubuntu and OSX
# should try both since there may be subtle differences
PLATFORM=`uname -a`

# both of these have java on Github Actions
# but may not in docker, for example
# should check for the existence of java and die if it doesn't exist
echo "Checking for java in the path"
JAVA_VERSION=`javac -version`
echo "Found java in the path with version $JAVA_VERSION"

echo "Setting up SDK environment"
ANDROID_BUILD_TOOLS_VERSION=27.0.3
MIN_SDK_VERSION=21
TARGET_SDK_VERSION=28

# Setup the development environment
source setup/setup_shared.sh

if [ -z $ANDROID_HOME ];
then
    echo "ANDROID_HOME not set, android SDK not found, exiting"
    exit 1
else
    echo "ANDROID_HOME found at $ANDROID_HOME"
fi

./bin/configure_xml_and_json.js cordovabuild

echo "Setting up all npm packages"
npm install

echo "Updating bower"
npx bower update

# echo "Downloading buildtools $ANDROID_BUILD_TOOLS_VERSION"
# ${ANDROID_HOME}/tools/bin/sdkmanager --sdk_root=${ANDROID_HOME} "platform-tools" "build-tools;${ANDROID_BUILD_TOOLS_VERSION}"
# 
# echo "Downloading platforms for minSDK ($MIN_SDK_VERSION) and targetSDK ($TARGET_SDK_VERSION)"
# ${ANDROID_HOME}/tools/bin/sdkmanager --sdk_root=${ANDROID_HOME} "platforms;android-$MIN_SDK_VERSION" "platforms;android-$TARGET_SDK_VERSION"
# 
# echo "Downloading google APIs for minSDK ($MIN_SDK_VERSION) and targetSDK ($TARGET_SDK_VERSION)"
# ${ANDROID_HOME}/tools/bin/sdkmanager --sdk_root=${ANDROID_HOME} "add-ons;addon-google_apis-google-$MIN_SDK_VERSION" "add-ons;addon-google_apis-google-$TARGET_SDK_VERSION"
# 
# echo "Downloading extras"
# ${ANDROID_HOME}/tools/bin/sdkmanager --sdk_root=${ANDROID_HOME} "extras;android;m2repository" "extras;google;google_play_services" "extras;google;instantapps" "extras;google;m2repository"

echo "Setting up sdkman"
curl -s "https://get.sdkman.io" | bash
ls -al ~/ 
source "~/.sdkman/bin/sdkman-init.sh"

echo "Setting up gradle using SDKMan"
sdk install gradle 4.1

npx cordova prepare

INSTALLED_COUNT=`npx cordova plugin list | wc -l`
echo "Found $INSTALLED_COUNT plugins, expected 15"
if [ $INSTALLED_COUNT -lt 15 ];
then
    echo "Found $INSTALLED_COUNT plugins, expected 15, retrying" 
    sleep 5
    npx cordova prepare
elif [ $INSTALLED_COUNT -gt 15 ];
then
    echo "Found extra plugins!"
    npx cordova plugin list
    echo "Failing for investigation"
    exit 1
else
    echo "All plugins installed successfully!"
fi
