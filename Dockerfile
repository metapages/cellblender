FROM ubuntu:20.04

###############################################################################
# Prerequisites
###############################################################################
RUN apt-get update && apt-get install --no-install-recommends --yes python3.9 curl

RUN rm -f /etc/ssl/certs/ca-bundle.crt && \
    apt -y reinstall ca-certificates && \
    update-ca-certificates
###############################################################################


###############################################################################
# mcell, cellblender, and blender
###############################################################################
ENV VERSION_CELLBLENDER=4.0.6
ENV VERSION_BLENDER=2.93

RUN mkdir -p /usr/local/bin && \
    curl https://mcell.org/downloads/Blender-${VERSION_BLENDER}-CellBlender-${VERSION_CELLBLENDER}-Debian-GNU-Linux-9-20220708.tar.gz \
        | tar -xzC /usr/local/bin

# Add mcell+cellblender to path
# https://mcell.org/mcell4_documentation/installation.html#setting-system-variable-mcell-path-and-adding-python-3-9-to-path
ENV BLENDER_DIR /usr/local/bin/Blender-${VERSION_BLENDER}-CellBlender
ENV PATH $PATH:${BLENDER_DIR}
ENV CELLBLENDER_BASE_PATH=${BLENDER_DIR}/2.93/
ENV MCELL_PATH=$CELLBLENDER_BASE_PATH/scripts/addons/cellblender/extensions/mcell/
ENV PATH=$PATH:$CELLBLENDER_BASE_PATH/python/bin/
###############################################################################


###############################################################################
# Last setup:
# Assume we want all the outputs copied
###############################################################################
WORKDIR /outputs
