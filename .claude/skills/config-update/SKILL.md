---
name: config-update
description: macOS dotfiles 설정 파일 변경 스킬. Brewfile에 패키지 추가, vscode-extensions.txt에 익스텐션 추가, .zshrc에 alias/export 추가, cursor settings.json 수정, .gitconfig 변경을 처리한다. "추가해줘", "설치해줘", "Brewfile에", "alias 추가", "익스텐션 추가", "설정 변경", "zshrc 수정", "git 설정" 등의 요청 시 반드시 이 스킬을 사용할 것.
---

# Config Update Skill

## 목적

레포 내 dotfiles를 수정한다. 수정 후 변경된 내용을 명확히 알리고, 필요하면 관련 setup 스크립트 실행을 안내한다.

## 파일별 수정 가이드

### Brewfile (`brew/Brewfile`)

CLI 도구는 `brew "이름"`, GUI 앱은 `cask "이름"` 형식으로 추가한다.
기존 섹션 구분(`# brew`, `# cask(GUI)`)을 유지한다.

**추가 예시:**
```
# brew 섹션에
brew "fzf"

# cask(GUI) 섹션에
cask "arc"
```

변경 후 실행 필요: `zsh brew/setup.sh` (또는 `brew bundle --file=brew/Brewfile`)

### 익스텐션 목록 (`cursor/vscode-extensions.txt`)

한 줄에 익스텐션 ID 하나. 알파벳 순 정렬을 권장한다.

변경 후 실행 필요: `xargs -n 1 cursor --install-extension < cursor/vscode-extensions.txt`

### Zsh 설정 (`zsh/.zshrc`)

섹션별 위치를 지켜서 추가한다:
- alias: `# alias` 섹션 하단
- export/PATH: 관련 섹션 하단 또는 파일 상단
- 기타 초기화: 파일 하단

변경 후 실행: `source ~/.zshrc` (심링크가 걸려 있으면 자동 반영됨)

### Cursor 설정 (`cursor/settings.json`)

JSON 형식을 유지한다. 수정 후 JSON 유효성을 확인한다:
```bash
python3 -m json.tool cursor/settings.json > /dev/null && echo "valid" || echo "invalid JSON"
```

### Git 전역 설정 (`git/.gitconfig`)

`[섹션]` 구조를 유지한다. 새 섹션이면 기존 섹션 아래에 추가한다.

## 수정 절차

1. 해당 파일을 먼저 읽는다 (현재 내용 파악)
2. 요청된 변경이 이미 존재하는지 확인한다 (중복 방지)
3. 수정한다
4. 변경 내용을 사용자에게 알린다
5. 필요한 후속 명령(setup 스크립트)을 안내한다

## 출력 형식

수정 완료 후:
```
변경 완료:
- brew/Brewfile: cask "arc" 추가

후속 조치 (선택):
brew bundle --file=brew/Brewfile
```

## 에이전트 위임

복수 파일 변경이나 드리프트 기반 일괄 업데이트가 필요하면 `config-manager` 에이전트에 위임한다.
