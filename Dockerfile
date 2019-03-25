FROM ubuntu:18.04

# OpenEmbedded Dependencies
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y g++-5-multilib \
    vim \
    curl \
    dosfstools \
    gawk \
    g++-multilib \
    gcc-multilib \
    lib32z1-dev \
    libcrypto++-dev:i386 \
    liblzo2-dev:i386 \
    lzop \
    libsdl1.2-dev \
    libstdc++-5-dev:i386 \
    libusb-1.0-0:i386 \
    libusb-1.0-0-dev:i386 \
    uuid-dev:i386 \
    texinfo \
    chrpath \
    gawk \
    wget \
    git-core \
    diffstat \
    unzip \
    texinfo \
    gcc-multilib \
    build-essential \
    chrpath \
    socat \
    cpio \
    python \
    python3 \
    python3-pip \
    python3-pexpect \
    xz-utils \
    debianutils \
    iputils-ping && \
    cd /usr/lib && \
    ln -s libcrypto++.so.9.0.0 libcryptopp.so.6
    

# Solve locales
RUN apt-get install -y locales && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales

ENV LANG en_US.UTF-8 

# Add user (bitbake won't allow root)
RUN useradd -ms /bin/bash user
USER user
WORKDIR /home/user

# Repo
RUN mkdir ~/bin && \ 
    curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > ~/bin/repo && \
    chmod a+x ~/bin/repo

# Torizon
RUN mkdir ~/torizon && \
    git config --global user.name username && \
    git config --global user.email you@email.com && \ 
    cd ~/torizon && ~/bin/repo init -u https://github.com/toradex/toradex-torizon-manifest -b master

ENV MACHINE $MACHINE

ENV TARGET $TARGET

COPY startup.sh .

USER root
RUN chmod 777 -R ./startup.sh

USER user

CMD [ "/bin/bash", "-c" , "./startup.sh" ]
