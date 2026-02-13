# Code Standards

This document outlines the coding standards and best practices for the amdWiki project.

## GLOBAL CODE PREFERENCES

In all interactions and commit messages

- READ AGENTS.MD file and update as required.
- "One File Done Right" make all appropriate chages to each file.
- Be concise and sacrifice grammar for consistion
- DRY (Don't Repeat Yourself) principle in Code and Documentation
  - in Documentation Refer and link to other Documents.
- We ONLY do Test-Driven Development (TDD)
- Iterate Progressively. Start with Core features only: Gather feedback.
- Please think first and provide options - Presenting a list of unresolved questions to answer, if any. Questions, Comments and Suggestions are always encouraged!
- Your primary method for interacting with GitHub should be the CLI.
- On larger objectives present phased implementation plan
- NEVER put unencrypted "Secrets" in in Git or other CMS systems.
- Always create docs/project_log.md file as a log of work done on the project in format specified in document within "## Format"
- In Markdown documents:
  - **bold** in list beginings.
  - do not use "1. Headings" ok to use "## Step 1 ..."
  - **NO Bolding in List Headings:** e.g., `- **Project Overview:**` is invalid. Use `- Project Overview:` instead.
  - **NO Bolding entire lines:** e.g., `**Process:**` is invalid. Use proper headings (e.g., `### Process`) instead.

## Language & Environment

- Language: English (US) for all code and documentation
- Runtime: Node.js 18+ with TypeScript
- Target: ESP32
