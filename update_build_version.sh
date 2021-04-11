DIR="${BUILT_PRODUCTS_DIR}"
APP=${EXECUTABLE_NAME}
APP_DIR="${APP}.app"
INFOPLIST="Info.plist"
PLIST_BUDDY="/usr/libexec/PlistBuddy -c"

FULL_PATH="${DIR}/${APP_DIR}/${INFOPLIST}"
BUNDLE_SHORT_VER=$($PLIST_BUDDY "print CFBundleShortVersionString" "$FULL_PATH")
BUNDLE_VER=$($PLIST_BUDDY "print CFBundleVersion" "$FULL_PATH")

VER="${BUNDLE_SHORT_VER} (${BUNDLE_VER})"
SETTINGBUNDLE_ROOTPLIST="${DIR}/${APP_DIR}/Settings.bundle/Root.plist"
$PLIST_BUDDY "Set PreferenceSpecifiers:0:Title Version: ${VER}" "$SETTINGBUNDLE_ROOTPLIST"
