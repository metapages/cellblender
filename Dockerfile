FROM ubuntu:20.04

# Prerequisites


RUN apt-get update && apt-get install --no-install-recommends --yes python3.9 curl

RUN rm -f /etc/ssl/certs/ca-bundle.crt && \
    apt -y reinstall ca-certificates && \
    update-ca-certificates

ENV VERSION_CELLBLENDER=4.0.6
ENV VERSION_BLENDER=2.93

RUN mkdir -p /usr/local/bin && \
    curl https://mcell.org/downloads/Blender-${VERSION_BLENDER}-CellBlender-${VERSION_CELLBLENDER}-Debian-GNU-Linux-9-20220708.tar.gz \
        | tar -xzC /usr/local/bin



# WORKDIR /app
# RUN mkdir -p /app
# This does untar as well as copy, confused me for a bit
# ADD Blender-${VERSION_BLENDER}-CellBlender-${VERSION_CELLBLENDER}-Debian-GNU-Linux-9-20220708.tar.gz /usr/local/bin
# RUN ls
# RUN VERSION_CELLBLENDER=4.0.6 ; \
#     VERSION_BLENDER=2.93 ; \
#     mkdir -p /usr/local/bin && \
#     echo foo && \
#     ls
    # tar -xf Blender-${VERSION_BLENDER}-CellBlender-${VERSION_CELLBLENDER}-Debian-GNU-Linux-9-20220708.tar.gz -C /usr/local/bin

    #  && \
    # rm -rf Blender-${VERSION_BLENDER}-CellBlender-${VERSION_CELLBLENDER}-Debian-GNU-Linux-9-20220708.tar.gz
# Unify the just binary location on host and container platforms because otherwise the shebang doesn't work properly due to no string token parsing (it gets one giant string)

# Add mcell+cellblender to path
# https://mcell.org/mcell4_documentation/installation.html#setting-system-variable-mcell-path-and-adding-python-3-9-to-path
ENV BLENDER_DIR /usr/local/bin/Blender-${VERSION_BLENDER}-CellBlender
ENV PATH $PATH:${BLENDER_DIR}
ENV CELLBLENDER_BASE_PATH=${BLENDER_DIR}/2.93/
ENV MCELL_PATH=$CELLBLENDER_BASE_PATH/scripts/addons/cellblender/extensions/mcell/
ENV PATH=$PATH:$CELLBLENDER_BASE_PATH/python/bin/

WORKDIR /app
COPY model* /app/
