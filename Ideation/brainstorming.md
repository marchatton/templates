
I want to build out a template / repo consisting of skills and agents.md that I can use across 


Some ideas that I have, grouping types:
- Exploration, shaping, development, general (e.g. learning, communication)
- Core dev lifecycle: plan -> work -> review
- Other categories: Product marketing, copy, etc




Notes:
- Don’t focus on exploration too much right now. Exploration is high-leverage but very abstract right now. Don’t want to get stuck here
- This should be catered towards product engineers. I.e. someone who can go from picking the right problems all the way to shipping to production, and even include some product marketing etc
- We should have links to the official skills like compound-engineering and ink those. so that as they update we can pull in the latest versions
- Use this to create skills https://github.com/anthropics/skills/tree/main/skills/skill-creator
- Guidelines on creating skills https://agentskills.io/specification
- I want a easy to see summary (cheatsheet) of all commands and tools, including a short description of each (both custom and official claude marketplace)
- I'm a bit skeptical on sub agents but maybe they are worth some investment?
- Note that I want to use pnpm not npm or bun
- To get the best out of coding agents, they should have a way to verify the results. that could be a bash command, running a test suite, testing in browser (desktop or mobile). it's imperative that the skills have good examples and instructions on how to help the agent verify things. 

Sections below

# Exploration and framing:
(dont spend time here, these are just some placeholders)
- Review product strategy incl segmentation and positioning
- Opportunity solution tree mapping (by teresa torrez) which includes multiple customer segments
- Searching context - QMD: https://github.com/tobi/qmd 


# Shaping
Shaping is largely inspired by the shape-up framework.

- PRD 
    - generation https://github.com/snarktank/ai-dev-tasks 
    - Use user questions skill to clarify things https://x.com/i/status/2006624792531923266 
    - https://github.com/snarktank/amp-skills/tree/main

- User journey:
        - Breadboarding
            - Theory: https://basecamp.com/shapeup/1.3-chapter-04#breadboarding  
            - Example: https://www.linkedin.com/posts/feltpresence_ive-been-teaching-claude-code-how-to-do-activity-7415038903386206208-6sqO?utm_source=share&utm_medium=member_desktop&rcm=ACoAAAhVeMkB_X52xmhrJWTxAb6-zBP4Q8tLJ7c 




- Architecture (Use mermaid diagrams):
    - State machine diagrams
    - Data flow
    - Architecture patterns https://skillsmp.com/skills/wshobson-agents-plugins-backend-development-skills-architecture-patterns-skill-md
    - API design https://skillsmp.com/skills/wshobson-agents-plugins-backend-development-skills-api-design-principles-skill-md
    - back end arhictecture https://skillsmp.com/skills/wshobson-agents-plugins-backend-development-skills-architecture-patterns-skill-md

Security audit
    - security data https://skillsmp.com/skills/davila7-claude-code-templates-cli-tool-components-skills-development-security-compliance-skill-md
    - security engineering https://skillsmp.com/skills/davila7-claude-code-templates-cli-tool-components-skills-development-senior-security-skill-md
    - security audit https://skillsmp.com/skills/parcadei-continuous-claude-v3-claude-skills-security-skill-md

- Front end skills (here I think we should consider a name space) 
  - brand guidelines -   
  - General guidelines https://www.ui-skills.com/ 
  - V specific commands and skills https://impeccable.style/ 
  - anthropic https://github.com/anthropics/skills/blob/main/skills/frontend-design/SKILL.md

- Claude code creator - his flow https://x.com/bcherny/status/2007179832300581177?s=20 (see all of his thread)

- Creator of compound engineering, his flow https://x.com/kieranklaassen/status/2009496733320176027?s=20 not how he uses nested commands

- Examples of the Ralph Wiggum (continuous coding) approach:
    - https://github.com/snarktank/ralph
    - https://claytonfarr.github.io/ralph-playbook/ 
    - https://chatgpt.com/canvas/shared/6964e3bf84e88191b1f729dd7be170e6 
    - https://x.com/agrimsingh/status/2010412150918189210
    - https://github.com/iannuttall/ralph 




Dev ops:
- commit-push-pr
  - "Claude and I use a /commit-push-pr slash command dozens of times every day. The command uses inline bash to pre-compute git status and a few other pieces of info to make the command run quickly and avoid back-and-forth with the model ". https://code.claude.com/docs/en/slash-commands#bash-command-execution. 
  - https://skillsmp.com/skills/google-gemini-gemini-cli-gemini-skills-pr-creator-skill-md
  
- commit-commands, pre-review-toolkit
- Code-review - use official claude-plugins-official 
- code-simplifier skill from anthropic
- hook creation https://skillsmp.com/skills/anthropics-claude-code-plugins-plugin-dev-skills-hook-development-skill-md

Sub agents ideas (used by the creator of claude code):
https://code.claude.com/docs/en/sub-agents#explore

- build-validator.md
- code-architect.md
- code-simplifier.md
- oncall-guide.md
- verify-app.md

Hook ideas:
- postToolUse {
  "PostToolUse": [
    {
      "matcher": "Write|Edit",
      "hooks": [
        {
          "type": "command",
          "command": "bun run format || true"
        }
      ]
    }
  ]
}


Testing:
- Writing and reviewing evals (placeholder)
- Web app testing https://github.com/anthropics/skills/blob/main/skills/webapp-testing/SKILL.md . note that we should replace this to use a lighter version light chrome-dev-tools-mcp  


# Fun
- Algorithmic art https://github.com/anthropics/skills/blob/main/skills/algorithmic-art/SKILL.md
- 

# marketing
- seo review https://skillsmp.com/skills/leonardomso-33-js-concepts-opencode-skill-seo-review-skill-md
- 


# examples
Example from Kieran Klaasen for inspiration - we dont need to start there, as its a bit complex. just an indication of where we are going.
---
name: lfg
description: Full autonomous engineering workflow
argument-hint: "[feature description]"
---
Run these slash commands in order. Do not do anything else.
1. `/ralph-wiggum:ralph-loop "finish all slash commands" --completion-promise "DONE"`
2. `/workflows:plan $ARGUMENTS`
3. `/compound-engineering:deepen-plan`
4. `/workflows:work`
5. `/workflows:review`
6. `/compound-engineering:resolve_todo_parallel`
7. `/compound-engineering:playwright-test`
8. `/compound-engineering:feature-video`
9. Output `<promise>DONE</promise>` when video is in PR
Start with step 1 now.


## Future ideas
- Create skills that do the same things that Amp does (e.g. librarian)
