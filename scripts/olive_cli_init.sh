#!/bin/bash
set -e 

PROJECT_NAME=""
OLIVE_TOKEN=""
SOURCE_PATH=""
USER_CONFIG_PATH=""
DEBUG="false"

while [[ $# -gt 0 ]]; do
  case $1 in
    --project-name)
      PROJECT_NAME="$2"
      shift 2
      ;;
    --olive-token)
      OLIVE_TOKEN="$2"
      shift 2
      ;;
    --source-path)
      SOURCE_PATH="$2"
      shift 2
      ;;
    --user-config-path)
      USER_CONFIG_PATH="$2"
      shift 2
      ;;
    --debug)
      DEBUG="$2"
      shift 2
      ;;
    *)
      echo "알 수 없는 옵션: $1"
      exit 1
      ;;
  esac
done

echo '📋 Step 2: Initializing Olive CLI...'

# debug 옵션 설정
DEBUG_OPTION=""
if [ "$DEBUG" = "true" ]; then
  DEBUG_OPTION="-d"
  echo "🐛 디버그 모드가 활성화되었습니다."
else
  echo "📝 일반 모드로 실행합니다."
fi

if [ -n "$USER_CONFIG_PATH" ] && [ -f "$USER_CONFIG_PATH" ]; then
  echo "🔧 사용자 정의 config 파일을 사용합니다: $USER_CONFIG_PATH"
  olive-cli init "$PROJECT_NAME" -t=$OLIVE_TOKEN -s $SOURCE_PATH -f $DEBUG_OPTION -c $USER_CONFIG_PATH
else
  echo "🔧 기본 설정으로 초기화합니다."
  olive-cli init "$PROJECT_NAME" -t=$OLIVE_TOKEN -s $SOURCE_PATH -f $DEBUG_OPTION
fi

if [ $? -ne 0 ]; then
  echo '❌ Olive CLI 초기화 실패: 에러가 발생했습니다.'
  exit 1
fi

echo '✅ .olive folder contents:' && ls -al .olive

LOCAL_CONFIG_FILE=".olive/local-config.yaml"

if [ -f "$LOCAL_CONFIG_FILE" ]; then
  echo '✅ local-config.yaml 파일을 찾았습니다. jdk11Home 설정을 추가합니다.'
  
  echo '📄 변경 전 local-config.yaml 내용:'
  cat "$LOCAL_CONFIG_FILE" | grep -A3 'scanInfo:'
  
  # scanInfo 섹션에 jdk11Home 추가
  sed -i '/scanInfo:/,/executed:/ s|^\( *\)executed: .*|\1executed: null\n\1jdk11Home: /opt/openjdk-11|' "$LOCAL_CONFIG_FILE"
  
  echo '📄 변경 후 local-config.yaml 내용:'
  cat "$LOCAL_CONFIG_FILE" | grep -A4 'scanInfo:'
else
  echo '⚠️ 경고: local-config.yaml 파일을 찾을 수 없습니다. jdk11Home 설정을 건너뜁니다.'
fi
