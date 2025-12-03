#!/bin/bash
# Exchange GitHub App manifest code for credentials

set -e

CODE="${1}"
OUTPUT_DIR="${2:-.}"

if [ -z "$CODE" ]; then
    echo "Error: Code parameter is required"
    echo ""
    echo "Usage: $0 CODE [OUTPUT_DIR]"
    echo ""
    echo "Arguments:"
    echo "  CODE         - The code from the GitHub redirect URL"
    echo "  OUTPUT_DIR   - Directory to save credentials (default: current directory)"
    echo ""
    echo "Example:"
    echo "  $0 01234567-89ab-cdef-0123-456789abcdef"
    echo "  $0 01234567-89ab-cdef-0123-456789abcdef ./credentials"
    echo ""
    echo "Get your code from the URL after creating the app:"
    echo "  https://github.com/OWNER/REPO?code=YOUR_CODE_HERE"
    exit 1
fi

# Check for jq
if ! command -v jq &> /dev/null; then
    echo "❌ Error: jq is not installed"
    echo ""
    echo "Install jq:"
    echo "  Ubuntu/Debian: sudo apt-get install jq"
    echo "  macOS:         brew install jq"
    echo "  Fedora:        sudo dnf install jq"
    exit 1
fi

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

echo "🔄 Exchanging code for GitHub App credentials..."
echo ""

# Exchange code for credentials
RESPONSE=$(curl -s -X POST \
    -H "Accept: application/vnd.github+json" \
    "https://api.github.com/app-manifests/$CODE/conversions")

# Check if response contains an error
if echo "$RESPONSE" | jq -e '.message' > /dev/null 2>&1; then
    echo "❌ Error from GitHub API:"
    echo "$RESPONSE" | jq -r '.message'
    echo ""

    # Check for common issues
    if echo "$RESPONSE" | grep -q "Not Found"; then
        echo "Common causes:"
        echo "  • Code has expired (codes expire after 1 hour)"
        echo "  • Code was already used"
        echo "  • Code format is incorrect"
    fi

    exit 1
fi

# Extract credentials
APP_ID=$(echo "$RESPONSE" | jq -r '.id')
APP_NAME=$(echo "$RESPONSE" | jq -r '.name')
APP_SLUG=$(echo "$RESPONSE" | jq -r '.slug')
PEM=$(echo "$RESPONSE" | jq -r '.pem')
WEBHOOK_SECRET=$(echo "$RESPONSE" | jq -r '.webhook_secret')
CLIENT_ID=$(echo "$RESPONSE" | jq -r '.client_id')
CLIENT_SECRET=$(echo "$RESPONSE" | jq -r '.client_secret')
HTML_URL=$(echo "$RESPONSE" | jq -r '.html_url')
OWNER=$(echo "$RESPONSE" | jq -r '.owner.login')

# Save PEM to file
PEM_FILE="$OUTPUT_DIR/github-app-private-key.pem"
echo "$PEM" > "$PEM_FILE"
chmod 600 "$PEM_FILE"

# Save summary to file
SUMMARY_FILE="$OUTPUT_DIR/github-app-credentials.txt"
cat > "$SUMMARY_FILE" <<EOF
GitHub App Credentials
======================

Created: $(date)

App Name:       $APP_NAME
App ID:         $APP_ID
App Slug:       $APP_SLUG
Owner:          $OWNER

Client ID:      $CLIENT_ID
Client Secret:  $CLIENT_SECRET

Webhook Secret: $WEBHOOK_SECRET

Private Key:    $PEM_FILE
App URL:        $HTML_URL

Installation URL: https://github.com/settings/apps/$APP_SLUG/installations

Next Steps:
1. Install the app on repositories
2. Add APP_ID and APP_PRIVATE_KEY to GitHub Secrets
3. Delete local credential files after setup
EOF

chmod 600 "$SUMMARY_FILE"

echo "✅ GitHub App created successfully!"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  📋 GitHub App Details"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "App Name:         $APP_NAME"
echo "App ID:           $APP_ID"
echo "App Slug:         $APP_SLUG"
echo "Owner:            $OWNER"
echo ""
echo "Client ID:        $CLIENT_ID"
echo "Webhook Secret:   $WEBHOOK_SECRET"
echo ""
echo "Private Key:      $PEM_FILE"
echo "Summary:          $SUMMARY_FILE"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  🔗 URLs"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "App Settings:     $HTML_URL"
echo "Install App:      https://github.com/settings/apps/$APP_SLUG/installations"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  🔐 Add to GitHub Secrets"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "For your repository secrets:"
echo ""
echo "  Secret Name: APP_ID"
echo "  Value:       $APP_ID"
echo ""
echo "  Secret Name: APP_PRIVATE_KEY"
echo "  Value:       [Contents of $PEM_FILE]"
echo ""
echo "View private key:"
echo "  cat $PEM_FILE"
echo ""
echo "Quick add (requires gh CLI):"
echo "  echo '$APP_ID' | gh secret set APP_ID -R OWNER/REPO"
echo "  gh secret set APP_PRIVATE_KEY -R OWNER/REPO < $PEM_FILE"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ⚠️  Security Reminders"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "• Private key and credentials are in .gitignore"
echo "• Store credentials securely (password manager)"
echo "• Never commit .pem or credentials files to git"
echo "• Delete local files after adding to GitHub Secrets"
echo ""
