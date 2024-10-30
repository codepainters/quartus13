FROM ubuntu:14.04 

ADD Quartus-web-13.0.1.232-linux.tar /install
ADD scripts /scripts

# I don't want separate layers!
RUN scripts/install.sh

