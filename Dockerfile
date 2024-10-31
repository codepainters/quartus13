FROM ubuntu:14.04 

ARG TARBALL=""

ADD ${TARBALL} /install
ADD scripts /scripts

ENV QUARTUS_64BIT=1

# I don't want separate layers!
RUN scripts/install.sh

