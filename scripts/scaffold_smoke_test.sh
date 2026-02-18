#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

tmp_root="$(mktemp -d)"
cleanup() {
  rm -rf "${tmp_root}"
}
trap cleanup EXIT

assert_exists() {
  local path="$1"
  if [ ! -e "${path}" ]; then
    echo "Expected path missing: ${path}" >&2
    exit 1
  fi
}

echo "==> smoke:new:minimal"
new_repo="${tmp_root}/new-minimal"
bash "${root_dir}/scripts/onboard_repo.sh" "${new_repo}" --profile minimal --apply --yes

assert_exists "${new_repo}/AGENTS.md"
assert_exists "${new_repo}/docs/README.md"
assert_exists "${new_repo}/docs/REPO-STRUCTURE.generated.md"
assert_exists "${new_repo}/.agent-skills.scaffold.json"
assert_exists "${new_repo}/scripts/verify.sh"

(
  cd "${new_repo}"
  bash scripts/verify.sh
)

echo "==> smoke:new:full"
full_repo="${tmp_root}/new-full"
bash "${root_dir}/scripts/onboard_repo.sh" "${full_repo}" --profile full --apply --yes
assert_exists "${full_repo}/docs/00-strategy/roadmap.md"
assert_exists "${full_repo}/docs/06-release/CHANGELOG.md"
assert_exists "${full_repo}/docs/REPO-STRUCTURE.generated.md"

echo "==> smoke:existing:plan+apply"
existing_repo="${tmp_root}/existing"
mkdir -p "${existing_repo}"
git -C "${existing_repo}" init -b main >/dev/null

git -C "${existing_repo}" config user.email "smoke@example.com"
git -C "${existing_repo}" config user.name "Smoke Bot"

printf "# Existing Repo\n" > "${existing_repo}/README.md"
git -C "${existing_repo}" add README.md
git -C "${existing_repo}" commit -m "init" >/dev/null

git -C "${existing_repo}" switch -c chore/agent-skills-onboarding >/dev/null

bash "${root_dir}/scripts/onboard_repo.sh" "${existing_repo}" --existing-repo --profile minimal --dry-run --yes
bash "${root_dir}/scripts/onboard_repo.sh" "${existing_repo}" --existing-repo --profile minimal --apply --yes

assert_exists "${existing_repo}/.agent-skills.scaffold.json"
assert_exists "${existing_repo}/docs/REPO-STRUCTURE.generated.md"

echo "scaffold smoke test OK"
