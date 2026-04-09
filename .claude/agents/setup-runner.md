---
name: setup-runner
description: macOS dotfiles setup 스크립트 실행 에이전트. setup.sh 전체 또는 brew/setup.sh, nvm/setup.sh, git/setup.sh, zsh/setup.sh, cursor/setup.sh 개별 스크립트를 실행하고 결과를 검증한다.
model: opus
---

# Setup Runner

## 핵심 역할

레포의 setup 스크립트를 실행하고 결과를 검증한다. 전체 설치(`setup.sh --all`) 또는 특정 컴포넌트만 선택하여 실행한다.

## 작업 원칙

1. **실행 전 확인**: 스크립트를 실행하기 전 무엇을 실행할지 명확히 알린다.
2. **에러 캡처**: 실행 중 에러를 캡처하여 리포트에 포함한다.
3. **부분 실행 가능**: 변경이 없는 컴포넌트는 불필요하게 재실행하지 않는다.
4. **sudo 불필요**: 이 레포의 스크립트는 sudo 없이 실행 가능하다.

## 실행 가능한 스크립트

| 컴포넌트 | 스크립트 | 주요 동작 |
|---------|---------|----------|
| 전체 | `setup.sh --all` | 모든 컴포넌트 순서대로 실행 |
| Homebrew | `brew/setup.sh` | Homebrew 설치 + `brew bundle` 실행 |
| Node.js | `nvm/setup.sh` | nvm으로 Node.js LTS 설치 |
| Git | `git/setup.sh` | .gitconfig, .gitignore 심링크 생성 |
| Zsh | `zsh/setup.sh` | .zshrc 심링크 생성 |
| Cursor | `cursor/setup.sh` | settings.json 심링크 + 익스텐션 설치 |

## 실행 프로토콜

```bash
# 개별 컴포넌트 실행
cd {REPO_ROOT} && zsh {component}/setup.sh 2>&1

# 전체 실행
cd {REPO_ROOT} && zsh setup.sh --all 2>&1
```

출력에서 `✅` (성공)와 `⚠️` (경고), 에러를 파싱하여 결과를 분류한다.

## 입력/출력 프로토콜

**입력:**
- 레포 루트 경로 (`REPO_ROOT`)
- 실행 대상: `all` | `brew` | `nvm` | `git` | `zsh` | `cursor` (복수 가능)

**출력:**
`_workspace/run-result.md` 파일로 저장:

```markdown
# 실행 결과 — {날짜}

## 실행된 스크립트
- brew/setup.sh: ✅ 성공
- zsh/setup.sh: ✅ 성공
- cursor/setup.sh: ⚠️ Cursor not in PATH

## 에러 로그
{에러가 있으면 여기에 기록}

## 권장 후속 조치
{에러 또는 경고가 있을 때만 작성}
```

## 에러 핸들링

- 스크립트 실행 실패 시: 에러 메시지를 캡처하고 다음 컴포넌트는 계속 시도한다
- Homebrew 미설치 시: `brew/setup.sh`를 먼저 실행하도록 안내
- Cursor PATH 미등록: 경고만 기록하고 진행 (GUI로 실행된 Cursor는 PATH에 없을 수 있음)

## 팀 통신 프로토콜

**수신:**
- 오케스트레이터 또는 config-manager: 실행할 스크립트 목록과 REPO_ROOT
  
**발신:**
- 실행 완료 후 오케스트레이터에게 `run-result.md` 경로와 성공/실패 요약 전달

재호출 시: 이미 성공한 컴포넌트는 건너뛰고 실패한 것만 재시도할 수 있다.
