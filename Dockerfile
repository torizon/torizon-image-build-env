FROM crops/poky:debian-10

USER root

# Repo for setup
# JDK for OSTree push
# Vim for convenience
RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y \
    curl \
    default-jre \
    vim-tiny \
    && rm -rf /var/lib/apt/lists/*

RUN curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > /bin/repo
RUN chmod a+x /bin/repo

# Script to automate env setup
COPY startup-tdx.sh startup-tdx.sh /usr/bin/
RUN chmod 755 \
    /usr/bin/startup-tdx.sh

# JSON file for Toradex Easy Installer server over HTTP
COPY image_list.json /etc/

USER usersetup
