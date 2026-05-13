#!/usr/bin/env python3
import sys
import re
from typing import Dict

def extract_page_content(html: str, url: str) -> Dict:
    html = re.sub(r'<script[^>]*>.*?</script>', '', html, flags=re.DOTALL)
    html = re.sub(r'<style[^>]*>.*?</style>', '', html, flags=re.DOTALL)

    title_match = re.search(r'<title>([^<]+)</title>', html)
    title = title_match.group(1) if title_match else url

    h1_match = re.search(r'<h1[^>]*>([^<]+)</h1>', html)
    h1 = h1_match.group(1) if h1_match else None

    code_blocks = re.findall(r'<pre[^>]*><code[^>]*class=["\']([^"\']*)["\'][^>]*>(.*?)</code></pre>',
                            html, re.DOTALL)

    paragraphs = re.findall(r'<p[^>]*>([^<]+)</p>', html)

    return {
        "url": url,
        "title": title,
        "h1": h1,
        "code_blocks": code_blocks,
        "paragraphs": paragraphs
    }

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python extract_content.py <url>")
        sys.exit(1)

    url = sys.argv[1]
    print(f"URL: {url}")
    print("Note: This script expects HTML input via stdin or as a file argument")
