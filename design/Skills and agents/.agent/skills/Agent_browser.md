# Agent Browser

Browser automation for AI agents via [inference.sh](https://inference.sh). Uses Playwright under the hood with a simple @e ref system for element interaction.

## Core Workflow
Every browser automation follows this pattern:
1. **Open** - Navigate to URL, get `@e` refs for elements
2. **Interact** - Use refs to click, fill, drag, etc.
3. **Re-snapshot** - After navigation/changes, get fresh refs
4. **Close** - End session (returns video if recording)

## Functions
- `open`: Start a new session and navigate to a URL.
- `snapshot`: Get fresh element references and a screenshot.
- `interact`: Perform actions like click, fill, hover, etc.
- `screenshot`: Capture a screenshot of the page.
- `execute`: Run custom JavaScript in the browser.
- `close`: End the session and retrieve recorded video.

## Interact Actions
- `click(ref)`: Click an element by its `@e` reference.
- `fill(ref, text)`: Fill a text input or textarea.
- `press(text)`: Press a key (e.g., "Enter").
- `scroll(direction, amount)`: Scroll the page.
- `upload(ref, file_paths)`: Upload files.
- `drag(ref, target_ref)`: Drag and drop elements.

## Element Refs
Elements are returned with `@e` refs:
`@e1 [a] "Home" href="/" @e2 [input] placeholder="Search"`

**Important**: Refs are invalidated after navigation. Always re-snapshot after actions that change the page state.

## Features
- **Video Recording**: Enable `record_video` in `open` to get a video file on `close`.
- **Cursor Indicator**: Visible red dot for demonstrations.
- **Proxy Support**: Route traffic through proxy servers.
