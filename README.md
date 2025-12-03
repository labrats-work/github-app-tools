# my-gh-apps

Tools and utilities for creating and managing GitHub Apps using the manifest flow.

## Purpose

This repository provides a streamlined way to create GitHub Apps using GitHub's [manifest flow](https://docs.github.com/en/apps/sharing-github-apps/registering-a-github-app-from-a-manifest), which automates:
- App registration
- Private key generation
- Permission configuration
- Credential management

## Quick Start

### Create a GitHub App from Manifest

**1. Prepare your manifest**

Create a `manifest.json` file with your app configuration:

```json
{
  "name": "Your App Name",
  "url": "https://github.com/tomp736/your-repo",
  "description": "Your app description",
  "hook_attributes": {
    "url": "https://example.com/webhook"
  },
  "redirect_url": "https://github.com/tomp736/your-repo",
  "public": false,
  "default_permissions": {
    "contents": "read",
    "issues": "write"
  },
  "default_events": []
}
```

**2. Use the setup tool**

```bash
./create-app.sh manifest.json
```

This will:
1. Open GitHub in your browser with the manifest
2. Wait for you to confirm the app creation
3. Prompt you to paste the code from the redirect URL
4. Automatically exchange the code for credentials
5. Save everything securely

## Structure

```
my-gh-apps/
├── create-app.sh           # Interactive app creation script
├── exchange-code.sh        # Standalone credential exchange script
├── examples/               # Manifest examples for different use cases
├── docs/                   # Documentation and guides
│   ├── README.md           # Documentation overview
│   └── adr/                # Architecture Decision Records
├── .github/
│   ├── ISSUE_TEMPLATE/     # Issue templates
│   └── workflows/          # CI/CD automation
├── CLAUDE.md               # Repository context for AI
├── CONTRIBUTING.md         # Contribution guidelines
├── SECURITY.md             # Security policy
└── LICENSE                 # MIT License
```

## Tools Included

### `create-app.sh`

Interactive script that guides you through creating a GitHub App:
- Opens browser with manifest submission
- Exchanges code for credentials
- Saves private key and app details
- Provides next steps

**Usage:**
```bash
./create-app.sh path/to/manifest.json
```

### `exchange-code.sh`

Standalone script to exchange a manifest code for credentials:

**Usage:**
```bash
./exchange-code.sh YOUR_CODE_HERE
```

**Output:**
- App ID
- App slug
- Private key (saved to `github-app-private-key.pem`)
- Webhook secret
- Client credentials
- Summary file (`github-app-credentials.txt`)

### `setup-template.html`

Generic HTML template for browser-based app creation. Customize the manifest JSON in the script tag.

## Manifest Reference

Common manifest configurations for different use cases.

### Read-Only Repository Access

```json
{
  "name": "Repo Reader",
  "default_permissions": {
    "contents": "read",
    "metadata": "read"
  }
}
```

### CI/CD App

```json
{
  "name": "CI App",
  "default_permissions": {
    "contents": "read",
    "checks": "write",
    "pull_requests": "write"
  },
  "default_events": ["push", "pull_request"]
}
```

### Issue Manager

```json
{
  "name": "Issue Bot",
  "default_permissions": {
    "issues": "write",
    "metadata": "read"
  },
  "default_events": ["issues", "issue_comment"]
}
```

## Security

- Private keys are saved to `.pem` files (in `.gitignore`)
- Credentials are saved to `.txt` files (in `.gitignore`)
- **Never commit these files to git**
- Delete local copies after adding to GitHub Secrets

## GitHub Actions Integration

After creating your app, add these secrets to your repository:

```bash
# Navigate to your project repo
cd /path/to/your/project

# Add secrets (you'll be prompted for values)
gh secret set APP_ID
gh secret set APP_PRIVATE_KEY < github-app-private-key.pem
```

Use in workflows:

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

## Examples

See the `examples/` directory for complete manifest examples:
- `compliance-checker.json` - Multi-repo compliance checking
- `code-reviewer.json` - PR review automation
- `release-manager.json` - Release and deployment automation

## Documentation

- [GitHub App Manifest Flow](https://docs.github.com/en/apps/sharing-github-apps/registering-a-github-app-from-a-manifest)
- [GitHub App Permissions](https://docs.github.com/en/rest/apps/permissions)
- [Authenticating with GitHub Apps](https://docs.github.com/en/apps/creating-github-apps/authenticating-with-a-github-app/about-authentication-with-a-github-app)

## Troubleshooting

### "Bad credentials" error
- Ensure the code hasn't expired (1 hour limit)
- Verify you copied the complete code from the URL

### "Could not resolve to a Repository" error
- Check the redirect URL in your manifest matches an existing repo
- Verify the repository name and owner are correct

### Exchange script fails
- Ensure `jq` is installed: `sudo apt-get install jq` or `brew install jq`
- Check your internet connection
- Verify the code format is correct

## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## Security

For security concerns, please see [SECURITY.md](SECURITY.md).

## License

MIT License - see [LICENSE](LICENSE) file for details.

---

**Last Updated:** 2025-12-01
**Status:** Active
