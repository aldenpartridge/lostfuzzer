#!/bin/bash

# ANSI color codes
RED='\033[91m'
GREEN='\033[92m'
RESET='\033[0m'

# ASCII art banner
echo -e "${RED}"
cat << "EOF"
 ______            _____________                              
___  /______________  /___  __/___  _________________________
__  /_  __ \_  ___/  __/_  /_ _  / / /__  /__  /_  _ \_  ___/
_  / / /_/ /(__  )/ /_ _  __/ / /_/ /__  /__  /_/  __/  /    
/_/  \____//____/ \__/ /_/    \__,_/ _____/____/\___//_/ 
      
                                       by ~/.coffinxp@lostsec
EOF
echo -e "${RESET}"

# Ensure required tools are installed
REQUIRED_TOOLS=("curl" "gau" "uro" "httpx-toolkit" "nuclei")
for tool in "${REQUIRED_TOOLS[@]}"; do
    if ! command -v "$tool" &>/dev/null; then
        echo -e "${RED}[ERROR] $tool is not installed. Please install it and try again.${RESET}"
        exit 1
    fi
done

# Ask the user for the domain
read -p "Enter the target domain (e.g., example.com): " DOMAIN
if [ -z "$DOMAIN" ]; then
    echo -e "${RED}[ERROR] Domain cannot be empty.${RESET}"
    exit 1
fi

# Ask the user if they want to include subdomains
read -p "Include subdomains? (yes/no): " INCLUDE_SUBS
INCLUDE_SUBS=$(echo "$INCLUDE_SUBS" | tr '[:upper:]' '[:lower:]')
if [ "$INCLUDE_SUBS" != "yes" ] && [ "$INCLUDE_SUBS" != "no" ]; then
    echo -e "${RED}[ERROR] Invalid input. Enter 'yes' or 'no'.${RESET}"
    exit 1
fi

# Create temporary files
ARCHIVE_FILE=$(mktemp)
GAU_FILE=$(mktemp)
ALL_URLS_FILE=$(mktemp)
FILTERED_URLS_FILE=$(mktemp)
SORTED_URLS_FILE=$(mktemp)
LIVE_URLS_FILE="live_urls.txt"  # Save live URLs for manual testing
NUCLEI_RESULTS="nuclei_results.txt"

# Cleanup on exit
trap "rm -f $ARCHIVE_FILE $GAU_FILE $ALL_URLS_FILE $FILTERED_URLS_FILE $SORTED_URLS_FILE" EXIT

# Step 1: Fetch URLs from Wayback Machine and gau
echo -e "${GREEN}[INFO] Fetching URLs from Wayback Machine and gau...${RESET}"
if [ "$INCLUDE_SUBS" == "yes" ]; then
    curl -s "https://web.archive.org/cdx/search/cdx?url=*.${DOMAIN}/*&output=text&fl=original&collapse=urlkey" > "$ARCHIVE_FILE"
    gau --subs "$DOMAIN" > "$GAU_FILE"
else
    curl -s "https://web.archive.org/cdx/search/cdx?url=${DOMAIN}/*&output=text&fl=original&collapse=urlkey" > "$ARCHIVE_FILE"
    gau "$DOMAIN" > "$GAU_FILE"
fi

# Combine results and deduplicate using uro and sort
cat "$ARCHIVE_FILE" "$GAU_FILE" | uro | sort -u > "$ALL_URLS_FILE"

# Step 2: Filter URLs with query parameters
echo -e "${GREEN}[INFO] Filtering URLs with query parameters...${RESET}"
grep -E '\?[^=]+=.+$' "$ALL_URLS_FILE" > "$FILTERED_URLS_FILE"

# Step 3: Sort filtered URLs
echo -e "${GREEN}[INFO] Sorting filtered URLs...${RESET}"
uro < "$FILTERED_URLS_FILE" | sort -u > "$SORTED_URLS_FILE"

# Step 4: Use httpx-toolkit to check for live URLs
echo -e "${GREEN}[INFO] Checking for live URLs using httpx-toolkit...${RESET}"
httpx-toolkit -silent -t 100 < "$SORTED_URLS_FILE" > "$LIVE_URLS_FILE"

# Step 5: Run nuclei for DAST scanning
echo -e "${GREEN}[INFO] Running nuclei for DAST scanning...${RESET}"
nuclei -dast -rl 100 -retries 2 -c 30 -silent -o "$NUCLEI_RESULTS" < "$LIVE_URLS_FILE"

# Step 6: Show saved results
echo -e "${GREEN}[INFO] Nuclei results saved to $NUCLEI_RESULTS${RESET}"
echo -e "${GREEN}[INFO] Live URLs saved to $LIVE_URLS_FILE for manual testing.${RESET}"
echo -e "${GREEN}[INFO] Automation completed successfully!${RESET}"
