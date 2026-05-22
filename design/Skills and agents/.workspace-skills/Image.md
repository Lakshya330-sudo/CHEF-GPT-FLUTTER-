---
name: generating-images
description: Generates images, mockups, design assets, and visual materials for the specific project. Use this skill when the user asks to create an image, mockup, or asset.
---

# Image Generation Skill

This skill provides guidelines and context for creating visually stunning and project-appropriate images, mockups, and assets.

## Core Capabilities
- **Mockups**: Generating device mockups (though remember: default to generating interfaces *without* device frames unless the user explicitly requests them).
- **Assets**: Creating icons, background images, illustrations, or placeholder photos.
- **Design Explorations**: Visualizing concepts before implementing them in code.

## How to use the 'generate_image' Tool
1. **Understand Requirements**: Clarify what the user needs (style, colors, subject, layout). Ensure you consider any overarching project themes or visual guidelines (like specific color palettes).
2. **Craft the Prompt**: 
   - Write highly detailed prompts for the image generation model.
   - Specify art style (e.g., "minimalist 3D render", "flat vector illustration", "photorealistic").
   - Mention lighting, composition, and key colors.
3. **Execute**: Use the `generate_image` tool with a descriptive, underscore_separated `ImageName` (max 3 words, e.g., `hero_background_asset`).
4. **Present the Result**: Show the generated image to the user and ask if they need variations or edits.

## Edit / Combine Images
- If the user provides an existing image or wants to modify a previously generated one, utilize the `ImagePaths` argument in the `generate_image` tool to pass the images as context for the edit.

## Project Guidelines
- **Always prioritize high quality**: Use modern aesthetics. Avoid generic layouts.
- **Match the vibe**: If the user is building a professional dashboard, create sleek, geometric imagery. If they are building a playful app, use vibrant, soft shapes.
