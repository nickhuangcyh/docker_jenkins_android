FROM jenkins/jenkins:lts-jdk11

LABEL maintainer="NickHuang <nickhuang@climax.com.tw>"

# ANDROID_HOME ENV
ENV ANDROID_HOME=/opt/android-sdk-linux 

USER root

RUN apt-get update
RUN yes | apt-get install zip unzip
RUN yes | apt-get install python3

# Create android sdk directory and change user:group permission
RUN mkdir -p ${ANDROID_HOME}
RUN chown -R jenkins:jenkins ${ANDROID_HOME}

# Download gdrive binary file into /usr/local/bin and change own/mod
RUN curl https://raw.githubusercontent.com/nickhuangcyh/gdrive-binaries/main/linux/gdrive-linux-x64 --output /usr/local/bin/gdrive
RUN chown jenkins:jenkins /usr/local/bin/gdrive
RUN chmod a+x /usr/local/bin/gdrive

USER jenkins

# Download sdkmanager
RUN cd ${ANDROID_HOME} \
    && curl -o commandlinetools.zip https://dl.google.com/android/repository/commandlinetools-linux-6200805_latest.zip \
    && unzip commandlinetools.zip \
    && rm commandlinetools.zip

# Download android sdk, ndk and tools
RUN ${ANDROID_HOME}/tools/bin/sdkmanager --sdk_root=${ANDROID_HOME} --list
RUN yes | ${ANDROID_HOME}/tools/bin/sdkmanager --sdk_root=${ANDROID_HOME} --licenses 
RUN ${ANDROID_HOME}/tools/bin/sdkmanager --sdk_root=${ANDROID_HOME} "platform-tools" "platforms;android-28" "ndk-bundle"
ENV PATH=${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools
