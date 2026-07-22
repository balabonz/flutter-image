# Flutter Docker Images

Ready-to-use Flutter SDK images for CI and local development, published on GitHub Container Registry.

```bash
docker pull ghcr.io/balabonz/flutter:stable
```

Use them the same way you would [cirruslabs/flutter](https://github.com/cirruslabs/docker-images-flutter) — mount your project and run `flutter` commands inside the container.

## Why this image?

[Cirrus Labs stopped updating their Flutter images in May 2026](https://github.com/cirruslabs/docker-images-flutter). This registry keeps Flutter images up to date on a regular schedule so your pipelines do not break when you need a current SDK.

Each image includes:

- Flutter SDK (stable or beta channel)
- Android SDK and accepted licenses
- `linux/amd64` and `linux/arm64` support

## Current versions

| Channel | Tag | Flutter version |
|---------|-----|-----------------|
| Stable | `stable`, `latest` | 3.44.7 |
| Beta | `beta` | 3.47.0-0.1.pre |

Pin an exact version for reproducible builds:

```bash
ghcr.io/balabonz/flutter:3.44.7
ghcr.io/balabonz/flutter:3.47.0-0.1.pre
```

## Quick start

Run tests in your project directory:

```bash
docker run --rm -it \
  -v "${PWD}:/build" -w /build \
  ghcr.io/balabonz/flutter:stable \
  flutter test
```

Check that the toolchain is healthy:

```bash
docker run --rm ghcr.io/balabonz/flutter:stable flutter doctor -v
```

Build an Android APK:

```bash
docker run --rm \
  -v "${PWD}:/build" -w /build \
  ghcr.io/balabonz/flutter:stable \
  flutter build apk
```

## Use in CI

### GitHub Actions

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    container:
      image: ghcr.io/balabonz/flutter:stable
    steps:
      - uses: actions/checkout@v4
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test
```

For reproducible CI, pin a specific version instead of a moving tag:

```yaml
container:
  image: ghcr.io/balabonz/flutter:3.44.7
```

### Other CI systems

Any runner that supports Docker can use the same image:

```bash
docker run --rm \
  -v "$CI_PROJECT_DIR:/build" -w /build \
  ghcr.io/balabonz/flutter:stable \
  flutter test
```

## Available tags

| Tag | When to use |
|-----|-------------|
| `stable` | Default for most projects — tracks the latest stable Flutter release |
| `latest` | Alias for `stable` |
| `beta` | Try upcoming Flutter releases before they reach stable |
| `X.Y.Z` | Lock CI to an exact stable version |
| `X.Y.Z-N.pre` | Lock CI to an exact beta version |

Moving tags (`stable`, `latest`, `beta`) are updated when new Flutter releases are published. Version tags (e.g. `3.44.7`) stay immutable.

## What is inside

- **Base image:** [`ghcr.io/cirruslabs/android-sdk:36`](https://github.com/cirruslabs/docker-images-android)
- **Flutter source:** cloned from the official [`flutter/flutter`](https://github.com/flutter/flutter) repository
- **Pre-cached:** Android artifacts and accepted Android licenses

## Limitations

- **iOS builds are not supported.** Linux containers cannot build for iOS — use a macOS runner for that.
- **Web and Linux desktop** tooling may require extra packages depending on your project. This image is optimized for common Android CI workflows.

## Package registry

Images are hosted at:

**https://github.com/balabonz/flutter-image/pkgs/container/flutter**

## For maintainers

This repository builds and publishes the images above. If you are contributing to the registry itself:

1. Flutter versions are defined in [`versions.env`](versions.env).
2. [`check-versions.yml`](.github/workflows/check-versions.yml) checks for new Flutter releases every 6 hours and opens a PR when updates are available.
3. [`build-push.yml`](.github/workflows/build-push.yml) builds multi-arch images and runs `flutter doctor` as a smoke test after each version change.

### Build a specific Flutter version from GitHub Actions

To publish an older or custom Flutter version without editing code:

1. Go to **Actions** → **Build and Push** → **Run workflow**
2. Enter the Flutter version (e.g. `3.35.0`) in **flutter_version**
3. Optionally override **android_sdk_version** (defaults to the value in `versions.env`)
4. Click **Run workflow**

This publishes only the version tag (e.g. `ghcr.io/balabonz/flutter:3.35.0`). It does **not** update `stable`, `latest`, or `beta`.

Leave **flutter_version** empty to build the current stable and beta versions from `versions.env` (same as a push to `main`).

### Bump current stable/beta versions

```bash
bash scripts/update_flutter_versions.sh
git add versions.env
git commit -m "chore: update Flutter versions"
```

## License

MIT
