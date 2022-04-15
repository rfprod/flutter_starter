# Security

## Dependencies audit

From time to time it's reasonable to update the project dependencies which might have security fixes along with functional improvements.

Use the following command to work with the project dependencies

```bash
flutter pub --help
```

### Automated (CI)

The dependencies audit procedure should be automated by leveraging tools like [Dependabot](https://github.com/dependabot), or [GitHub Actions](https://github.com/features/actions) in conjunction with [Snyk](https://snyk.io/) and similar tools.

The dependabot Dart support is in beta. The documentation references:

- https://docs.github.com/en/code-security/dependabot/dependabot-version-updates/configuring-dependabot-version-updates#enabling-dependabot-version-updates
- https://github.blog/changelog/2022-04-05-pub-beta-support-for-dependabot-version-updates/

## Code scanning

Source code should be regularly checked for vulnerabilities by leveraging [GitHub Actions](https://github.com/features/actions) with tools like [CodeQL](https://codeql.github.com/) and similar. See more here [CodeQL Action](https://github.com/github/codeql-action)

The CodeQL does not support Dart/Flutter yet. The documentation references:

- https://github.com/github/codeql-action
- https://codeql.github.com/docs/codeql-overview/supported-languages-and-frameworks/

## Shell scripts

Always inspect shell scripts before executing it on your machine.
