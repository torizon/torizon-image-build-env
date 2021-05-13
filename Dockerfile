FROM crops/poky:debian-10

USER root

# Repo for setup
# JDK for OSTree push
# Vim for convenience
RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y \
    curl \
    default-jre \
    vim-tiny \
    git-lfs \
    && rm -rf /var/lib/apt/lists/*

RUN curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > /bin/repo && chmod a+x /bin/repo

# Script to automate env setup
COPY startup-tdx.sh /usr/bin/

USER usersetup
