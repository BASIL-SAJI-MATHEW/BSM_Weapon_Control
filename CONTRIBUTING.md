# Contributing to BSM Weapon Control System

Thank you for your interest in contributing to the **BSM Weapon Control System**! This document serves as a set of rules and guidelines to ensure that your contributions are effective and align with the project's standards.

## How Can I Contribute?

### Reporting Bugs
If you spot a bug or performance issue, let us know!
1. Check existing issues to see if it's already reported.
2. Open a new issue using our `Bug Report` template.
3. Include your framework version, ox_lib/ox_inventory versions, and clear reproduction steps.

### Requesting Features
Have an idea that would make this script even better?
1. Open a new issue using the `Feature Request` template.
2. Be descriptive! Tell us exactly what the feature is, why it's needed, and how it aligns with the script's premium nature.

### Pull Requests (Code Contributions)
If you've fixed a bug or added a feature:
1. Fork the repository.
2. Create a new branch: `git checkout -b feature/my-new-feature` or `bugfix/issue-123`.
3. Make your changes. **Ensure you keep the BSM watermark `-- BSM | Basil Saji Mathew` untouched at the top of any modified Lua/SQL file.**
4. Test your code internally on ESX or QBCore to prevent compatibility breaks.
5. Create a Pull Request (PR) against the `main` branch.
6. Fill out the PR template completely.

## Code Standards
- **Wait Optimization**: Do NOT use `Wait(0)` in loops unless strictly necessary (which it usually isn't). Default sleep timers should be `Wait(1000)` and reduce to `Wait(5)` during active engagement.
- **Modularity**: Place framework-specific code in `server/framework.lua` or use specific exports. Do not clutter `main.lua` with native framework calls if possible.
- **Prefixes**: New Custom UI/Events must use `bsm_weapon_control:` prefix to avoid clashes.

If you respect these guidelines, we look forward to merging your PR!
