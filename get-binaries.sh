#!/usr/bin/env bash
set -e

for i in "$@"; do
  case $i in
  --copy | --copy=true)
    COPY=yes
    shift
    ;;
  --upgrade=*)
    UPGRADE="${i#*=}"
    ;;
  --upgrade)
    UPGRADE=latest
    shift
    ;;
  -g=* | --global-bin-dir=*)
    GLOBAL_BIN_DIR="${i#*=}"
    shift
    ;;
  -f=* | --file=*)
    BINARIES_FILE="${i#*=}"
    shift
    ;;
  *) ;;

  esac
done

echo "Get binaries"
echo "----------------------"
PLATFORM=$([[ $OSTYPE == darwin* ]] && echo darwin || echo linux)
BIN_DIR=$(pwd)/bin
DEFAULT_GLOBAL_BIN_DIR=/usr/local/bin
GLOBAL_BIN_DIR=${GLOBAL_BIN_DIR:-$DEFAULT_GLOBAL_BIN_DIR}
BINARIES_FILE=${BINARIES_FILE:-.binaries}

echo "Platform              ${PLATFORM}"
echo "Local bin directory   ${BIN_DIR}"
echo "Global bin directory  ${GLOBAL_BIN_DIR}"
echo "Binaries file         ${BINARIES_FILE}"
echo "----------------------"

function gb_platform() {
  echo "$PLATFORM"
}

function gb_checksum_sha256() {
  local SHA
  if [[ "$PLATFORM" == "darwin" ]]; then
    SHA=$(shasum --algorithm=256 "$1")
  else
    SHA=$(sha256sum "$1")
  fi
  echo "${SHA%% *}"
}

function gb_lockfile_check() {
  local NAME=$1
  local PLATFORM=$2
  local CHECKSUM=$3
  if [[ -z "$BINARIES_FILE" ]]; then
    return 0
  fi
  local LOCKFILE="$BINARIES_FILE.lock"
  if [[ ! -f "$LOCKFILE" ]]; then
    touch "$LOCKFILE"
    echo "Lockfile for $BINARIES_FILE has been created. Add it to your git repository."
  fi
  local locksum
  while read -r lockname platform checksum; do
    if [[ "$lockname" == "$NAME" && "$platform" == "$PLATFORM" ]]; then
      locksum=$checksum
      break
    fi
  done <"$LOCKFILE"
  if [[ -z "$lockname" ]]; then
    echo "${NAME} not found in lockfile. Adding..."
    echo "${NAME} ${PLATFORM} ${CHECKSUM}" >>"$LOCKFILE"
    return 0
  fi
  if [[ $locksum != "$CHECKSUM" ]]; then
    echo "${NAME}: checksum does not match: '${locksum}' (from lock) != '${CHECKSUM}' (from file)"
    echo "Remove the specific line from lockfile if you changed binary version"
    return 1
  fi
}

function gb_filesize() {
  du -k "$1" | cut -f1
  return $?
}

function gb_fetch() {
  local NAME
  local VERSION
  local URL
  local DARWIN_PLATFORM=darwin
  local LINUX_PLATFORM=linux
  for p in "$@"; do
    case $p in
    --version=*)
      local VERSION="${p#*=}"
      shift
      ;;
    --name=*)
      local NAME="${p#*=}"
      shift
      ;;
    --url=*)
      URL="${p#*=}"
      shift
      ;;
    --darwin=*)
      DARWIN_PLATFORM="${p#*=}"
      shift
      ;;
    --linux=*)
      LINUX_PLATFORM="${p#*=}"
      shift
      ;;
    *) ;;
    esac
  done

  local URL_PLATFORM
  case "$PLATFORM" in
  darwin) URL_PLATFORM="$DARWIN_PLATFORM" ;;
  linux) URL_PLATFORM="$LINUX_PLATFORM" ;;
  esac

  URL=${URL//\{version\}/${VERSION}}
  URL=${URL//\{platform\}/${URL_PLATFORM}}
  local FILE="${BIN_DIR}/${NAME}"
  local TMP_FILE="${FILE}.tmp"
  local CHECKSUM

  if [[ -f "$FILE" ]]; then
    echo "→ ${NAME}: 😎 Already exists ($(gb_filesize "$FILE") kB)."
  else
    echo "→ ${NAME}: 📦 Fetching ${VERSION} from ${URL}..."
    mkdir -p "${BIN_DIR}"
    curl -fsSL "${URL}" -o "$TMP_FILE"
    CHECKSUM=$(gb_checksum_sha256 "$TMP_FILE")
    echo "→ ${NAME}: 🧮 Got file with sha256 checksum: ${CHECKSUM}"
    gb_lockfile_check "$NAME" "$PLATFORM" "$CHECKSUM"
    if [[ "$URL" =~ \.tar\.gz$ ]]; then
      echo "→ ${NAME}: 🗃 Unpacking..."
      tar xz -f "$TMP_FILE" -C "${BIN_DIR}"
    elif [[ "$URL" =~ \.zip$ ]]; then
      echo "→ ${NAME}: 🗃 Unpacking..."
      unzip "$TMP_FILE" -d "${BIN_DIR}"
    else
      cp "$TMP_FILE" "$FILE"
    fi
    rm "$TMP_FILE"
    echo "→ ${NAME}: 🎟 Setting executable access rights..."
    chmod +x "${FILE}"
    echo "→ ${NAME}: 👍 Ready ($(gb_filesize "$FILE") kB)!"
  fi
  if [[ "$COPY" == "yes" ]]; then
    echo "→ ${NAME}: 👍 Copying to ${GLOBAL_BIN_DIR}..."
    cp "${FILE}" "${GLOBAL_BIN_DIR}/${NAME}"
  fi
}

function gb_summary() {
  echo ""
  echo "Fetched binaries live in ${BIN_DIR} now."
  if [[ -z "$COPY" ]]; then
    echo "Append '--copy' to this command to install binaries to a global location, so they could be accessed from anywhere on your machine (default path is ${DEFAULT_GLOBAL_BIN_DIR}, if you want to copy binaries to a different one, just specify it as follows: '--global-bin-dir=/my/path')."
  fi

  export PATH=${BIN_DIR}:$PATH
  echo ""
  echo "If you sourced this script, '${BIN_DIR}' directory has been added to your \$PATH"
}

# Upgrade to the latest version
if [[ "$UPGRADE" ]]; then
  if [[ $0 != $BASH_SOURCE ]]; then
    echo "Script is being sourced, use upgrade option directly on get-binaries.sh"
    exit 1
  fi
  echo "Self-update in progress..."
  curl -fsSL "https://raw.githubusercontent.com/krzysztof-miemiec/get-binaries/${UPGRADE}/get-binaries.sh" -o "$0"
  exit 0
fi

# Process passed binaries file if it exists
if [[ -f "$BINARIES_FILE" ]]; then
  while read -r name version url rest; do
    params=""
    for r in $rest; do params="$params --$r"; done
    gb_fetch --name="$name" --version="$version" --url="$url" $params
  done <"$BINARIES_FILE"

  gb_summary
fi
