FROM ubuntu:20.04

RUN apt-get update && \
    apt-get install -y libx11-6 libfreetype6 libxrender1 libfontconfig1 libxext6 xvfb curl unzip zip

RUN Xvfb :1 -screen 0 1024x768x16 &

ENV INSTALL="/tmp/install"


RUN mkdir -p ${INSTALL} && \
    cd ${INSTALL}

COPY ./ses/ses.tar.gz .

RUN tar xf ses.tar.gz && \
    echo "yes" | DISPLAY=:1 $(find arm_segger_* -name "install_segger*") --copy-files-to /ses && \
    cd .. && \
    rm -rf ${INSTALL}

ENV INSTALL=

CMD ["/ses/bin/emBuild"]