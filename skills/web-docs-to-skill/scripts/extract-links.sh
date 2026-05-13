#!/bin/bash
# extract-links.sh - Extract all documentation links from a website
# Usage: ./extract-links.sh <url> [output_file]

URL="$1"
OUTPUT="${2:-/tmp/doc-links.txt}"

if [ -z "$URL" ]; then
    echo "Usage: $0 <url> [output_file]"
    exit 1
fi

echo "Extracting links from: $URL"
echo "Output: $OUTPUT"

# Open the page
browser-use open "$URL" > /dev/null 2>&1

# Wait for page to load
sleep 2

# Get all navigation links
browser-use eval "
(() => {
  const links = [];
  const navElements = document.querySelectorAll('nav, .sidebar, .menu, [role=\"navigation\"], aside, .nav, .docs-nav');
  navElements.forEach(nav => {
    nav.querySelectorAll('a[href]').forEach(a => {
      if (a.href && !a.href.startsWith('javascript:') && !a.href.startsWith('#')) {
        links.push(a.href);
      }
    });
  });
  // Fallback: get all links if no nav found
  if (links.length === 0) {
    document.querySelectorAll('a[href]').forEach(a => {
      if (a.href && !a.href.startsWith('javascript:') && !a.href.startsWith('#') && a.href.includes(window.location.hostname)) {
        links.push(a.href);
      }
    });
  }
  return [...new Set(links)];
})()
" | tee "$OUTPUT"

echo ""
echo "Found $(wc -l < "$OUTPUT") unique links"
echo "Links saved to: $OUTPUT"
