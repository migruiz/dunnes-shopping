FROM openjdk:11
USER root
VOLUME /root/.gradle
ENV FLUTTER_SDK_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.16.4-stable.tar.xz" \
    FLUTTER_SDK="/usr/local/flutter" 



# Install Android SDK Tools
ENV ANDROID_HOME "/home/circleci/android-sdk"
ENV ANDROID_SDK_ROOT $ANDROID_HOME
ENV CMDLINE_TOOLS_ROOT "${ANDROID_HOME}/cmdline-tools/latest/bin"
ENV ADB_INSTALL_TIMEOUT 120
ENV PATH "${ANDROID_HOME}/emulator:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/platform-tools/bin:${PATH}"
# You can find the latest command line tools here: https://developer.android.com/studio#command-tools
RUN SDK_TOOLS_URL="https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip" && \
	mkdir -p ${ANDROID_HOME}/cmdline-tools && \
	mkdir ${ANDROID_HOME}/platforms && \
	mkdir ${ANDROID_HOME}/ndk && \
	wget -O /tmp/cmdline-tools.zip -t 5 "${SDK_TOOLS_URL}" && \
	unzip -q /tmp/cmdline-tools.zip -d ${ANDROID_HOME}/cmdline-tools && \
	rm /tmp/cmdline-tools.zip && \
	mv ${ANDROID_HOME}/cmdline-tools/cmdline-tools ${ANDROID_HOME}/cmdline-tools/latest

RUN echo y | ${CMDLINE_TOOLS_ROOT}/sdkmanager "tools" && \
	echo y | ${CMDLINE_TOOLS_ROOT}/sdkmanager "platform-tools" && \
	echo y | ${CMDLINE_TOOLS_ROOT}/sdkmanager "build-tools;33.0.0"         

RUN echo y | ${CMDLINE_TOOLS_ROOT}/sdkmanager "platforms;android-33"


RUN apt-get update && \
apt-get install -yqq --no-install-recommends lib32stdc++6  && rm -rf /var/lib/apt/lists/*

# Download Android SDK
RUN mkdir "$FLUTTER_SDK"  \
    && cd "$FLUTTER_SDK" \
    && curl -o fluttersdk.tar.xz $FLUTTER_SDK_URL \
    && tar -xf fluttersdk.tar.xz \
    && rm fluttersdk.tar.xz


RUN $cd /flutter/bin/flutter precache
RUN $FLUTTER_SDK/flutter/bin/flutter doctor -v 
