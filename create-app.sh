#!/bin/bash
# Interactive GitHub App creation using manifest flow

set -e

MANIFEST_FILE="${1}"

if [ -z "$MANIFEST_FILE" ]; then
    echo "Error: Manifest file is required"
    echo ""
    echo "Usage: $0 MANIFEST_FILE"
    echo ""
    echo "Example:"
    echo "  $0 manifest.json"
    echo ""
    echo "See examples/ directory for sample manifests"
    exit 1
fi

if [ ! -f "$MANIFEST_FILE" ]; then
    echo "❌ Error: Manifest file not found: $MANIFEST_FILE"
    exit 1
fi

# Validate JSON
if ! jq empty "$MANIFEST_FILE" 2>/dev/null; then
    echo "❌ Error: Invalid JSON in manifest file"
    exit 1
fi

APP_NAME=$(jq -r '.name' "$MANIFEST_FILE")

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  🤖 Create GitHub App: $APP_NAME"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "This will create a GitHub App using the manifest flow."
echo ""

# Show manifest summary
echo "Manifest Summary:"
echo "  Name:        $(jq -r '.name' "$MANIFEST_FILE")"
echo "  URL:         $(jq -r '.url' "$MANIFEST_FILE")"
echo "  Redirect:    $(jq -r '.redirect_url' "$MANIFEST_FILE")"
echo "  Public:      $(jq -r '.public' "$MANIFEST_FILE")"
echo ""

# Create HTML file in current directory (so the browser can access it)
# Some systems restrict access to /tmp for sandboxed browsers — create
# the HTML next to the repo so it's reliably openable by the user's browser.
TEMP_HTML=$(mktemp ./github-app-XXXXXX.html)

cat > "$TEMP_HTML" <<'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Create GitHub App</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Helvetica, Arial, sans-serif;
            max-width: 600px;
            margin: 100px auto;
            padding: 20px;
            text-align: center;
        }
        h1 { margin-bottom: 30px; }
        button {
            background: #2ea44f;
            border: 1px solid rgba(27,31,35,.15);
            border-radius: 6px;
            color: #fff;
            cursor: pointer;
            font-size: 16px;
            font-weight: 600;
            padding: 12px 20px;
        }
        button:hover { background: #2c974b; }
        .info {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            border-radius: 6px;
            padding: 15px;
            margin: 20px 0;
        }
    </style>
</head>
<body>
    <h1>🤖 Create GitHub App</h1>
    <div class="info">
        <p>Click the button to create your GitHub App.</p>
        <p>After creation, copy the <code>code</code> from the redirect URL.</p>
    </div>
    <form action="https://github.com/settings/apps/new" method="post">
        <input type="hidden" name="manifest" id="manifest">
        <button type="submit">Create GitHub App</button>
    </form>
    <script>
        document.getElementById("manifest").value = 'MANIFEST_JSON_PLACEHOLDER';
    </script>
</body>
</html>
EOF

# Insert manifest JSON into HTML
MANIFEST_JSON=$(cat "$MANIFEST_FILE" | jq -c .)
sed -i "s|MANIFEST_JSON_PLACEHOLDER|$MANIFEST_JSON|g" "$TEMP_HTML"

echo "Opening browser to create GitHub App..."
echo ""

# Open browser
if command -v xdg-open &> /dev/null; then
    xdg-open "$TEMP_HTML" &
elif command -v open &> /dev/null; then
    open "$TEMP_HTML" &
else
    echo "Please open this file in your browser:"
    echo "  $TEMP_HTML"
    echo ""
fi

sleep 2

echo "After GitHub redirects you back:"
echo ""
echo "  1. Copy the 'code' parameter from the URL"
echo "  2. Paste it below"
echo ""
read -p "Enter code: " CODE
echo ""

if [ -z "$CODE" ]; then
    echo "❌ No code provided"
    rm -f "$TEMP_HTML"
    exit 1
fi

# Exchange code for credentials
./exchange-code.sh "$CODE"

# Clean up
rm -f "$TEMP_HTML"

echo ""
echo "✅ GitHub App setup complete!"
echo ""
echo "Next steps:"
echo "  1. Install the app on your repositories"
echo "  2. Add APP_ID and APP_PRIVATE_KEY to GitHub Secrets"
echo "  3. Delete local credential files"
echo ""
