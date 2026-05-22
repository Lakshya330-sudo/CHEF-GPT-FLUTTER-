---
name: ui-ux-design-principles
description: Helps with applying fundamental user interface (UI) and user experience (UX) principles, laws of psychology, visual design rules, and accessibility standards to create effective digital products.
---

# UI/UX Design Principles

This skill provides comprehensive instructions on how to design and evaluate digital products utilizing industry-standard UI and UX design principles. User Interface (UI) design focuses on the visual aesthetics, including colors, typography, alignment, and spacing. User Experience (UX) design focuses on how the product feels, ensuring that it is logical, smooth, intuitive, and effectively solves the user's problems. To design successfully, you must synthesize visual hierarchy, psychological laws of user behavior, structural layouts, and accessibility constraints.

A foundational concept to follow is **Atomic Design**, which breaks interfaces down into hierarchical building blocks:
*   **Atoms:** Basic building blocks like input fields, buttons, and labels.
*   **Molecules:** Groups of atoms functioning together, such as a search bar (input field + button).
*   **Organisms:** Complex UI components made of molecules and atoms, like a complete website header.
*   **Templates/Wireframes:** The structural blueprint or layout of the page where organisms are placed.
*   **Pages:** The final, high-fidelity design populated with real content.

## When to use this skill

- Use this when generating wireframes, low-fidelity prototypes, or high-fidelity UI mockups for mobile apps, websites, or software dashboards.
- Use this when assessing or auditing an existing design for usability, cognitive load, visual hierarchy, or accessibility.
- This is helpful for structuring information architecture, defining component states (like hover, focus, or error), and establishing design systems or brand guidelines.
- This is helpful for ensuring designs are inclusive and comply with the Web Content Accessibility Guidelines (WCAG).

## How to use it

Follow these step-by-step guidelines, conventions, and patterns to create functional, aesthetically pleasing, and highly usable digital interfaces.

### 1. Apply Core Visual Design Fundamentals
*   **Visual Hierarchy:** Direct the user's eyes to the most important elements first. Use scale (e.g., larger font sizes for headlines) and boldness to establish priorities between headlines, sub-headlines, and body text.
*   **Contrast:** Ensure elements stand out clearly against their backgrounds. Follow the WCAG standard ratio of at least 4.5:1 for normal text readability. Use contrast to highlight primary calls to action (CTAs) over secondary buttons.
*   **Alignment:** Organize elements along invisible grid lines. Consistent vertical and horizontal alignment creates a structured, harmonious layout. Stick to either left, center, or right alignment within a given group to avoid a disjointed look. 
*   **Proximity (Grouping):** Group related elements together. Elements placed in close proximity naturally create a visual connection, indicating they are related to the same piece of information.
*   **Whitespace (Negative Space):** Utilize empty space between elements to let the design breathe and prevent clutter. Adjust vertical and horizontal spacing to clearly separate different sections. Use an 8-pixel grid system for consistent padding and margins.
*   **Typography:** Keep typography simple and legible. Avoid using too many typefaces (stick to one or two) and establish consistent font sizes (e.g., minimum 14px for body text, 12px for captions). Avoid mixing styles needlessly and ensure appropriate line height.
*   **Color Usage:** Follow the 60-30-10 rule: 60% dominant color, 30% secondary color, and 10% accent color (used for critical elements like buttons). Maintain brand consistency and avoid pairing mid-tone grays directly next to vibrant colors.

### 2. Implement Laws of UX and Psychology
*   **Hick's Law:** The time it takes to make a decision increases as the number of choices increases. Keep options minimal to reduce cognitive load.
*   **Fitts's Law:** The time required to click a target depends on its size and distance. Make important buttons large and easy to reach. Touch targets should be at least 44x44 pixels (iOS standard) or 48x48 pixels (Android standard) to avoid "fat finger" errors.
*   **Miller's Law:** The average person can only keep 7 (plus or minus 2) items in their working memory. Group information into smaller chunks rather than displaying massive lists all at once.
*   **Jakob's Law:** Users spend most of their time on other sites and prefer your site to work the same way as the ones they already know. Stick to recognizable patterns (e.g., hamburger menus, standard e-commerce carts).
*   **Von Restorff Effect (Isolation Effect):** When multiple similar objects are present, the one that differs visually is most likely to be remembered. Use this to isolate and highlight your primary CTA.
*   **Progressive Disclosure:** Gradually reveal complex features or information only as the user needs them. Hide secondary settings behind "read more" buttons, menus, or tabs to keep the interface uncluttered.

### 3. Ensure Accessibility (WCAG Compliance) and Inclusivity
*   **Perceivable:** Users must be able to perceive the content. Provide alt-text for images to aid screen readers and add captions for videos. Do not rely on color alone to convey important information (e.g., use an icon and an error message text alongside a red border).
*   **Operable:** Ensure the interface can be navigated by various input methods, not just a mouse. Implement logical tab orders and clearly define focus states for keyboard-only users. Avoid interactions that rely exclusively on device motion or hover states, as mobile users cannot hover.
*   **Understandable:** Use clear, simple instructions and avoid technical jargon. Provide consistent navigation and layout patterns. When an error occurs, provide direct, contextual feedback near the specific field (e.g., "Please enter a valid email address").
*   **Robust:** Designs must be built using semantic structure (e.g., proper H1, H2 tags) so that assistive technologies, like screen readers, can reliably interpret the layout.

### 4. Optimize Forms, Components, and Responsiveness
*   **Form Elements:** Ensure text fields have a designated label, adequate inner padding, and explicitly designed interaction states: Default, Focus (highlighted border indicating active typing), and Error (red outline with clear descriptive text). Ensure checkboxes and radio buttons share the same styling language as text fields.
*   **Responsive Design:** When scaling designs down from desktop to tablet or mobile, collapse multiple columns into single stacked rows. Tuck overflowing navigation links into hamburger menus to save horizontal space. Decrease padding, margins, and extremely large typography to suit smaller screens appropriately.
*   **Micro-interactions:** Enhance user feedback through small, subtle animations. Use hover effects, loading spinners, or button color changes to signify system status immediately after user input.
