# Documentation

Documentation for my-gh-apps GitHub App creation tools.

## Quick Links

- [Back to Main README](../README.md)
- [Repository Context](../CLAUDE.md)
- [Example Manifests](../examples/)

## Overview

This repository provides tools for creating GitHub Apps using the manifest flow, which automates the registration process and credential management.

## Guides

### Creating a GitHub App

1. Prepare your `manifest.json` file
2. Run `./create-app.sh manifest.json`
3. Follow the browser prompts
4. Paste the code from the redirect URL
5. Credentials are automatically saved

### Using in GitHub Actions

After creating your app, add the credentials to GitHub Secrets and use the `actions/create-github-app-token` action in your workflows.

## Resources

- [GitHub Manifest Flow Documentation](https://docs.github.com/en/apps/sharing-github-apps/registering-a-github-app-from-a-manifest)
- [GitHub App Permissions](https://docs.github.com/en/rest/apps/permissions)
- [Authentication Guide](https://docs.github.com/en/apps/creating-github-apps/authenticating-with-a-github-app)
