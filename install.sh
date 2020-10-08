#!/usr/bin/env bash

# This script allows you to install relaxEyes.sh by running:
#
# curl https://raw.githubusercontent.com/nangsan/relaxEyes/main/install.sh | bash
#
#
# To remove the relaxEyes.sh pass uninstall flag.
#
# curl https://raw.githubusercontent.com/nangsan/relaxEyes/main/install.sh | uninstall=true bash

INSTALL_SCRIPT="curl -s -L https://raw.githubusercontent.com/nangsan/relaxEyes/main/install.sh"

INSTALL_DIR="$HOME/.local/bin"
INSTALL_NAME="relaxEyes.sh"
DESKTOP_FILE="$HOME/.config/autostart/relaxEyes.desktop"

if [ "$uninstall" = "true" ]; then
    if ! [ -f "$DESKTOP_FILE" ] && ! [ -x "$INSTALL_DIR/$INSTALL_NAME" ]; then
        echo "Not installed, if you want to install try:"
	echo
	echo "$INSTALL_SCRIPT | bash"
	exit 1
    fi

    "$INSTALL_DIR/$INSTALL_NAME" -r
    echo
    echo "Removing $INSTALL_DIR/$INSTALL_NAME"
    rm "$INSTALL_DIR/$INSTALL_NAME"
    exit 0
fi

if [ -f "$DESKTOP_FILE" ] && [ -x "$INSTALL_DIR/$INSTALL_NAME" ]; then
    echo "Already installed, if you want to uninstall try:"
    echo
    echo "$INSTALL_SCRIPT | uninstall=true bash"
    exit 1
fi

download_file() {
    url="$1"
    file="$2"

    echo "Fetching $url..."
    if test -x "$(command -v curl)"; then
        code=$(curl -s -w '%{http_code}' -L "$url" -o "$file")
    else
        echo "curl not available to perform http request"
        exit 1
    fi

    if [ "$code" != 200 ]; then
        echo "Request failed with code $code"
	exit 1
    fi
}

DOWNLOAD_URL="https://raw.githubusercontent.com/nangsan/relaxEyes/main/relaxEyes.sh"
DOWNLOAD_FILE=$(mktemp)

download_file "$DOWNLOAD_URL" "$DOWNLOAD_FILE"

echo "Adding executable permission."
chmod +x "$DOWNLOAD_FILE"

mkdir -p "$INSTALL_DIR"

echo "Moving executable to $INSTALL_DIR/$INSTALL_NAME"
mv "$DOWNLOAD_FILE" "$INSTALL_DIR/$INSTALL_NAME"

"$INSTALL_DIR/$INSTALL_NAME" -s

exit 0
