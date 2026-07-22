#!/usr/bin/env bash
set -euo pipefail

VERSIONS_FILE="versions.env"
RELEASES_URL="https://storage.googleapis.com/flutter_infra_release/releases/releases_linux.json"

releases_json=$(curl -fsSL "$RELEASES_URL")

get_latest_version_in_channel() {
  local channel=$1
  local channel_hash
  local version

  channel_hash=$(echo "$releases_json" | jq -r ".current_release.${channel}")
  version=$(echo "$releases_json" | jq -r --arg HASH "$channel_hash" \
    '.releases[] | select(.hash == $HASH).version')

  if [ -z "$version" ] || [ "$version" = "null" ]; then
    echo "Error fetching latest version in channel ${channel}" >&2
    exit 1
  fi

  echo "$version"
}

stable_version=$(get_latest_version_in_channel "stable")
beta_version=$(get_latest_version_in_channel "beta")

# Preserve ANDROID_SDK_VERSION if versions.env exists
android_sdk_version="36"
if [ -f "$VERSIONS_FILE" ]; then
  # shellcheck disable=SC1090
  source "$VERSIONS_FILE"
  android_sdk_version="${ANDROID_SDK_VERSION:-36}"
fi

cat > "$VERSIONS_FILE" <<EOF
# Flutter versions — updated by scripts/update_flutter_versions.sh
FLUTTER_STABLE=${stable_version}
FLUTTER_BETA=${beta_version}
ANDROID_SDK_VERSION=${android_sdk_version}
EOF

echo "Updated ${VERSIONS_FILE}:"
echo "  FLUTTER_STABLE=${stable_version}"
echo "  FLUTTER_BETA=${beta_version}"
echo "  ANDROID_SDK_VERSION=${android_sdk_version}"
