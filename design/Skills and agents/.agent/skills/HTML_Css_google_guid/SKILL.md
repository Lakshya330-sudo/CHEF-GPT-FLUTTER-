---
name: HTML_Css_google_guid
description: This skill enforces the Google HTML/CSS Style Guide principles for HTML and CSS development. Use this skill when asked to review, refactor, or write HTML and CSS code, or when you need to adhere to Google's design system and styling standards.
---

# Google HTML/CSS Style Guide

This skill ensures adherence to the official [Google HTML/CSS Style Guide](https://google.github.io/styleguide/htmlcssguide.html). When developing web interfaces or writing HTML/CSS code, strictly apply the following principles:

## General Principles
- **Protocol**: Always use HTTPS (`https:`) for embedded resources like images, scripts, and stylesheets.
- **Indentation**: Indent by exactly 2 spaces at a time. Do not use tabs or mix tabs and spaces.
- **Capitalization**: Use only lowercase code. This applies to HTML element names, attributes, CSS selectors, properties, and values (excluding strings).
- **Trailing Whitespace**: Remove trailing white spaces.
- **Encoding**: Use UTF-8 (no BOM) via `<meta charset="utf-8">`.
- **Comments & Todos**: Explain code as needed and use `TODO:` for action items (e.g., `<!-- TODO: Revisit layout -->`).

## HTML Guidelines
- **Document Type**: Always use `<!doctype html>` to ensure no-quirks mode rendering.
- **Validity**: Write valid HTML according to W3C standards where possible.
- **Semantics**: Use HTML elements according to their intended purpose (e.g., use `<a>` for links, not `<div onclick="...">`, and appropriate `<p>` and `<h1-6>` tags).
- **Multimedia Fallback**: Provide meaningful `alt` text for images. For purely decorative images, use `alt=""`.
- **Separation of Concerns**: Keep structure (HTML), styling (CSS), and behavior (JS) strictly separated. Avoid inline styles and unnecessary inline scripts.
- **Optional Tags**: Omit optional tags (like `</html>` or `</body>`) if optimizing for file size, though for clarity they are often retained. Prefer clean, minimalist markup.

## CSS Guidelines
- **Validity**: Write valid CSS according to W3C standards.
- **Class Naming**: Use meaningful, functional, or generic class names (`.nav`, `.author`, `.login`) rather than presentational ones (`.button-green`).
- **Class Style**: Use brief but descriptive class names (short as possible, long as necessary).
- **Delimiters**: Separate words in class names with a hyphen (`-`). Do not use camelCase or underscores.
- **Type Selectors**: Avoid qualifying class names with element type selectors (e.g., use `.example` instead of `ul.example`) for better performance.
- **ID Selectors**: Avoid ID selectors (`#example`). Use class selectors instead to ensure reusability and component uniqueness.
- **Shorthand**: Use shorthand properties (e.g., `font`, `margin`, `padding`, `background`) wherever possible to reduce stylesheet size.
- **Zero Values**: Do not use units after 0 values (e.g., `margin: 0;`, not `margin: 0px;`).
- **Quotes**: Prefer single quotes (`'`) over double quotes (`"`) for strings and URI values in CSS.

## Application
When prompted to use this skill, or when specifically asked to follow Google's HTML/CSS guidelines, automatically review and format your generated code to meet these criteria.
