---
name: macos-setup-orchestrator
description: macOS dotfiles 하네스 오케스트레이터. 새 맥 설정, 시스템 감사, dotfiles 업데이트, 설정 추가, 설치 상태 동기화 등 macOS 개발환경 관련 복합 작업을 에이전트 팀으로 조율한다. "새 맥 설정", "전체 설치", "감사하고 적용", "드리프트 해결", "다시 설치", "환경 동기화" 등의 요청 시 이 스킬을 사용할 것. 단순 질문(특정 파일 내용 확인 등)은 직접 응답 가능.
---

# macOS Setup Orchestrator

## 팀 구성

| 에이전트 | 역할 |
|---------|------|
| `system-auditor` | 시스템 현황 감사, 드리프트 탐지 |
| `config-manager` | dotfiles 설정 파일 수정 |
| `setup-runner` | setup 스크립트 실행 |

**모델:** 모든 에이전트는 `model: "opus"` 사용

## Phase 0: 컨텍스트 확인

워크플로우 시작 전 기존 산출물 확인:

```
_workspace/ 존재 여부 확인
├── 없음 → 초기 실행
├── 있음 + 부분 수정 요청 → 부분 재실행 (해당 에이전트만)
└── 있음 + 새 요청 → 기존 _workspace를 _workspace_prev/로 이동 후 새 실행
```

## Phase 1: 요청 분류

사용자 요청을 아래 워크플로우 중 하나로 분류한다:

| 요청 유형 | 실행 워크플로우 |
|----------|--------------|
| 새 맥 초기 설정 | W1: 전체 설치 |
| 현황 확인/감사 | W2: 감사 전용 |
| 드리프트 해결 | W3: 감사 → 수정 → 실행 |
| 설정 추가 (brew, alias 등) | W4: 수정 → (선택) 실행 |
| 재실행/재적용 | W1 또는 W4 부분 실행 |

## 워크플로우

### W1: 전체 설치 (새 맥 설정)

**실행 모드:** 서브 에이전트 (순차 실행)

```
setup-runner → setup.sh --all 실행
     ↓
system-auditor → 설치 후 심링크 검증
     ↓
결과 리포트 생성
```

Agent 호출 예시:
```python
Agent(
  subagent_type="general-purpose",  # setup-runner 에이전트 정의 참조
  model="opus",
  prompt="setup-runner 에이전트로서: REPO_ROOT={경로}에서 setup.sh --all 실행 후 _workspace/run-result.md 저장"
)
```

### W2: 감사 전용

**실행 모드:** 서브 에이전트

```
system-auditor → 전체 감사 → audit-report.md
     ↓
사용자에게 리포트 제시 + 드리프트 해결 여부 문의
```

### W3: 감사 → 수정 → 실행 (드리프트 해결)

**실행 모드:** 에이전트 팀

```
TeamCreate: [system-auditor, config-manager, setup-runner]

Phase A: system-auditor → audit-report.md
Phase B: config-manager → audit-report.md 읽고 Brewfile/extensions 업데이트 → config-changes.md
Phase C: 사용자 승인 후 setup-runner → 변경된 컴포넌트만 실행
Phase D: system-auditor → 재감사로 검증
```

### W4: 설정 추가

**실행 모드:** 서브 에이전트 (단순) 또는 에이전트 팀 (복잡)

```
config-manager → 파일 수정 → config-changes.md
     ↓ (brew/extensions 변경 시)
사용자에게 setup-runner 실행 여부 문의
     ↓ (승인 시)
setup-runner → 해당 컴포넌트만 실행
```

## 데이터 전달 프로토콜

- **파일 기반**: `_workspace/` 하위에 산출물 저장
  - `_workspace/audit-report.md` — 감사 결과
  - `_workspace/config-changes.md` — 변경 내역
  - `_workspace/run-result.md` — 실행 결과
- **메시지 기반**: 팀 모드에서 에이전트 간 직접 통신

파일명 컨벤션: `{phase}_{agent}_{artifact}.md`

## 에러 핸들링

| 에러 유형 | 처리 방식 |
|----------|----------|
| Homebrew 미설치 | brew/setup.sh 먼저 실행 안내 |
| Cursor PATH 없음 | 경고 기록, 나머지 계속 진행 |
| JSON 파싱 오류 | 변경 중단, 원본 보존, 사용자 알림 |
| 스크립트 실패 | 에러 캡처, 다음 컴포넌트 계속, 최종 리포트에 포함 |

## 테스트 시나리오

### 정상 흐름: brew 패키지 추가

1. 사용자: "fzf를 Brewfile에 추가하고 설치해줘"
2. 오케스트레이터: W4 워크플로우 선택
3. config-manager: `brew/Brewfile`에 `brew "fzf"` 추가
4. 사용자 승인 후 setup-runner: `zsh brew/setup.sh` 실행
5. 결과: Brewfile 수정 + fzf 설치 완료 리포트

### 에러 흐름: Cursor PATH 없음

1. system-auditor: `cursor --list-extensions` 실패
2. 경고 기록: "Cursor not in PATH — 수동 확인 필요"
3. 나머지 감사(brew, symlinks) 계속 진행
4. 리포트에 경고 포함
