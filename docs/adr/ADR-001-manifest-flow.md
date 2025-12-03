# ADR-001: Use GitHub Manifest Flow for App Creation

## Status

Accepted

## Context

Creating GitHub Apps requires multiple manual steps:
- Navigate to GitHub Settings
- Fill out numerous form fields
- Configure permissions manually
- Generate and download private key
- Copy app ID and other credentials

This process is time-consuming, error-prone, and difficult to reproduce.

## Decision

We will use GitHub's [manifest flow](https://docs.github.com/en/apps/sharing-github-apps/registering-a-github-app-from-a-manifest) for creating GitHub Apps.

**Implementation:**
- Manifest JSON files define app configuration
- Scripts automate browser interaction
- Code exchange handled automatically
- Credentials saved locally
- Process is reproducible and version-controlled

## Consequences

### Positive

- **Automation:** App creation reduced to single command
- **Reproducible:** Manifest files can be version controlled
- **Fast:** No manual form filling
- **Consistent:** Same configuration every time
- **Shareable:** Manifests can be shared as examples
- **Scriptable:** Can be integrated into automation workflows

### Negative

- **Initial Learning:** Manifest format must be learned
- **Browser Interaction:** Still requires browser confirmation
- **Code Expiry:** Exchange code expires after 1 hour
- **Manual Step:** Must copy code from redirect URL

### Neutral

- **Credential Management:** Still need to manage private keys securely
- **One-Time Setup:** Only needed when creating new apps
