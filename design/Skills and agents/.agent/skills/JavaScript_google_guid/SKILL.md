---
name: JavaScript_google_guid
description: This skill enforces the Google JavaScript Style Guide principles for JavaScript and TypeScript development. Use this skill when asked to review, refactor, or write JavaScript code, or when you need to adhere to Google's engineering standards.
---

# Google JavaScript Style Guide

This skill ensures adherence to the official [Google JavaScript Style Guide](https://google.github.io/styleguide/jsguide.html). When developing JavaScript (or TypeScript) code, strictly apply the following principles:

## Formatting and Linting
- **Indentation**: Use 2 spaces for indentation. Do not use tabs.
- **Braces and Blocks**: Use K&R style (Egyptian brackets) with no line break before the opening brace, and a line break after it. 
- **Control Structures**: Braces are required for all control structures (e.g., `if`, `else`, `for`, `while`), even for single-line statements, unless the entire `if` statement fits on a single line.
- **Column Limit**: Keep lines to a maximum of 80 characters when possible.
- **Whitespace**: Keep trailing whitespace clean and empty.

## Naming Conventions
- **Classes, Interfaces, Enums, and Typedefs**: Use `UpperCamelCase`.
- **Variables, Parameters, and Functions**: Use `lowerCamelCase`.
- **Constants**: Use `CONSTANT_CASE` (all uppercase letters separated by underscores) for deeply immutable static properties and module-local variables. Ensure they are truly constant in state, not just reassignment.
- **Enum Items**: Individual items within an enum are named in `CONSTANT_CASE`.
- **Packages/Namespaces**: LowerCamelCase is used (e.g., `my.package.name`).
- **Private Properties/Methods**: May optionally be documented using trailing underscores (e.g., `privateMethod_()`) or standard `#` private syntax, though standard conventions apply based on the specific module system.

## Language Features
- **Variable Declarations**: Declare local variables with `const` or `let`; do not use `var`. Prefer `const` unless the variable needs to be reassigned.
- **Strings**: Use single quotes (`'`) or template literals (`` ` ``) for strings. Avoid double quotes (`"`) unless the string itself contains a single quote.
- **Array and Object Literals**: Optionally format as block-like constructs (with a trailing comma if multiline). Increase indentation by 2 spaces for each level.
- **Functions vs Classes**: Use ES6 `class` syntax for classes instead of traditional prototype manipulation. Prefer arrow functions (`=>`) when binding `this` or for short anonymous functions.
- **Modules**: Use ES Modules (`import`/`export`) or Google's `goog.module`/`goog.require` constructs depending on the system type.

## Comments and Types
- **JSDoc**: Document classes, methods, and complex functions with JSDoc annotations to specify types and parameters (e.g., `@param {string} a`, `@return {number}`).

## Application
When prompted to use this skill, or when specifically asked to follow Google's JavaScript guidelines, automatically review and format your generated code to meet these criteria.
