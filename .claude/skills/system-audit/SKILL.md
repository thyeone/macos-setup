---
name: system-audit
description: macOS 시스템 현황 감사 스킬. 현재 시스템에 설치된 Homebrew 패키지, Cursor 익스텐션, 심링크 상태를 dotfiles 레포와 비교하여 드리프트를 탐지한다. "감사", "현황 확인", "드리프트", "뭐가 다른지", "설치 상태", "심링크 확인", "sync 상태" 등의 요청 시 반드시 이 스킬을 사용할 것.
---

# System Audit Skill

## 목적

dotfiles 레포와 실제 시스템 간의 차이(드리프트)를 탐지한다. 새 맥에 설치 후 상태 확인, 업데이트 후 검증, 주기적 동기화 확인에 사용한다.

## 실행 절차

### 1. 레포 루트 확인

```bash
REPO_ROOT="$(git -C . rev-parse --show-toplevel 2>/dev/null || echo $PWD)"
```

### 2. 심링크 상태 확인

아래 4개 대상을 순서대로 확인한다:

```bash
# ~/.zshrc
ls -la ~/.zshrc && readlink ~/.zshrc

# ~/.gitconfig
ls -la ~/.gitconfig && readlink ~/.gitconfig

# ~/.gitignore
ls -la ~/.gitignore && readlink ~/.gitignore

# Cursor settings
ls -la "$HOME/Library/Application Support/Cursor/User/settings.json" && \
  readlink "$HOME/Library/Application Support/Cursor/User/settings.json"
```

심링크가 레포 파일을 가리키면 ✅, 일반 파일이면 ⚠️ (심링크 아님), 없으면 ❌.

### 3. Homebrew 드리프트

```bash
# 설치된 formulae
brew list --formula 2>/dev/null | sort

# 설치된 cask
brew list --cask 2>/dev/null | sort

# Brewfile 파싱 (brew 라인과 cask 라인 추출)
grep '^brew ' "$REPO_ROOT/brew/Brewfile" | sed 's/brew "//;s/"//' | sort
grep '^cask ' "$REPO_ROOT/brew/Brewfile" | sed 's/cask "//;s/"//' | sort
```

### 4. Cursor 익스텐션 드리프트

```bash
# 설치된 익스텐션
cursor --list-extensions 2>/dev/null | sort

# 레포 기준
sort "$REPO_ROOT/cursor/vscode-extensions.txt"
```

`cursor` 명령이 없으면 경고를 기록하고 계속 진행한다.

### 5. 결과 리포트 생성

`_workspace/audit-report.md`에 저장한다. 디렉토리가 없으면 생성한다.

## 출력 형식

```markdown
# 감사 리포트 — YYYY-MM-DD HH:MM

## 심링크 상태
| 대상 | 상태 | 링크 경로 |
|------|------|----------|
| ~/.zshrc | ✅ 정상 | /path/to/repo/zsh/.zshrc |

## Homebrew 드리프트
### 레포에 있으나 미설치
(없으면 "없음")

### 시스템에 있으나 Brewfile 미등록
(없으면 "없음")

## Cursor 익스텐션 드리프트
### 레포에 있으나 미설치
(없으면 "없음")

### 설치되어 있으나 목록 미등록
(없으면 "없음")

## 요약
- 심링크: X/4 정상
- Brew 드리프트: N개
- 익스텐션 드리프트: N개
```

## 에이전트 위임

복잡한 감사가 필요하거나 오케스트레이터가 요청하면 `system-auditor` 에이전트에 위임한다.
