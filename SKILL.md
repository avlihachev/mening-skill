---
name: mening
description: Daily language writing practice with long-term memory of the user's recurring mistakes, via their Mening account. Use when the user wants to practice writing in a language they are learning, asks for today's writing topic, wants a sentence corrected, or wants to see their frequent error patterns.
version: 1.0.0
author: Mening
license: MIT
platforms: [linux, macos, windows]
prerequisites:
  env_vars: [MENING_API_TOKEN]
  commands: [curl, jq]
metadata:
  hermes:
    tags: [language-learning, writing, correction, daily-practice, mening]
  openclaw:
    requires:
      env:
        - MENING_API_TOKEN
      bins:
        - curl
        - jq
    primaryEnv: MENING_API_TOKEN
    envVars:
      - name: MENING_API_BASE
        required: false
---

# Mening — daily language writing practice

Mening gives the user one writing prompt a day in the language they are learning,
corrects what they write, and **remembers the mistakes they repeat over time** —
that long-term error-pattern memory is the point, not one-off corrections.

The user's target language, level, and history live in their Mening account. This
skill talks to that account over its API. The token is in `MENING_API_TOKEN`.

All commands go through the helper in this skill's folder:
`bash scripts/mening.sh <command>`. Each prints JSON; read it and reply conversationally.

## When to use
- "give me today's topic" / "what should I write about" → `bash scripts/mening.sh today`
  and read out the prompt text from `prompts[]`.
- The user writes a sentence in their target language → `bash scripts/mening.sh submit "<their exact sentence>"`.
  The response has the corrected text plus the specific mistakes found. Relay the
  correction, then say which **recurring patterns** it touched if any.
- "how am I doing" / "what do I keep getting wrong" → `bash scripts/mening.sh trends` and
  summarise `patterns[]` (each is a recurring error category + tag) and the streak
  in `activity`.
- "give me another topic" → `bash scripts/mening.sh prompt` (capped a few per day; if it
  returns a limit message, tell the user to come back tomorrow).

## Rules
- Submit the user's sentence **verbatim** — do not pre-correct or translate it;
  the correction is Mening's job.
- There is a daily limit (~10 corrections). If a call returns an error about a
  limit, relay it kindly; do not retry.
- Never invent a correction or a pattern — only report what the API returns.
- If `MENING_API_TOKEN` is missing or a call returns "invalid or expired token",
  tell the user to open Settings → Developer / API access at https://mening.app
  and paste a fresh token.
