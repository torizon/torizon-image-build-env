FROM crops/poky

USER root

# Repo for setup
# JDK for OSTree push
# Vim for convenience
RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y \
    repo \
    default-jre \
    vim-tiny \
    && apt-get autoremove -y \
	&& apt-get purge -y --auto-remove \
	&& rm -rf /var/lib/apt/lists/*

# Script to automate env setup
COPY startup-tdx-torizon.sh startup-tdx-poky.sh /usr/bin/
RUN chmod 755 \
    /usr/bin/startup-tdx-torizon.sh \
	/usr/bin/startup-tdx-poky.sh

# JSON file for Toradex Easy Installer server over HTTP
COPY image_list.json /etc/

USER usersetup
