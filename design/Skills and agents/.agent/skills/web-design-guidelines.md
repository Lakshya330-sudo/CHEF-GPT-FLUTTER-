# Web Interface Guidelines

Review UI code for compliance with these high-performance, accessible web interface standards.

## Core Rules

### Focus & Interaction
- **Focus States**: Visible focus needed (`focus-visible:ring-*`). Never use `outline-none` without replacement.
- **Touch**: `touch-action: manipulation` to prevent zoom delay. `overscroll-behavior: contain` in modals.
- **Hover**: Buttons/links need clear `:hover` states for feedback.

### Forms & Input
- **Accessibility**: Inputs MUST have `autocomplete`, meaningful `name`, and associated labels.
- **UX**: Never block paste. Submit buttons should show a spinner and disable only after request starts. Placeholders end with `…`.
- **Validation**: Inline errors next to fields; focus the first error on submit.

### Performance & Loading
- **Images**: Always specify `width` and `height` to prevent CLS. Lazy load below-fold images.
- **Virtualization**: Use for lists > 50 items.
- **DOM**: Avoid layout thrashing (interleaving reads/writes).

### Typography & Content
- **Characters**: Use `…` (ellipsis) and curly quotes (`“”`). Non-breaking spaces for units (`10 MB`).
- **Layout**: Use `text-wrap: balance` for headings. Handle long content with `truncate` or `line-clamp`.
- **Active Voice**: Use "Install CLI" instead of "The CLI will be installed".

### Anti-patterns to Flag
- `user-scalable=no` (prevents accessibility zoom).
- `transition: all` (inefficient, list properties explicitly).
- Inline `onClick` navigation without `<a>`.
- Icon buttons without `aria-label`.

## Output Format
Group findings by file using the `file:line` format for easy navigation.
