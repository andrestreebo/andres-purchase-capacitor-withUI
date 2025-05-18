# Contributing to @revenuecat/purchases-capacitor-ui

Thank you for your interest in contributing to the RevenueCat Capacitor UI SDK!

## Development Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/andrestreebo/andres-purchase-capacitor-withUI.git
   cd andres-purchase-capacitor-withUI
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Build the project:
   ```bash
   npm run build
   ```

## Testing Your Changes

You can test your changes in a Capacitor app by linking the package locally:

```bash
# In the plugin directory
npm link

# In your app directory
npm link @revenuecat/purchases-capacitor-ui
npx cap sync
```

## Code Style

We use ESLint and Prettier to enforce code style. Before submitting a PR, make sure your code passes the linting checks:

```bash
npm run lint
npm run fmt # to automatically fix issues
```

## Submitting a Pull Request

1. Create a branch for your changes:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. Make your changes and commit them with clear, descriptive messages.

3. Push your branch to GitHub:
   ```bash
   git push origin feature/your-feature-name
   ```

4. Open a pull request against the main branch.

## Release Process

The release process is managed by RevenueCat team members. If you're a contributor, you don't need to worry about this part.

## Questions?

If you have any questions about contributing, please contact the RevenueCat team.

Thank you for your contribution! 