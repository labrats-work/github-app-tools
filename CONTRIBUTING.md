# Contributing to my-gh-apps

Thank you for your interest in contributing to the my-gh-apps project! This document provides guidelines for contributing.

## How to Contribute

### Improving Scripts

The most common contribution is improving the app creation tools:

1. Fork the repository
2. Create a new branch: `git checkout -b feature/your-improvement`
3. Make your changes to the shell scripts
4. Test the scripts thoroughly (without committing real credentials)
5. Commit your changes: `git commit -m "feat: description of changes"`
6. Push to your fork: `git push origin feature/your-improvement`
7. Create a Pull Request

### Adding Example Manifests

To add new example manifests:

1. Fork the repository
2. Create a new branch: `git checkout -b examples/your-use-case`
3. Add your manifest to the `examples/` directory
4. Update README.md to reference your example
5. Commit your changes: `git commit -m "examples: add [use case] manifest"`
6. Push and create a Pull Request

### Reporting Bugs

If you find a bug:

1. Check if the issue already exists in [Issues](../../issues)
2. If not, create a new issue using the "Bug Report" template
3. Provide:
   - Clear description of the bug
   - Steps to reproduce
   - Expected vs actual behavior
   - Any relevant error messages (redact sensitive data)

### Suggesting Features

To suggest new features:

1. Create a new issue using the "Feature Request" template
2. Describe the problem and proposed solution
3. Explain the use case and benefits

## Development Guidelines

### Shell Scripts

When modifying shell scripts:

- **Test First**: Always test scripts with sample data
- **Error Handling**: Check for required dependencies (jq, curl)
- **User Feedback**: Provide clear messages for each step
- **Security**: Never log or echo credentials
- **Comments**: Add comments explaining complex logic

Example:
```bash
# Check for required dependency
if ! command -v jq &> /dev/null; then
    echo "Error: jq is required but not installed"
    exit 1
fi
```

### Manifest Examples

When adding manifest examples:

- **Complete**: Include all necessary fields
- **Documented**: Add comments explaining each permission
- **Tested**: Test the manifest before submitting
- **Specific**: Create manifests for specific, real use cases

Example:
```json
{
  "name": "CI App",
  "url": "https://github.com/username/repo",
  "description": "Automated CI/CD checks",
  "default_permissions": {
    "contents": "read",      // Read code for checks
    "checks": "write",       // Create check runs
    "pull_requests": "write" // Comment on PRs
  }
}
```

### Commit Message Format

Use clear, descriptive commit messages:

```
type: short description

Longer description if needed
```

Types:
- `feat:` - New feature
- `fix:` - Bug fix
- `examples:` - Example manifest changes
- `docs:` - Documentation changes
- `chore:` - Maintenance tasks

### Pull Request Process

1. Ensure your code follows the guidelines above
2. Update documentation if needed
3. Test your changes thoroughly
4. Describe your changes clearly in the PR description
5. Wait for review from maintainers

## Security Considerations

**IMPORTANT**: Never commit sensitive data:

- No private keys (`.pem` files)
- No credentials (app IDs, secrets, tokens)
- No real codes from GitHub redirects
- Sanitize any examples or error messages

The following are gitignored:
- `*.pem`
- `*credentials.txt`
- `*-private-key.pem`

## Testing Guidelines

### Testing Scripts

To test shell scripts:

1. **Dry Run**: Read through the code without executing
2. **Sample Data**: Use fake/test manifests
3. **Error Cases**: Test error handling (missing deps, bad input)
4. **Cleanup**: Verify no sensitive data is left behind

### Testing Manifests

To test manifest examples:

1. **Validate JSON**: Ensure valid JSON format
2. **Required Fields**: Check all required fields are present
3. **Permissions**: Verify permissions match use case
4. **Test Creation**: Actually create an app with the manifest (then delete it)

## Code of Conduct

### Our Standards

- Be respectful and constructive
- Welcome newcomers
- Focus on what's best for the project
- Show empathy towards others

### Unacceptable Behavior

- Harassment or discrimination
- Trolling or insulting comments
- Publishing others' private information
- Other unprofessional conduct

## Questions?

If you have questions:

- Create an issue with the "question" label
- Check existing documentation in `docs/`
- Review [CLAUDE.md](CLAUDE.md) for technical details

## Documentation

When contributing, update relevant documentation:

- **README.md** - User-facing documentation
- **CLAUDE.md** - Technical context for AI assistants
- **docs/** - Detailed guides and tutorials
- **examples/** - Manifest examples with explanations

## Dependencies

This project uses minimal dependencies:

- **bash** - Shell scripts
- **curl** - API requests
- **jq** - JSON parsing
- **xdg-open/open** - Browser launching

When adding features, prefer:
- Standard tools over new dependencies
- Built-in commands over external packages
- Simple solutions over complex ones

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
