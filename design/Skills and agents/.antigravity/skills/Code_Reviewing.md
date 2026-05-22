---
name: code-reviewing
description: Analyzes code for mistakes, bugs, logic errors, and anti-patterns. Use when the user asks to review their code, find mistakes, or debug an issue.
---

# Code Reviewing Skill

When you are asked to review code or find mistakes, follow this comprehensive checklist to provide high-quality feedback.

## 1. Correctness & Logic
- **Does the code fulfill its intended purpose?** Ensure the logic aligns with the stated goals.
- **Are there any obvious bugs?** Look for off-by-one errors, infinite loops, null pointer exceptions, or incorrect arithmetic.
- **Are edge cases handled?** Check how the code handles empty inputs, extremely large values, or unexpected data types.
- **State Management:** Is the state properly managed? Are there race conditions or state desyncs?

## 2. Security & Stability
- **Is user input sanitized?** Look for potential injection vulnerabilities (XSS, SQLi, command injection).
- **Are secrets hardcoded?** Ensure no API keys, passwords, or sensitive data are directly embedded in the codebase.
- **Error Handling:** Are exceptions caught and handled gracefully? Does the app crash on unexpected input?

## 3. Style & Maintainability
- **Naming Conventions:** Are variables and functions named descriptively? Do they follow the language's standard conventions (e.g., camelCase vs snake_case)?
- **Code Duplication (DRY):** Are there repeated blocks of code that could be extracted into a reusable function or component?
- **Readability:** Is the code overly complex? Can it be simplified? Are comments used effectively to explain *why* something is done, rather than *what* is done?
- **Modularity:** Is the code loosely coupled? Do functions follow the Single Responsibility Principle?

## 4. Performance
- **Algorithmic Efficiency:** Are there unnecessary nested loops (e.g., O(N^2) instead of O(N))?
- **Resource Leaks:** Are network requests, file handles, or event listeners properly closed or removed when no longer needed?

## How to Provide Feedback
When presenting your findings to the user:
1. **Be constructive:** Focus on the code, not the coder.
2. **Prioritize:** Highlight critical bugs or security flaws first, then move to style and performance suggestions.
3. **Show, don't just tell:** Provide an example of how the code can be improved using a diff block or a rewritten function.
4. **Explain the "Why":** Help the user learn by explaining why a certain approach is better or why their code might fail.
