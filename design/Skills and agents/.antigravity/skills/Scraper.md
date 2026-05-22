---
name: web-scraper
description: Scrapes and analyzes any public URL to extract structured insights about its content, purpose, structure, and key data. Use this skill when the user provides a website link and wants a summary, breakdown, or analysis of what the page contains. Ideal for research, competitive analysis, content audits, or quick page overviews.
---

# Web Scraper Skill

This skill fetches a given URL using the `web_fetch` tool and transforms the raw page content into a clean, structured markdown report. It is designed to work across a wide variety of websites — blogs, landing pages, documentation sites, e-commerce stores, news articles, and more.

---

## When to Use This Skill

- Use this when the user shares a URL and asks "what's on this page?", "summarize this site", or "scrape this for me."
- Use this for competitive research, content summarization, or extracting structured data from a webpage.
- Use this when the user wants to understand a site's structure, key messaging, or notable content without visiting it themselves.
- This is helpful for auditing landing pages, reviewing documentation, or pulling product/pricing information.

---

## How to Use It

### Step 1 — Fetch the Page

Use the `web_fetch` tool with the provided URL. Always pass the URL exactly as given by the user.

```
web_fetch(url="https://example.com")
```

If the page links to important sub-pages (e.g., /pricing, /about, /docs), fetch those as well to build a more complete picture.

### Step 2 — Analyze the Content

After fetching, examine the raw content for the following dimensions:

| Dimension | What to Look For |
|---|---|
| **Purpose** | What is this site/page trying to do? (sell, inform, document, entertain) |
| **Main Content** | Key headings, body text, articles, product listings, etc. |
| **Structure** | Navigation links, sections, page hierarchy |
| **Key Data** | Prices, dates, statistics, names, contact info, calls to action |
| **Technology Hints** | Frameworks, platforms, or tools mentioned in the content |
| **Audience** | Who is the intended reader or customer? |

### Step 3 — Produce a Structured Report

Output the results using the report template below. Adapt sections based on what is actually present on the page — omit sections that are not relevant and add new ones if something notable is found.

---

## Output Report Template

Use this structure when presenting scraped results to the user:

```markdown
## 🌐 Scraped Report: [Page Title or Domain]

**URL:** https://example.com  
**Fetched:** [Today's date]  
**Page Type:** Blog Post / Landing Page / Documentation / E-commerce / News / Other

---

### 📌 Summary
A 2–4 sentence plain-English summary of what this page is and what it does.

---

### 🗂️ Page Structure
- **Main Sections:** List the key headings or content areas found on the page
- **Navigation Links:** Key links present in the nav or sidebar
- **Page Depth:** Single page or entry point to a larger site?

---

### 📝 Key Content
Summarize the most important content found on the page. This may include:
- Featured articles or posts
- Product or service descriptions
- Core arguments or value propositions
- Notable quotes or statistics

---

### 📊 Extracted Data Points
Present specific, factual data found on the page in a table where possible:

| Field | Value |
|---|---|
| Author / Publisher | ... |
| Date Published / Updated | ... |
| Price(s) | ... |
| Contact Info | ... |
| CTA (Call to Action) | ... |

*(Omit rows not found on the page)*

---

### 🔗 Notable Links
List any important outbound or internal links discovered:
- [Link Text](URL) — brief note on where it leads

---

### 💡 Insights & Observations
2–5 concise observations that add value beyond just listing content. Examples:
- "The page is clearly optimized for lead generation, with three separate email capture forms."
- "Pricing is not publicly listed — users are redirected to a contact form."
- "The documentation is versioned, suggesting an active open-source project."

---

### ⚠️ Limitations
Note anything that may have affected scraping quality:
- Page requires authentication
- Content is JavaScript-rendered and may be incomplete
- Paywalled sections were not accessible
```

---

## Conventions & Best Practices

**Be selective, not exhaustive.** Don't dump the entire raw text of a page. Extract what is meaningful and discard boilerplate (cookie banners, footer legal text, repetitive nav items).

**Adapt the report to the page type.** A news article report should highlight the author, date, and article body. An e-commerce page report should highlight product names, prices, and reviews. A SaaS landing page report should highlight the value proposition, pricing tiers, and CTAs.

**Fetch sub-pages when it adds value.** If the user asks to scrape a whole site or the landing page links to a `/pricing` or `/about` page, proactively fetch those too and incorporate findings.

**Flag access issues clearly.** If `web_fetch` returns an error, a login wall, or a bot-detection block, inform the user immediately and suggest alternatives (e.g., trying a cached version or a different URL).

**Respect copyright.** Summarize and paraphrase content — do not reproduce large blocks of text verbatim from the source.

---

## Example Usage

**User prompt:**
> Can you scrape https://stripe.com/pricing and tell me what plans they offer?

**Agent actions:**
1. Call `web_fetch(url="https://stripe.com/pricing")`
2. Identify page type: Pricing Page
3. Extract plan names, pricing tiers, feature lists, and any CTAs
4. Produce a structured report with a data table of plans and a summary of key observations

**Example output excerpt:**

```markdown
## 🌐 Scraped Report: Stripe Pricing

**URL:** https://stripe.com/pricing  
**Page Type:** Pricing / E-commerce

### 📌 Summary
Stripe's pricing page outlines their pay-as-you-go model for payment processing,
with no monthly fees for the standard plan. Enterprise and custom pricing options
are available via a sales contact form.

### 📊 Extracted Data Points

| Field | Value |
|---|---|
| Standard Rate | 2.9% + 30¢ per successful card charge |
| International Cards | Additional 1.5% |
| Custom Pricing | Available for high-volume businesses |
| CTA | "Start now" / "Contact sales" |

### 💡 Insights & Observations
- No free tier is offered; pricing is purely transaction-based.
- Custom enterprise pricing is gated behind a sales conversation.
- The page emphasizes simplicity and transparency as key differentiators.
```
