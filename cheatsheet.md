# Cheatsheet

## Commands
- `rams`: Purpose not documented. (verify: See command.)

## Skills
### 00-utilities
- `agent-browser`: Browser automation using Vercel's agent-browser CLI. Use when you need to interact with web pages, fill forms, take screenshots, or scrape data. Alternative to Playwright MCP - uses Bash commands with ref-based element selection. Triggers on "browse website", "fill form", "click button", "take screenshot", "scrape page", "web automation".
- `agentation`: Add Agentation toolbar to Next.js. Use for install/config or dev-only <Agentation />.
- `ask-questions-if-underspecified`: Clarify requirements before implementing. Do not use automatically, only when invoked explicitly.
- `beautiful-mermaid`: Render Mermaid diagrams to SVG or ASCII/Unicode with beautiful-mermaid (Node/Bun/Deno/browser, no DOM). Use when you need Mermaid render without DOM.
- `brand-dna-extractor`: This skill should be used when users want to scrape multiple websites (Firecrawl, Parallel, or hybrid), extract brand guideline signals (including CSS variables + computed styles via browser probing), generate per-site prompt packs, and blend sources into a composite brand direction with exactly three outputs: brand_guidelines.md, prompt_library.json, design_tokens.json.
- `browser-use`: Fast, persistent browser automation via `browser-use` CLI (sessions persist across commands). Use for multi-step web workflows (open -> state -> click/input -> verify -> repeat). Supports chromium/headed, real Chrome (logged-in), and remote browser.
- `commit`: Write conventional commit messages with type, scope, and subject when the user wants to commit changes or save work.
- `create-cli`: Design command-line interface parameters and UX: arguments, flags, subcommands, help text, output formats, error messages, exit codes, prompts, config/env precedence, and safe/dry-run behavior. Use when you’re designing a CLI spec (before implementation) or refactoring an existing CLI’s surface area for consistency, composability, and discoverability.
- `dev-browser`: Browser automation with persistent page state. Use when users ask to navigate websites, fill forms, take screenshots, extract web data, test web apps, or automate browser workflows. Trigger phrases include "go to [url]", "click on", "fill out the form", "take a screenshot", "scrape", "automate", "test the website", "log into", or any browser interaction request.
- `docs-list`: Run `scripts/docs-list.ts` to list `docs/` markdown + frontmatter summary/read_when. Use when auditing docs coverage.
- `engineering-tutor`: Teach engineering concepts for real understanding using the Feynman technique, strong metaphors, and diagrams (render via beautiful-mermaid). Use when users ask to explain/teach/break down engineering concepts, build intuition/mental models, understand trade-offs/failure modes/design choices, or want a visual diagram.
- `every-style-editor`: This skill should be used when reviewing or editing copy to ensure adherence to Every's style guide. It provides a systematic line-by-line review process for grammar, punctuation, mechanics, and style guide compliance.
- `file-todos`: Manage file-based todos stored alongside a dossier. Create, triage, and track dependencies. Use when work is tracked in docs/*/todos.
- `firecrawl`: Web search/scrape/crawl via Firecrawl CLI (prefer for live internet lookups).
- `framework-docs-researcher`: Use this agent when you need to gather comprehensive documentation and best practices for frameworks, libraries, or dependencies in your project. This includes fetching official documentation, exploring source code, identifying version-specific constraints, and understanding implementation patterns.
- `handoff`: This skill should be used when preparing a handoff checklist for agents and persisting it as a handoff note that can be picked up in a fresh thread.
- `landpr`: This skill should be used when preparing a /landpr prompt/checklist to land a PR.
- `markdown-converter`: Convert documents and files to Markdown using markitdown. Use when converting PDF, Word (.docx), PowerPoint (.pptx), Excel (.xlsx, .xls), HTML, CSV, JSON, XML, images (with EXIF/OCR), audio (with transcription), ZIP archives, YouTube URLs, or EPubs to Markdown format for LLM processing or text analysis.
- `nano-banana-pro`: Generate/edit images with Nano Banana Pro (Gemini 3 Pro Image). Use for image creation or modification incl logos, stickers, mockups, style transfer, multi-image composition, and multi-turn refinement.
- `openai-image-gen`: Batch-generate images via OpenAI Images API. Random prompt sampler + `index.html` gallery. Use when you need prompt variants or batches.
- `oracle`: Use the @steipete/oracle CLI to bundle a prompt plus the right files and get a second-model review (API or browser) for debugging, refactors, design checks, or cross-validation.
- `parallel-web-tools`: This skill should be used when users want a Firecrawl-like capability for web discovery and clean markdown extraction using Parallel Search and Parallel Extract (including objective-led excerpts and full content).
- `pickup`: This skill should be used when preparing a pickup checklist when starting a task, rehydrating context from the latest handoff note if available.
- `video-transcript-downloader`: Download videos, audio, subtitles, and clean paragraph-style transcripts from YouTube and any other yt-dlp supported site. Use when asked to “download this video”, “save this clip”, “rip audio”, “get subtitles”, “get transcript”, or to troubleshoot yt-dlp/ffmpeg and formats/playlists.

### 01-research-brainstorm
- None yet.

### 02-shape
- `breadboarding`: This skill should be used when shaping a software change and needing to breadboard the solution at the right level of abstraction (places, affordances, connections), including mapping an existing system via UI + code affordances, producing a wiring diagram, a parts/BOM plan, a fit check, and (when relevant) an extract-vs-duplicate analysis.
- `brief`: Write or update `brief.md` for shaping. Use when asked to create a project or feature brief, a 1-2 pager, or to turn rough inputs into goals, non-goals, scope, risks, and open questions.
- `create-json-prd`: Generate a Product Requirements Document (PRD) as JSON for Ralph by converting an existing PRD markdown file. Triggers on: create a prd, write prd for, plan this feature, requirements for, spec out.
- `create-prd`: Draft PRD with scope, stories, acceptance criteria, verification. Use when shaping a new feature or spec.
- `demo-runbook`: This skill should be used when a user needs a demo package that starts with a live demo (not slides) and produces both a demo script and a navigable single-file HTML runbook, including caveats, respectful competitive comparison, and LLM architecture details (RAG, evals, observability).
- `prd`: Generate a Product Requirements Document (PRD) as JSON for Ralph. Triggers on: create a prd, write prd for, plan this feature, requirements for, spec out.
- `spike-investigation`: This skill should be used when shaping work and needing to de-risk rabbit holes (technical unknowns, design gaps, interdependencies) by running timeboxed spikes, documenting proof, and updating the shaped concept with patches, cuts, and out-of-bounds so the work stays thin-tailed within the appetite.
- `wf-shape`: This skill should only be used when the user uses the word workflow and asks to shape a project from messy inputs into a de-risked, de-scoped shaped packet (brief, breadboard, risks, spikes) ready for wf-plan, with handoff/pickup boundaries to avoid context rot.

### 03-plan
- `best-practices-researcher`: Use this agent when you need to research and gather external best practices, documentation, and examples for any technology, framework, or development practice. This includes finding official documentation, community standards, well-regarded examples from open source projects, and domain-specific conventions. The agent excels at synthesizing information from multiple sources to provide comprehensive guidance on how to implement features or solve problems according to industry standards.
- `bug-reproduction-validator`: Use this agent when you receive a bug report or issue description and need to verify whether the reported behavior is actually a bug. This agent will attempt to reproduce the issue systematically, validate the steps to reproduce, and confirm whether the behavior deviates from expected functionality.
- `deepen-plan`: This skill should be used when deepening a plan with parallel research agents for each section.
- `plan-review`: This skill should be used when having multiple specialized agents review a plan in parallel.
- `repo-research-analyst`: Use this agent when you need to conduct thorough research on a repository's structure, documentation, and patterns. This includes analyzing architecture files, examining GitHub issues for patterns, reviewing contribution guidelines, checking for templates, and searching codebases for implementation patterns. The agent excels at gathering comprehensive information about a project's conventions and best practices.\\n\\n.
- `reproduce-bug`: This skill should be used when reproducing and investigating a bug using logs, console inspection, and browser screenshots.
- `spec-flow-analyzer`: Use this agent when you have a specification, plan, feature description, or technical document that needs user flow analysis and gap identification. This agent should be used proactively when:\\n\\n.
- `triage`: This skill should be used when triaging and categorizing findings for the CLI todo system.
- `wf-plan`: This skill should only be used when the user uses the word workflow and asks to create a commit-ready, deep project plan from a shaped packet (brief, breadboard, risks, spikes) before development starts, with handoff/pickup boundaries to avoid context rot.

### 04-develop
- `12-principles-of-animation`: Apply Disney's 12 animation principles to web interfaces. Use when implementing motion, reviewing animation quality, designing micro-interactions, or making UI feel alive. Triggers on tasks involving CSS animations, transitions, motion libraries, easing curves, springs, or UX feedback.
- `baseline-ui`: Baseline UI rules to prevent design slop. Use for UI design or review.
- `canvas-design`: Create beautiful visual art in .png and .pdf documents using design philosophy. You should use this skill when the user asks to create a poster, piece of art, design, or other static piece. Create original visual designs, never copying existing artists' work to avoid copyright violations.
- `composition-patterns`: React composition patterns that scale. Use when refactoring boolean prop proliferation, designing reusable component APIs, or reviewing component architecture.
- `design-lab`: Conduct design interviews, generate five distinct UI variations in a temporary design lab, collect feedback, and produce implementation plans. Use when the user wants to explore UI design options, redesign existing components, or create new UI with multiple approaches to compare.
- `fixing-accessibility`: Fix accessibility issues. Use for a11y audits or fixes.
- `fixing-metadata`: Fix metadata issues. Use for SEO/social metadata audits or fixes.
- `fixing-motion-performance`: Fix animation performance issues. Use for motion audits or refactors.
- `frontend-design`: Create distinctive, production-grade frontend interfaces with high design quality. Use this skill when the user asks to build web components, pages, or applications. Generates creative, polished code that avoids generic AI aesthetics.
- `generating-tailwind-brand-config`: Transforms Brand DNA artefacts (docs/02-guidelines/inspiration/brand_guidelines.md, design_tokens.json, prompt_library.json) into Tailwind-ready design system config (CSS variables + Tailwind preset) for a web app and a marketing site. Use when wiring tokens into Tailwind, setting up light/dark mode, or generating reusable presets and component recipes.
- `interaction-design`: Design and implement microinteractions, motion design, transitions, and user feedback patterns. Use when adding polish to UI interactions, implementing loading states, or creating delightful user experiences.
- `interface-design`: This skill is for interface design — dashboards, admin panels, apps, tools, and interactive products. NOT for marketing design (landing pages, marketing sites, campaigns).
- `pr-comment-resolver`: Use this agent when you need to address comments on pull requests or code reviews by making the requested changes and reporting back on the resolution. This agent handles the full workflow of understanding the comment, implementing the fix, and providing a clear summary of what was done.
- `rams`: Design feedback via the rams skill. Use for UI critique or design suggestions; backup to ui-skills.
- `react-best-practices`: React/Next.js performance best practices from Vercel. Use when writing, reviewing, or refactoring React/Next.js code for performance, data fetching, or bundle size.
- `swiftui-ui-patterns`: Best practices and example-driven guidance for building SwiftUI views and components. Use when creating or refactoring SwiftUI UI, designing tab architecture with TabView, composing screens, or needing component-specific patterns and examples.
- `tailwind-css-patterns`: Comprehensive Tailwind CSS utility-first styling patterns including responsive design, layout utilities, flexbox, grid, spacing, typography, colors, and modern CSS best practices. Use when styling React/Vue/Svelte components, building responsive layouts, implementing design systems, or optimizing CSS workflow.
- `ui-ux-pro-max`: UI/UX design intelligence. 50 styles, 21 palettes, 50 font pairings, 20 charts, 9 stacks (React, Next.js, Vue, Svelte, SwiftUI, React Native, Flutter, Tailwind, shadcn/ui). Actions: plan, build, create, design, implement, review, fix, improve, optimize, enhance, refactor, check UI/UX code. Projects: website, landing page, dashboard, admin panel, e-commerce, SaaS, portfolio, blog, mobile app, .html, .tsx, .vue, .svelte. Elements: button, modal, navbar, sidebar, card, table, form, chart. Styles: glassmorphism, claymorphism, minimalism, brutalism, neumorphism, bento grid, dark mode, responsive, skeuomorphism, flat design. Topics: color palette, accessibility, animation, layout, typography, font pairing, spacing, hover, shadow, gradient. Integrations: shadcn/ui MCP for component search and examples.
- `use-ai-sdk`: AI SDK guidance. Use for Vercel AI SDK APIs (generateText, streamText, ToolLoopAgent, tools), providers, streaming, tool calling, structured output, or troubleshooting.
- `verify`: Verification ladder. Pick smallest scope, run scripts in order, smoke UI, report PASS/NO-GO.
- `wcag-audit-patterns`: Conduct WCAG 2.2 accessibility audits with automated testing, manual verification, and remediation guidance. Use when auditing websites for accessibility, fixing WCAG violations, or implementing accessible design patterns.
- `web-design-guidelines`: Review UI code for Web Interface Guidelines compliance. Use when asked to "review my UI", "check accessibility", "audit design", "review UX", or "check my site against best practices".
- `wf-develop`: This skill should only be used when the user uses the word workflow and asks to develop or implement changes with a verification-first loop and clean handoff/pickup boundaries.
- `wf-ralph`: Run a Ralph-style, one-story-per-iteration loop using the Ralph CLI (dev, research, e2e, review), Codex-by-default, and dossier-local PRD JSON discovery.

### 05-review
- `agent-native-architecture`: Build applications where agents are first-class citizens. Use this skill when designing autonomous agents, creating MCP tools, implementing self-modifying systems, or building apps where features are outcomes achieved by agents operating in a loop.
- `agent-native-reviewer`: Focused parity review for a feature/PR. Use when validating action/context parity and generating a capability map + findings.
- `architecture-strategist`: Use this agent when you need to analyze code changes from an architectural perspective, evaluate system design decisions, or ensure that modifications align with established architectural patterns. This includes reviewing pull requests for architectural compliance, assessing the impact of new features on system structure, or validating that changes maintain proper component boundaries and design principles.
- `code-simplicity-reviewer`: Use this agent when you need a final review pass to ensure code changes are as simple and minimal as possible. This agent should be invoked after implementation is complete but before finalizing changes, to identify opportunities for simplification, remove unnecessary complexity, and ensure adherence to YAGNI principles.
- `data-integrity-guardian`: Use this agent when you need to review database migrations, data models, or any code that manipulates persistent data. This includes checking migration safety, validating data constraints, ensuring transaction boundaries are correct, and verifying that referential integrity and privacy requirements are maintained.
- `data-migration-expert`: Use this agent when reviewing PRs that touch database migrations, data backfills, or any code that transforms production data. This agent validates ID mappings against production reality, checks for swapped values, verifies rollback safety, and ensures data integrity during schema changes. Essential for any migration that involves ID mappings, column renames, or data transformations.
- `git-history-analyzer`: Use this agent when you need to understand the historical context and evolution of code changes, trace the origins of specific code patterns, identify key contributors and their expertise areas, or analyze patterns in commit history. This agent excels at archaeological analysis of git repositories to provide insights about code evolution and development patterns.
- `kieran-python-reviewer`: Use this agent when you need to review Python code changes with an extremely high quality bar. This agent should be invoked after implementing features, modifying existing code, or creating new Python modules. The agent applies Kieran's strict Python conventions and taste preferences to ensure code meets exceptional standards.\\n\\n.
- `kieran-typescript-reviewer`: Use this agent when you need to review TypeScript code changes with an extremely high quality bar. This agent should be invoked after implementing features, modifying existing code, or creating new TypeScript components. The agent applies Kieran's strict TypeScript conventions and taste preferences to ensure code meets exceptional standards.\\n\\n.
- `pattern-recognition-specialist`: Use this agent when you need to analyze code for design patterns, anti-patterns, naming conventions, and code duplication. This agent excels at identifying architectural patterns, detecting code smells, and ensuring consistency across the codebase.
- `performance-oracle`: Use this agent when you need to analyze code for performance issues, optimize algorithms, identify bottlenecks, or ensure scalability. This includes reviewing database queries, memory usage, caching strategies, and overall system performance. The agent should be invoked after implementing features or when performance concerns arise.\\n\\n.
- `security-best-practices`: Perform language and framework specific security best-practice reviews and suggest improvements. Trigger only when the user explicitly requests security best practices guidance, a security review/report, or secure-by-default coding help. Trigger only for supported languages (python, javascript/typescript, go). Do not trigger for general code review, debugging, or non-security tasks.
- `security-sentinel`: Use this agent when you need to perform security audits, vulnerability assessments, or security reviews of code. This includes checking for common security vulnerabilities, validating input handling, reviewing authentication/authorization implementations, scanning for hardcoded secrets, and ensuring OWASP compliance.
- `security-threat-model`: Repository-grounded threat modeling that enumerates trust boundaries, assets, attacker capabilities, abuse paths, and mitigations, and writes a concise Markdown threat model. Trigger only when the user explicitly asks to threat model a codebase or path, enumerate threats/abuse paths, or perform AppSec threat modeling. Do not trigger for general architecture summaries, code review, or non-security design work.
- `test-browser`: This skill should be used when running browser tests on pages affected by the current PR or branch.
- `wf-review`: This skill should only be used when the user uses the word workflow and asks to review changes (select mode = light, light-plus, heavy) with verification and context handoff/pickup to avoid context rot.

### 06-release
- `changelog`: This skill should be used when creating changelogs for recent merges to main branch.
- `deployment-verification-agent`: Use this agent when a PR touches production data, migrations, or any behavior that could silently discard or duplicate records. Produces a concrete pre/post-deploy checklist with SQL verification queries, rollback procedures, and monitoring plans. Essential for risky data changes where you need a Go/No-Go decision.
- `wf-release`: This skill should only be used when the user uses the word workflow and asks to release or ship changes with a release checklist, verification, and clean handoff/pickup boundaries.

### 07-compound
- `compound-docs`: Capture solved problems as categorized documentation with YAML frontmatter for fast lookup. Use when a non-trivial problem is solved and worth reusing.

### 10-audit
- `agent-native-audit`: Comprehensive agent-native architecture audit with scored principles and multi-slice review. Use for system-wide health checks or periodic audits.

### 98-skill-maintenance
- `create-agent-skills`: Expert guidance for creating, writing, and refining Claude Code Skills. Use when working with SKILL.md files, authoring new skills, improving existing skills, or understanding skill structure and best practices.
- `heal-skill`: This skill should be used when fixing incorrect SKILL.md files with outdated instructions or APIs.
- `modular-skills-architect`: Map and refactor an agent context ecosystem: skills, commands/workflows, hooks, agent files, AGENTS.md templates, and docs. Output system map, module/dependency design, Register updates, and a concrete split/consolidate/rename/delete plan. Use when routing or ownership is messy.
- `skill-creator`: Guide for creating effective skills. This skill should be used when users want to create a new skill (or update an existing skill) that extends Claude's capabilities with specialized knowledge, workflows, or tool integrations.

### 99-archive
- None yet.

## Hooks
- `hooks/git/commit-msg`
- `hooks/git/post-merge`
- `hooks/git/pre-commit`
- `hooks/git/pre-push`
- `hooks/git/prepare-commit-msg`

## Verification
- Use the `verify` skill for the pnpm ladder.

## Docs Structure
- See `docs/AGENTS.md` in target repos for doc locations and naming.
