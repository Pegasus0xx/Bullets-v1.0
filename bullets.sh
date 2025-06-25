#!/bin/bash

RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
NC="\033[0m"

if ! command -v apktool &>/dev/null; then
  echo -e "${RED}[!] apktool not found. Please install it first.${NC}"
  exit 1
fi

if ! command -v nuclei &>/dev/null; then
  echo -e "${RED}[!] nuclei not found. Please install it first.${NC}"
  exit 1
fi

if [ -z "$1" ]; then
  echo -e "${RED}Usage: $0 <APK_FILE>${NC}"
  exit 1
fi

APK_FILE="$1"
NUCLEI_TEMPLATE_PATH="$HOME/Templates"
timestamp=$(date +%s)
APK_FOLDER="${APK_FILE}_${timestamp}"

echo -e "${YELLOW}[*] Decoding file: $APK_FILE into folder: $APK_FOLDER${NC}"
apktool d "$APK_FILE" -o "$APK_FOLDER" &>/dev/null

echo -e "${GREEN}[+] Scanning folder: $APK_FOLDER with nuclei${NC}"
echo "$APK_FOLDER" | nuclei -t "$NUCLEI_TEMPLATE_PATH"

echo -e "${YELLOW}[*] Done!${NC}"
