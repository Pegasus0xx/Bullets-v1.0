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

NUCLEI_VERSION=$(nuclei --version 2>&1 | grep "Nuclei Engine Version" | head -n1 | cut -d':' -f2 | tr -d ' v')
REQUIRED_VERSION="3.3.5"

if [ "$NUCLEI_VERSION" != "$REQUIRED_VERSION" ]; then
  echo -e "${RED}[!] nuclei version $REQUIRED_VERSION is required, but version $NUCLEI_VERSION is installed.${NC}"
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

echo -e "${YELLOW}[*] Decompiling APK file: $APK_FILE into folder: $APK_FOLDER${NC}"
apktool d "$APK_FILE" -o "$APK_FOLDER" &>/dev/null

echo -e "${GREEN}[+] Scanning folder: $APK_FOLDER with nuclei${NC}"
echo "$APK_FOLDER" | nuclei -t "$NUCLEI_TEMPLATE_PATH" | \
grep -Pv "(w3|android|github|tensorflow\.org|www\.google\.com|google\.com|mozilla\.org|schemas\.android|goo\.gl|apache\.org|ns\.adobe\.com|schemas\.microsoft\.com|developer\.apple\.com|apple\.com|jetbrains\.com)"

echo -e "${YELLOW}[*] Extracting HTTP Auth credentials from smali files...${NC}"

cd "$APK_FOLDER" || { echo -e "${RED}Failed to enter directory $APK_FOLDER${NC}"; exit 1; }

bash -c 'grep -E -r --include=\*.smali "const-string|invoke-virtual.*HttpAuthHandler;->proceed" . | awk '\''
  function is_cred(s) {
    if (s !~ /^[a-zA-Z0-9@._-]+$/) return 0;

    count = 0;
    for (i=2; i<=length(s); i++) {
      c = substr(s, i, 1);
      if (c ~ /[A-Z]/) count++;
    }
    if (count >= 3) return 0;

    for (i=1; i<length(s); i++) {
      c1 = substr(s, i, 1);
      c2 = substr(s, i+1, 1);
      if (c1 ~ /[A-Z]/ && c2 ~ /[a-z]/) return 0;
    }

    return 1;
  }
  {
    if ($0 ~ /const-string/) {
      match($0, /const-string (p[0-9]+), "([^"]+)"/, arr);
      vars[arr[1]] = arr[2];
    }
    if ($0 ~ /invoke-virtual.*HttpAuthHandler;->proceed/) {
      match($0, /invoke-virtual \{([^}]+)\}/, regs);
      split(regs[1], regs_arr, ", ");
      user = vars[regs_arr[2]];
      pass = vars[regs_arr[3]];
      if (is_cred(user) && is_cred(pass)) {
        print "Username: " user " | Password: " pass;
      }
    }
  }
'\'''

echo -e "${GREEN}[*] Done extracting credentials.${NC}"
