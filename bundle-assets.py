#!/usr/bin/env python3

import os
import re
import requests
import sys

ASSET_PATTERNS = {
    '<link rel="stylesheet" href="(.*?)">': '<style>{}</style>',
    '<script src="(.*?)"></script>': '<script>{}</script>',
}

def read_asset(directory, url):
    if url.startswith("https://"):
        return read_url(url)
    return read_file(directory, url)

def read_file(directory, fname):
    fname = os.path.join(directory, fname)
    print("READ: {}".format(fname))
    with open(fname, "r") as f:
        return f.read().strip()

def read_url(url):
    print("GET: {}".format(url))
    response = requests.get(url)
    response.raise_for_status()
    return response.text

for fname in sys.argv[1:]:
    print("Processing {}...".format(fname))
    directory = os.path.dirname(fname)
    with open(fname, "r") as f:
        lines = f.read().splitlines()
    for i, line in enumerate(lines):
        for pattern, replacement in ASSET_PATTERNS.items():
            match = re.search(pattern, line)
            if match is None: continue
            url = match.group(1).split("?")[0]
            content = read_asset(directory, url)
            content = replacement.format(content)
            a, z = match.span()
            lines[i] = line[:a] + content + line[z:]
    with open(fname, "w") as f:
        f.write("\n".join(lines) + "\n")
