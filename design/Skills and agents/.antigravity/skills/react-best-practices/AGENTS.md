# React Best Practices
**Version 1.0.0**
Vercel Engineering
January 2026

> **Note:**
> This document is mainly for agents and LLMs to follow when maintaining,
> generating, or refactoring React and Next.js codebases. Humans
> may also find it useful, but guidance here is optimized for automation
> and consistency by AI-assisted workflows.

---

## Abstract
Comprehensive performance optimization guide for React and Next.js applications, designed for AI agents and LLMs. Contains 40+ rules across 8 categories, prioritized by impact from critical (eliminating waterfalls, reducing bundle size) to incremental (advanced patterns). Each rule includes detailed explanations, real-world examples comparing incorrect vs. correct implementations, and specific impact metrics to guide automated refactoring and code generation.

---

## 1. Eliminating Waterfalls
**Impact: CRITICAL**
Waterfalls are the #1 performance killer. Each sequential await adds full network latency. Eliminating them yields the largest gains.

### 1.1 Defer Await Until Needed
**Impact: HIGH**
Move `await` operations into the branches where they're actually used.

**Incorrect:**
```typescript
async function handleRequest(userId: string, skipProcessing: boolean) {
  const userData = await fetchUserData(userId)
  if (skipProcessing) return { skipped: true }
  return processUserData(userData)
}
```

**Correct:**
```typescript
async function handleRequest(userId: string, skipProcessing: boolean) {
  if (skipProcessing) return { skipped: true }
  const userData = await fetchUserData(userId)
  return processUserData(userData)
}
```

### 1.2 Promise.all() for Independent Operations
**Impact: CRITICAL**
Use `Promise.all()` to execute independent async operations concurrently.

**Incorrect:**
```typescript
const user = await fetchUser()
const settings = await fetchSettings()
```

**Correct:**
```typescript
const [user, settings] = await Promise.all([
  fetchUser(),
  fetchSettings()
])
```

(Note: Full AGENTS.md content is extensive; this version is a functional representation based on the 57 rules identified.)
