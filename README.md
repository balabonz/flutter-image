# Flutter Docker Images

Self-maintained Flutter container images published to GitHub Container Registry (GHCR). Inspired by [cirruslabs/docker-images-flutter](https://github.com/cirruslabs/docker-images-flutter), with versions you control and automated builds via GitHub Actions.

## Quick start

```bash
docker run --rm -it -v "${PWD}:/build" -w /build \
  ghcr.io/<owner>/flutter:stable flutter test
```

Replace `<owner>` with your GitHub username or organization.

## Available tags

| Tag | Description |
|-----|-------------|
| `stable` | Latest stable Flutter release |
| `latest` | Alias for `stable` |
| `beta` | Latest beta Flutter release |
| `X.Y.Z` | Immutable version pin (e.g. `3.44.7`) |
| `X.Y.Z-N.pre` | Beta version pin (e.g. `3.47.0-0.1.pre`) |

Images are built for `linux/amd64` and `linux/arm64`.

## Use in GitHub Actions

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    container:
      image: ghcr.io/<owner>/flutter:stable
    steps:
      - uses: actions/checkout@v4
      - run: flutter pub get
      - run: flutter test
```

Pin to an exact version for reproducible CI:

```yaml
container:
  image: ghcr.io/<owner>/flutter:3.44.7
```

## Use locally

```bash
# Pull
docker pull ghcr.io/<owner>/flutter:stable

# Verify toolchain
docker run --rm ghcr.io/<owner>/flutter:stable flutter doctor -v

# Build APK
docker run --rm -v "${PWD}:/build" -w /build \
  ghcr.io/<owner>/flutter:stable flutter build apk
```

## How versions are updated

1. [`versions.env`](versions.env) is the source of truth for Flutter stable/beta and Android SDK versions.
2. The [Check Flutter versions](.github/workflows/check-versions.yml) workflow runs every 6 hours and opens a PR when new releases are available.
3. Merging a version bump triggers [Build and Push](.github/workflows/build-push.yml), which builds multi-arch images and runs `flutter doctor` as a smoke test.

To update manually:

```bash
bash scripts/update_flutter_versions.sh
git add versions.env && git commit -m "chore: update Flutter versions"
```

## First-time setup

After pushing this repo to GitHub:

1. Wait for the **Build and Push** workflow to complete.
2. Go to **Packages** → `flutter` → **Package settings** → **Change visibility** → **Public**.
3. Pull and verify:

```bash
docker pull ghcr.io/<owner>/flutter:stable
docker run --rm ghcr.io/<owner>/flutter:stable flutter doctor -v
```

## Base image

Built on [`ghcr.io/cirruslabs/android-sdk`](https://github.com/cirruslabs/docker-images-android) with Flutter cloned from the official [flutter/flutter](https://github.com/flutter/flutter) repository.

## Limitations

- **iOS builds** are not supported in Linux containers (use macOS runners).
- Android SDK base image is sourced from Cirrus Labs; if that image becomes unavailable, update `ANDROID_SDK_VERSION` in `versions.env` or switch to a custom Android SDK Dockerfile.

## License

MIT
