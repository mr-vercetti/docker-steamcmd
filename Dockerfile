FROM debian:stable-slim
LABEL maintainer="mr-vercetti"

# Install dependencies
RUN dpkg --add-architecture i386 && \
    apt-get update && apt-get install -y \
        bzip2 ca-certificates curl libarchive13 libstdc++6 lib32gcc-s1 libssl1.1:i386 \
        libstdc++6:i386 locales locales-all tmux zlib1g:i386 p7zip-full tar unzip wget xz-utils && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
        locale-gen --no-purge en_US.UTF-8 && \
    apt-get clean && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

ENV LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8
ENV APP_DIR="/app"
ENV STEAMCMD_DIR="${APP_DIR}/Steam/steamcmd"

# Set up user environment
RUN groupadd -r abc && \
    useradd -d ${APP_DIR} -r -g abc abc && \
    mkdir -p ${STEAMCMD_DIR} && \
    chown -R abc:abc ${APP_DIR}

USER abc
WORKDIR ${APP_DIR}

# Download and update steamcmd
RUN wget -qO- http://media.steampowered.com/installer/steamcmd_linux.tar.gz | tar xz -C ${STEAMCMD_DIR} && \
    chmod +x ${STEAMCMD_DIR}/steamcmd.sh && \
    ${STEAMCMD_DIR}/steamcmd.sh +force_install_dir ${STEAMCMD_DIR} +login anonymous +quit
