############################################################
# Dockerfile to build EPACTS

FROM ubuntu:18.04

USER root

RUN apt-get update && apt-get install -y build-essential apt-utils gnuplot5 git zlib1g-dev ghostscript groff vim
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata
RUN dpkg-reconfigure --frontend noninteractive tzdata

RUN apt-get update && apt-get install -y gcc-5 g++-5 automake libtool
RUN apt-get update && apt-get install -y --no-install-recommends \
    r-base-core \
    r-recommended \
 	r-base \
 	wget \
	libbz2-dev \
	liblzma-dev \
	curl

RUN cd /usr/local/bin && curl https://getmic.ro | bash
#RUN apt-get update && apt-get install -y libtool && 

#RUN mkdir /home/epacts && chmod 777 /home/epacts

RUN ln -s /usr/bin/gcc-5 /usr/local/bin/gcc
RUN ln -s /usr/bin/g++-5 /usr/local/bin/g++

ENV PATH=/usr/local/bin:$PATH

#RUN git clone https://github.com/statgen/EPACTS.git
#RUN git clone https://github.com/megarbi/EPACTS_SKATOh.git

#RUN cp -r ./src usr/src && cp -r ./data usr/data /usr/local/share/EPACTS && cp -r ./scripts usr/local/bin

COPY ./ /EPACTS_SKATOh

#WORKDIR ./
WORKDIR /EPACTS_SKATOh

RUN autoreconf -vfi
#RUN CC="gcc-5" CXX="g++-5" ./configure --prefix /home/epacts
RUN CC="gcc-5" CXX="g++-5" ./configure --prefix /usr/local
RUN make -j 1
RUN make -j 1 install

#ENV EPACTS_DIR=/usr/epacts
ENV EPACTS_DIR=/usr/local
WORKDIR /usr/local/bin
