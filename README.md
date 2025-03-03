# Automated URL Recon & DAST Scanning

## Overview
This script automates the process of extracting, filtering, and testing URLs from Wayback Machine and gau. It also checks for live URLs and performs DAST (Dynamic Application Security Testing) using nuclei.

## Features
- Fetch URLs from **Wayback Machine** and **gau**
- Filter URLs with query parameters
- Deduplicate and sort URLs
- Check for live URLs using **httpx-toolkit**
- Perform DAST scanning with **nuclei**
- Saves results for manual testing

## Prerequisites
Ensure the following tools are installed before running the script:

- [`curl`](https://curl.se/)
- [`gau`](https://github.com/lc/gau)
- [`uro`](https://github.com/s0md3v/uro)
- [`httpx-toolkit`](https://github.com/projectdiscovery/httpx)
- [`nuclei`](https://github.com/projectdiscovery/nuclei)

You can install them using:
```bash
apt install curl -y
GO111MODULE=on go install -v github.com/lc/gau@latest
pip install uro
GO111MODULE=on go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
GO111MODULE=on go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest
```

## Installation
Clone the repository and navigate into it:
```bash
git clone https://github.com/coffinxp/lostfuzzer.git
cd lostfuzzer
```
Make the script executable:
```bash
chmod +x lostfuzzer.sh
```

## Usage
Run the script and follow the prompts:
```bash
./lostfuzzer.sh
```
You'll be asked to provide:
- A **target domain** (e.g., `example.com`)
- Whether to include **subdomains** (`yes` or `no`)

The script will:
1. Fetch URLs from Wayback Machine and **gau**
2. Deduplicate and filter URLs with parameters
3. Check which URLs are live using **httpx-toolkit**
4. Run **nuclei** for DAST scanning
5. Save results to files for further testing

## Output Files
- `live_urls.txt`: List of live URLs for manual testing
- `nuclei_results.txt`: Results of the DAST scan

## Example Output
```
[INFO] Fetching URLs from Wayback Machine and gau...
[INFO] Filtering URLs with query parameters...
[INFO] Checking for live URLs using httpx-toolkit...
[INFO] Running nuclei for DAST scanning...
[INFO] Nuclei results saved to nuclei_results.txt
[INFO] Live URLs saved to live_urls.txt
[INFO] Automation completed successfully!
```

## Disclaimer
This tool is intended for **educational and legal security testing purposes only**. The author is not responsible for any misuse of this script.

## Author
**~/.coffinxp@lostsec**

