# Security Policy

## Security Scanning

This project uses multiple security scanning tools:

- **npm audit**: Package vulnerability scanning
- **Snyk**: Advanced dependency and container scanning
- **Semgrep**: Static Application Security Testing (SAST)
- **Trivy**: Container image vulnerability scanning

## Known Vulnerabilities

### Frontend Dependencies (Vite + React)

The frontend uses **Vite 7.1.4** (latest stable) with React 18, which provides:
- ✅ Modern, actively maintained tooling
- ✅ Fast development and build times
- ✅ Security vulnerabilities mitigated via overrides

#### esbuild Security (GHSA-67mh-4wv8-2f99)

- **Status**: Mitigated via `package.json` overrides (forced to `^0.25.0`)
- **Impact**: Low - only affects development server CORS settings
- **Fix**: esbuild >= 0.25.0 fixes the vulnerability
- **Reference**: [GHSA-67mh-4wv8-2f99](https://github.com/advisories/GHSA-67mh-4wv8-2f99)

The project uses npm `overrides` to ensure esbuild >= 0.25.0 is used:

```json
"overrides": {
  "esbuild": "^0.25.0"
}
```

All dependencies are regularly audited and updated. Run `npm audit` to check for any new vulnerabilities.

### Verification

To verify that overrides are working:

```bash
cd frontend
rm -rf node_modules package-lock.json
npm install
npm audit
```

## Reporting Security Issues

If you discover a security vulnerability, please:

1. **Do NOT** open a public issue
2. Email security concerns to the project maintainers
3. Include:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

## Security Updates

- Security scans run automatically on every commit via CI/CD
- Dependencies are regularly updated
- Container images are scanned before deployment
- All security findings are reviewed and addressed

## Best Practices

- Never commit `.env` files or secrets
- Use environment variables for sensitive configuration
- Keep dependencies up to date
- Review security scan results regularly
- Use `npm audit fix` for automatic vulnerability fixes when possible
