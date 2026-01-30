#!/usr/bin/env node

const fs = require('node:fs');
const path = require('node:path');

const rootDir = path.resolve(__dirname, '..');
const commandsDir = path.join(rootDir, '.agents', 'commands');
const skillsDir = path.join(rootDir, '.agents', 'skills');
const hooksDir = path.join(rootDir, 'hooks');

const readFile = (filePath) => fs.readFileSync(filePath, 'utf8');

const stripBullet = (line) => line.replace(/^[-*]\s+/, '');

const extractSectionLine = (content, heading) => {
  const target = `## ${heading}`.toLowerCase();
  const lines = content.split(/\r?\n/);
  for (let i = 0; i < lines.length; i += 1) {
    if (lines[i].trim().toLowerCase() === target) {
      for (let j = i + 1; j < lines.length; j += 1) {
        const line = lines[j].trim();
        if (!line) continue;
        return stripBullet(line);
      }
    }
  }
  return '';
};

const parseDescription = (content) => {
  const match = content.match(/^---\s*\n([\s\S]*?)\n---\s*/);
  if (!match) return '';
  const lines = match[1].split(/\r?\n/);
  for (const line of lines) {
    const idx = line.indexOf(':');
    if (idx === -1) continue;
    const key = line.slice(0, idx).trim();
    if (key !== 'description') continue;
    let value = line.slice(idx + 1).trim();
    value = value.replace(/^['"]/, '').replace(/['"]$/, '').trim();
    return value;
  }
  return '';
};

const listFiles = (dir, filterFn) => {
  if (!fs.existsSync(dir)) return [];
  return fs.readdirSync(dir).filter((entry) => filterFn(path.join(dir, entry))).sort();
};

const listHookFiles = (dir, baseDir) => {
  if (!fs.existsSync(dir)) return [];
  const entries = fs.readdirSync(dir, { withFileTypes: true });
  const results = [];
  for (const entry of entries) {
    const fullPath = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      results.push(...listHookFiles(fullPath, baseDir));
    } else if (entry.isFile()) {
      results.push(path.relative(baseDir, fullPath));
    }
  }
  return results.sort();
};

const commands = [];
const listCommandFiles = (dir) => {
  if (!fs.existsSync(dir)) return [];
  const entries = fs.readdirSync(dir, { withFileTypes: true });
  const results = [];
  for (const entry of entries) {
    const fullPath = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      results.push(...listCommandFiles(fullPath));
    } else if (entry.isFile() && fullPath.endsWith('.md')) {
      results.push(fullPath);
    }
  }
  return results.sort();
};

if (fs.existsSync(commandsDir)) {
  const commandFiles = listCommandFiles(commandsDir);
  for (const filePath of commandFiles) {
    const content = readFile(filePath);
    const name = path.basename(filePath, '.md');
    const purpose = extractSectionLine(content, 'Purpose') || 'Purpose not documented.';
    const verification = extractSectionLine(content, 'Verification') || 'See command.';
    commands.push({ name, purpose, verification });
  }
}

const skillsByCategory = {};
if (fs.existsSync(skillsDir)) {
  const categories = listFiles(skillsDir, (filePath) => fs.statSync(filePath).isDirectory());
  for (const category of categories) {
    const categoryDir = path.join(skillsDir, category);
    const skillDirs = listFiles(categoryDir, (filePath) => fs.statSync(filePath).isDirectory());
    const skills = [];
    for (const skill of skillDirs) {
      const skillFile = path.join(categoryDir, skill, 'SKILL.md');
      if (!fs.existsSync(skillFile)) continue;
      const content = readFile(skillFile);
      const description = parseDescription(content) || 'Description not documented.';
      skills.push({ name: skill, description });
    }
    skillsByCategory[category] = skills;
  }
}

const hookFiles = listHookFiles(hooksDir, rootDir);

let output = '';
output += '# Cheatsheet\n\n';

output += '## Commands\n';
if (commands.length === 0) {
  output += '- None yet.\n';
} else {
  for (const command of commands) {
    output += `- \`${command.name}\`: ${command.purpose} (verify: ${command.verification})\n`;
  }
}
output += '\n';

output += '## Skills\n';
const categories = Object.keys(skillsByCategory).sort();
if (categories.length === 0) {
  output += '- None yet.\n\n';
} else {
  for (const category of categories) {
    output += `### ${category}\n`;
    const skills = skillsByCategory[category] || [];
    if (skills.length === 0) {
      output += '- None yet.\n\n';
      continue;
    }
    for (const skill of skills) {
      output += `- \`${skill.name}\`: ${skill.description}\n`;
    }
    output += '\n';
  }
}

output += '## Hooks\n';
if (hookFiles.length === 0) {
  output += '- None yet.\n\n';
} else {
  for (const hook of hookFiles) {
    output += `- \`${hook}\`\n`;
  }
  output += '\n';
}

output += '## Verification\n';
output += '- `pnpm lint`\n';
output += '- `pnpm typecheck`\n';
output += '- `pnpm test`\n';
output += '- `pnpm build`\n';
output += '- `pnpm verify`\n\n';

output += '## Key Output Paths\n';
output += '- `docs/explore/<slug>/opportunity-solution-tree.md`\n';
output += '- `docs/shape/<slug>/prd.md`\n';
output += '- `docs/shape/<slug>/breadboard.md`\n';
output += '- `docs/shape/<slug>/spike-plan.md`\n';
output += '- `docs/shape/<slug>/plan.md`\n';
output += '- `docs/shape/<slug>/prd.json`\n';
output += '- `.agents/tasks/prd-<slug>.json`\n';
output += '- `docs/dev/<slug>/dev-log.md`\n';
output += '- `docs/review/<slug>/review.md`\n';
output += '- `docs/review/<slug>/browser-qa.md`\n';
output += '- `docs/release/<slug>/release.md`\n';
output += '- `docs/release/<slug>/changelog.md`\n';
output += '- `docs/release/<slug>/post-release.md`\n';
output += '- `docs/learnings.md`\n';
output += '- `.ralph/`\n';

fs.writeFileSync(path.join(rootDir, 'cheatsheet.md'), output);
console.log('cheatsheet.md updated.');
