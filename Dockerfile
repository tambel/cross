FROM ubuntu:20.04 as build-ct-ng

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update

RUN apt install -y tar curl
RUN apt install -y autoconf \
        bison \
        build-essential \
        flex \
        gawk \
        gettext \
        g++ \
        help2man \
        libncurses-dev \
        libtool-bin \
        texinfo \
        unzip

RUN curl --output crosstool-ng-1.25.0.tar.gz -L https://github.com/crosstool-ng/crosstool-ng/archive/refs/tags/crosstool-ng-1.25.0.tar.gz

RUN tar -xzvf crosstool-ng-1.25.0.tar.gz
WORKDIR crosstool-ng-crosstool-ng-1.25.0

RUN ./bootstrap




RUN ./configure --prefix=/usr/local
RUN make -j "$(nproc)"
RUN make install

#FROM ubuntu:20.04
#ENV DEBIAN_FRONTEND=noninteractive
#RUN apt update
#RUN apt install make build

#COPY --from=build-ct-ng /tmp/ct-ng /

RUN useradd -ms /bin/bash user
USER user

WORKDIR /home/user

#USER root
#RUN apt install -y gawk

USER user

RUN ct-ng x86_64-centos6-linux-gnu

RUN ct-ng build