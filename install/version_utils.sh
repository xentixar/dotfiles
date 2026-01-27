#!/bin/bash

# Version utility helpers
# Reads tool versions from versions.json located at the repo root.

# Resolve repository root (one level above this script directory)
_VU_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
_VU_REPO_ROOT="$(cd "$_VU_SCRIPT_DIR/.." && pwd)"
_VU_VERSIONS_FILE="$_VU_REPO_ROOT/versions.json"

# get_version TOOL DEFAULT
# Prints the version for TOOL from versions.json, or DEFAULT on error/missing.
get_version() {
    local tool="$1"
    local default_value="$2"

    # Fallback if versions.json does not exist
    if [ ! -f "$_VU_VERSIONS_FILE" ]; then
        echo "$default_value"
        return 0
    fi

    # Prefer python3 for JSON parsing
    if command -v python3 >/dev/null 2>&1; then
        local value
        value="$(python3 - <<PY
import json, sys
path = r"$_VU_VERSIONS_FILE"
tool = "$tool"
default_value = "$default_value"
try:
    with open(path, "r", encoding="utf-8") as f:
        data = json.load(f)
    v = data.get(tool, default_value)
    if isinstance(v, str) and v.strip():
        print(v.strip())
    else:
        print(default_value)
except Exception:
    print(default_value)
PY
)"
        echo "$value"
        return 0
    fi

    # If python3 is not available, fall back to the default
    echo "$default_value"
}

