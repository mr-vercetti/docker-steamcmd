FROM debian:stable-slim
LABEL maintainer="mr-vercetti"

# Install dependencies
RUN dpkg --add-architecture i386 && \
    apt-get update && apt-get install -y \
        bzip2 ca-certificates curl libarchive13 lib32gcc-s1 locales p7zip-full tar unzip wget xz-utils && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
        locale-gen --no-purge en_US.UTF-8 && \
    apt-get clean && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

# General vars
ENV LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8
ENV STEAMCMD_DIR="/steam/steamcmd"
ENV OUTPUT_DIR="/output"

# Set up user environment
RUN groupadd -r abc && \
    useradd -d ${STEAMCMD_DIR} -r -g abc abc && \
    mkdir -p ${STEAMCMD_DIR} ${OUTPUT_DIR} && \
    chown -R abc:abc ${STEAMCMD_DIR} ${OUTPUT_DIR}

USER abc
WORKDIR ${STEAMCMD_DIR}

# Download and update steamcmd
RUN wget -qO- http://media.steampowered.com/installer/steamcmd_linux.tar.gz | tar xz -C ${STEAMCMD_DIR} && \
    chmod +x ${STEAMCMD_DIR}/steamcmd.sh && \
    ${STEAMCMD_DIR}/steamcmd.sh +force_install_dir ${STEAMCMD_DIR} +login anonymous +quit
