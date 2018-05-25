FROM ubuntu:16.04

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install --assume-yes apt-utils

ENV APP_HOME=/usr/local/app \
    NODE_VERSION=8 \
    NPM_VERSION=5.5.1 \
    IONIC_VERSION=3.19.0 \
    CORDOVA_VERSION=8.0.0 \
    ANDROID_VERSION=6.4.0 \
    ANDROID_HOME=/opt/android-sdk-linux \
    GRADLE_VERSION=4.1 \
    GRADLE_USER_HOME=/opt/gradle \
    CORDOVA_ANDROID_GRADLE_DISTRIBUTION_URL=../../../../../../../../gradle-4.1-all.zip

ENV PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools/26.0.2:/opt/tools:/opt/gradle/bin

# INSTALL basics
RUN apt-get update -qqy \
    && apt-get install -y curl git \
    && curl -sL https://deb.nodesource.com/setup_"$NODE_VERSION".x | bash - \
    && apt-get install -yq nodejs \
    && npm install -g npm@"$NPM_VERSION" \
    && npm install -g cordova@"$CORDOVA_VERSION" ionic@"$IONIC_VERSION" \
    && cordova telemetry off \
    && npm cache clear --force \
    && apt-get -y autoclean \
    && rm -rf /var/lib/apt/lists/*

# ANDROID
# INSTALL python-software-properties
RUN apt-get update -qqy \
    && sed -i 's/kr.archive.ubuntu.com/ftp.daumkakao.com/g' /etc/apt/sources.list \
    && apt-get install -yq python-software-properties software-properties-common \
    && apt-get install -y openjdk-8-jdk \
    && rm -rf /var/lib/apt/lists/*

# ANDROID STUFF
RUN echo ANDROID_HOME="$ANDROID_HOME" >> /etc/environment \
    && apt-get update -qqy \
    && apt-get -y upgrade \
    && apt-get install -y --no-install-recommends apt-utils \
    && apt-get install -y wget unzip \
    && apt-get clean \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# INSTALL Gradle
RUN wget -O gradle-"$GRADLE_VERSION"-all.zip https://services.gradle.org/distributions/gradle-"$GRADLE_VERSION"-all.zip \
    && unzip -d /opt gradle-"$GRADLE_VERSION"-all.zip \
    && mv /opt/gradle-"$GRADLE_VERSION" /opt/gradle
    # && rm -rf gradle-"$GRADLE_VERSION"-all.zip

# INSTALL Android SDK and packages
RUN curl -o android-sdk.zip "https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip" \
    && echo "444e22ce8ca0f67353bda4b85175ed3731cae3ffa695ca18119cbacef1c1bea0 android-sdk.zip" | sha256sum -c \
    && unzip -Cq android-sdk.zip -d "$ANDROID_HOME" \
    && rm android-sdk.zip

RUN mkdir -p /root/.android \
  && touch /root/.android/repositories.cfg \
  && "$ANDROID_HOME"/tools/bin/sdkmanager --update 1> /dev/null

RUN echo y | $ANDROID_HOME/tools/bin/sdkmanager "build-tools;26.0.2" "platform-tools" "platforms;android-26" 1> /dev/null

# SET WORKSPACE
WORKDIR "$APP_HOME"

# Install Dependencies
COPY package.json .
RUN npm install

CMD ["sh", "-c", "./build.sh"]
