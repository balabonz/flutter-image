ARG ANDROID_SDK_VERSION=36
FROM ghcr.io/cirruslabs/android-sdk:${ANDROID_SDK_VERSION}

ARG IMAGE_SOURCE=https://github.com/OWNER/REPO
LABEL org.opencontainers.image.source=${IMAGE_SOURCE}

USER root

ARG FLUTTER_VERSION

ENV FLUTTER_HOME=/sdks/flutter \
    FLUTTER_VERSION=${FLUTTER_VERSION} \
    FLUTTER_ROOT=/sdks/flutter \
    PATH=${PATH}:/sdks/flutter/bin:/sdks/flutter/bin/cache/dart-sdk/bin

RUN git clone --depth 1 --branch ${FLUTTER_VERSION} \
      https://github.com/flutter/flutter.git ${FLUTTER_HOME} \
 && yes | flutter doctor --android-licenses \
 && flutter doctor \
 && chown -R root:root ${FLUTTER_HOME} \
 && flutter precache --android
