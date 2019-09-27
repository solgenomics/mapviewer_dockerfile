
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
RUN apt-get install build-essential pkg-config apt-utils gnupg2 curl -y
RUN apt-get update --fix-missing -y
RUN apt-get install -y nginx git sudo lynx

RUN apt-get install cpanminus -y
RUN apt-get install make
RUN apt-get install gcc
RUN cpanm -L /home/production/local-lib inc::Module::Install
RUN cpanm -L /home/production/local-lib Catalyst::Devel
RUN cpanm -L /home/production/local-lib Catalyst::Runtime
RUN cpanm -L /home/production/local-lib MooseX::HasDefaults
RUN cpanm -L /home/production/local-lib Mason
RUN cpanm -L /home/production/local-lib Catalyst::View::HTML::Mason

ENV PERL5LIB=/home/production/local-lib/lib/perl5:$PERL5LIB

WORKDIR /home/production
RUN git clone https://github.com/solgenomics/jscview.git
WORKDIR /home/production/jscview
RUN git checkout gobi

ENTRYPOINT /home/production/jscview/script/jscview_server.pl -r -d --fork



