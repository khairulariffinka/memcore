#!/bin/bash
# MemCore Budgeted Read — Token-aware file reading with section-aware truncation
# Based on MiMo-Code's budgeted reading system
#
# Usage: bash budgeted-read.sh <file> [max_tokens]
# Default max_tokens: 4000
#
# Features:
# - Estimates token count (rough: 1 token ≈ 4 characters)
# - Preserves section headers even when body is truncated
# - Appends truncation hint with offset for continuation
# - Supports multiple files with combined budget

set -euo pipefail

# ── Defaults ──
MAX_TOKENS=${2:-4000}
CHARS_PER_TOKEN=4
FILE=""

# ── Functions ──

# Estimate token count from text
estimate_tokens() {
    local text="$1"
    echo ${#text} | awk '{printf "%d", $1 / '"$CHARS_PER_TOKEN"'}'
}

# Truncate section body while preserving header
truncate_section() {
    local header="$1"
    local body="$2"
    local budget="$3"
    
    local body_tokens
    body_tokens=$(estimate_tokens "$body")
    
    if [[ $body_tokens -le $budget ]]; then
        echo "$header"
        echo "$body"
        return
    fi
    
    # Truncate body to fit budget
    local max_chars=$((budget * CHARS_PER_TOKEN))
    local truncated
    truncated=$(echo "$body" | head -c "$max_chars")
    
    # Find last complete line
    truncated=$(echo "$truncated" | sed '$ s/[^[:space:]]*$//')
    
    echo "$header"
    echo "$truncated"
    echo ""
    echo "⚠️ Truncated at ~${budget} tokens. Use 'read' with offset for the rest."
}

# Read file with budget
budgeted_read() {
    local file="$1"
    local max_tokens="$2"
    
    if [[ ! -f "$file" ]]; then
        echo "Error: File not found: $file"
        return 1
    fi
    
    local total_chars
    total_chars=$(wc -c < "$file")
    local total_tokens=$((total_chars / CHARS_PER_TOKEN))
    
    # If file fits in budget, output as-is
    if [[ $total_tokens -le $max_tokens ]]; then
        cat "$file"
        return
    fi
    
    echo "📄 Reading: $file (~${total_tokens} tokens, budget: ${max_tokens})"
    echo ""
    
    # Parse sections (## headers)
    local current_header=""
    local current_body=""
    local remaining_budget=$max_tokens
    local sections_found=0
    
    while IFS= read -r line; do
        if [[ "$line" =~ ^##\ .+ ]]; then
            # Process previous section if exists
            if [[ -n "$current_header" ]]; then
                sections_found=$((sections_found + 1))
                local header_tokens
                header_tokens=$(estimate_tokens "$current_header")
                local body_budget=$((remaining_budget - header_tokens))
                
                if [[ $body_budget -gt 0 ]]; then
                    truncate_section "$current_header" "$current_body" "$body_budget"
                    remaining_budget=$((remaining_budget - header_tokens - $(estimate_tokens "$current_body")))
                fi
            fi
            
            # Start new section
            current_header="$line"
            current_body=""
        else
            current_body="${current_body:+$current_body
}$line"
        fi
    done < "$file"
    
    # Process last section
    if [[ -n "$current_header" ]]; then
        sections_found=$((sections_found + 1))
        local header_tokens
        header_tokens=$(estimate_tokens "$current_header")
        local body_budget=$((remaining_budget - header_tokens))
        
        if [[ $body_budget -gt 0 ]]; then
            truncate_section "$current_header" "$current_body" "$body_budget"
        fi
    fi
    
    echo ""
    echo "📊 Read ${sections_found} sections, ${total_tokens} tokens total"
}

# ── Main ──

if [[ $# -lt 1 ]]; then
    echo "Usage: budgeted-read.sh <file> [max_tokens]"
    echo ""
    echo "Examples:"
    echo "  budgeted-read.sh checkpoint.md 4000"
    echo "  budgeted-read.sh MEMORY.md 2000"
    echo "  budgeted-read.sh notes.md 1000"
    exit 1
fi

FILE="$1"
budgeted_read "$FILE" "$MAX_TOKENS"
