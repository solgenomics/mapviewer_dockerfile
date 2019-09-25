
FROM debian:stretch

LABEL maintainer="mrf252@cornell.edu"

ENV CPANMIRROR=http://cpan.cpantesters.org

# open port 3000
#
EXPOSE 3000

# create directory layout
#
RUN mkdir -p /home/production/local-lib
RUN mkdir /var/log/sgn

RUN apt-get update -y
RUN apt-get install cpanminus -y
RUN apt-get install make
RUN apt-get install gcc
RUN cpanm -L /home/production/local-lib Catalyst::Devel
RUN cpanm -L /home/production/local-lib Catalyst::Runtime
RUN cpanm -L /home/production/local-lib Mason

ENV PERL5LIB=/home/production/local-lib/lib/perl5:$PERL5LIB

WORKDIR /home/production
RUN git clone https://github.com/solgenomics/jscview.git

WORKDIR /home/production/jscview

ENTRYPOINT /home/production/jscview/script/jscview_server -r -d --fork



