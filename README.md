# Automated URL Recon & DAST Scanning

## Overview
This script automates the process of extracting, filtering, and testing URLs from Wayback Machine and **gau**. It checks for live URLs and performs **DAST (Dynamic Application Security Testing)** using **nuclei**.

## Features
- Fetch URLs from **Wayback Machine** and **gau** in parallel
- Filter URLs containing query parameters
- Remove duplicate and sort URLs
- Check for live URLs using **httpx-toolkit**
- Perform **DAST scanning** with **nuclei**
- Save results for further manual testing

## Prerequisites
Ensure the following tools are installed before running the script:

- [`gau`](https://github.com/lc/gau)
- [`uro`](https://github.com/s0md3v/uro)
- [`nuclei`](https://github.com/projectdiscovery/nuclei)
- [`httpx-toolkit`](https://github.com/projectdiscovery/httpx)



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
- A **target domain** or a **file** containing a list of subdomains

The script will:
1. Fetch URLs from Wayback Machine and **gau** in parallel
2. Filter URLs containing query parameters
3. Check which URLs are live using **httpx-toolkit**
4. Run **nuclei** for **DAST scanning**
5. Save results for manual testing

## Output Files
- `filtered_urls.txt`: Filtered URLs with query parameters
- `nuclei_results.txt`: Results of the DAST scan

## Example Output
![Screenshot (1187)](https://github.com/user-attachments/assets/e1643ba5-0daf-4469-ae73-e20e8deaf5e8)

## Disclaimer
This tool is intended for **educational and legal security testing purposes only**. The author is not responsible for any misuse of this script.

## Author
**~/.coffinxp@lostsec**

