FROM ubuntu:20.04

RUN apt-get update && \
    apt-get install -y libx11-6 libfreetype6 libxrender1 libfontconfig1 libxext6 xvfb wget

RUN Xvfb :1 -screen 0 1024x768x16 &

ENV INSTALL="/tmp/install"

RUN mkdir -p ${INSTALL} && \
    cd ${INSTALL}

ARG SEGGER_VERSION

RUN wget -O ${INSTALL}/ses.tar.gz https://dl2.segger.com/files/embedded-studio/Setup_EmbeddedStudio_ARM_v${SEGGER_VERSION}_linux_x64.tar.gz && \
    tar xf ${INSTALL}/ses.tar.gz && \
    echo "yes" | DISPLAY=:1 $(find arm_segger_* -name "install_segger*") --copy-files-to /ses && \
    cd / && \
    rm -rf ${INSTALL}

ENV INSTALL=

RUN apt-get purge -y wget && apt autoremove -y && \
    rm -rf /arm_segger_embedded_studio_v${SEGGER_VERSION}_linux_x64

RUN ln -s /ses/bin/emBuild /usr/bin/emBuild

CMD ["emBuild"]