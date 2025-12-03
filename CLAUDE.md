# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This repository provides tools and utilities for creating and managing GitHub Apps using GitHub's manifest flow. It automates the app registration process, private key generation, permission configuration, and credential management.

**Purpose:** Streamline GitHub App creation using the manifest flow API to avoid manual app registration steps.

## Project Architecture

### Core Components

```
github-app-tools/
├── create-app.sh           # Interactive app creation script
├── exchange-code.sh        # Standalone credential exchange script
├── examples/               # Manifest examples for different use cases
├── docs/                   # Documentation and guides
└── .github/
    ├── ISSUE_TEMPLATE/     # Bug reports and feature requests
    └── workflows/          # CI/CD automation
```

### How It Works

**GitHub App Creation Flow:**
1. User prepares a manifest.json with app configuration
2. Script opens GitHub's manifest submission page
3. User confirms app creation in browser
4. GitHub redirects with a temporary code
5. Script exchanges code for app credentials
6. Private key and credentials are saved locally

### Key Features

- **Manifest-Based Creation**: Uses GitHub's manifest flow API
- **Interactive CLI**: Guides users through app creation
- **Credential Management**: Saves private keys and app details securely
- **Example Manifests**: Pre-configured examples for common use cases
- **GitHub Actions Integration**: Documentation for using apps in workflows

## Common Operations

### Create a GitHub App

```bash
# Using interactive script
./create-app.sh path/to/manifest.json

# The script will:
# 1. Open browser with manifest
# 2. Wait for confirmation
# 3. Prompt for redirect code
# 4. Exchange code for credentials
# 5. Save everything locally
```

### Exchange Code Manually

```bash
# If you already have a code
./exchange-code.sh YOUR_CODE_HERE
```

### Example Manifest

```json
{
  "name": "Your App Name",
  "url": "https://github.com/labrats-work/your-repo",
  "description": "Your app description",
  "redirect_url": "https://github.com/labrats-work/your-repo",
  "public": false,
  "default_permissions": {
    "contents": "read",
    "issues": "write"
  },
  "default_events": ["push", "pull_request"]
}
```

## Manifest Configuration

### Permission Levels

- `read`: Read-only access
- `write`: Read and write access
- `admin`: Full administrative access

### Common Permissions

- `contents`: Repository contents
- `issues`: Issues and comments
- `pull_requests`: Pull requests
- `checks`: Checks and statuses
- `metadata`: Repository metadata (always read)

### Event Subscriptions

Common events:
- `push`: Code pushes
- `pull_request`: PR events
- `issues`: Issue events
- `issue_comment`: Issue comments
- `check_run`: Check runs
- `check_suite`: Check suites

## Security Considerations

### Credential Storage

**IMPORTANT:** Private keys and credentials are sensitive:

- Saved to `.pem` and `.txt` files (gitignored)
- **Never commit these to git**
- Delete local copies after adding to GitHub Secrets
- Store in GitHub Secrets for Actions integration

### Files to Protect

- `github-app-private-key.pem` - Private key
- `github-app-credentials.txt` - App details
- Any custom credential files

## GitHub Actions Integration

After creating your app:

```yaml
- name: Generate GitHub App Token
  id: app-token
  uses: actions/create-github-app-token@v1
  with:
    app-id: ${{ secrets.APP_ID }}
    private-key: ${{ secrets.APP_PRIVATE_KEY }}

- name: Use token
  run: gh api /user
  env:
    GH_TOKEN: ${{ steps.app-token.outputs.token }}
```

### Setting Secrets

```bash
# Navigate to your project
cd /path/to/your/project

# Add secrets
gh secret set APP_ID
gh secret set APP_PRIVATE_KEY < github-app-private-key.pem
```

## Example Use Cases

### Compliance Checker App

Multi-repo compliance checking with read access to multiple repositories.

**Permissions:**
- contents: read
- metadata: read

**Manifest:** `examples/compliance-checker.json`

### Code Reviewer App

PR review automation with comment and check capabilities.

**Permissions:**
- contents: read
- pull_requests: write
- checks: write

**Manifest:** `examples/code-reviewer.json`

### Release Manager App

Release and deployment automation.

**Permissions:**
- contents: write
- pull_requests: write
- checks: write

**Manifest:** `examples/release-manager.json`

## Troubleshooting

### "Bad credentials" error

- Code expires after 1 hour
- Ensure you copied the complete code
- Check for extra spaces or characters

### "Could not resolve to a Repository" error

- Verify redirect_url points to existing repo
- Check repository name and owner
- Ensure you have access to the repository

### Exchange script fails

- Install jq: `sudo apt-get install jq` or `brew install jq`
- Check internet connection
- Verify code format is correct

## Notes for AI Assistants

When working in this repository:

1. **Security First** - Never commit private keys or credentials
2. **Manifest Validation** - Ensure manifests have required fields
3. **Documentation** - Keep examples and docs in sync
4. **Script Testing** - Test scripts with sample data, not real credentials
5. **Dependencies** - Scripts require `jq` and `curl`

### Common Pitfalls

- **Don't commit credentials** - Always in .gitignore
- **Don't expose codes** - They expire but are still sensitive
- **Don't hardcode URLs** - Use manifest configuration
- **Don't skip validation** - Check manifest format before submission

### Typical Workflows

**Creating new app:**
1. Prepare manifest.json
2. Run create-app.sh
3. Follow browser prompts
4. Paste code when prompted
5. Verify credentials saved

**Adding to GitHub Actions:**
1. Create app
2. Add secrets to repo
3. Use in workflow
4. Test with API calls

## Dependencies

- **curl**: For API requests
- **jq**: For JSON parsing
- **xdg-open/open**: For browser launching
- **bash**: Shell scripts

## Documentation

### GitHub Resources

- [Manifest Flow Docs](https://docs.github.com/en/apps/sharing-github-apps/registering-a-github-app-from-a-manifest)
- [GitHub App Permissions](https://docs.github.com/en/rest/apps/permissions)
- [Authentication Guide](https://docs.github.com/en/apps/creating-github-apps/authenticating-with-a-github-app/about-authentication-with-a-github-app)

### Local Documentation

- README.md - Quick start and overview
- docs/ - Detailed guides
- examples/ - Sample manifests

## Related Repositories

- **github-repo-standards** - Repository compliance checking framework that uses GitHub Apps

## Version History

- **2025-12-03:** Repository migrated to labrats-work organization with fresh history
- **2025-12-03:** Renamed from my-gh-apps to github-app-tools
- **Previous:** Basic manifest flow tools, interactive creation script, example manifests

## Last Updated

2025-12-03
