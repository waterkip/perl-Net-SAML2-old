# Dockerfile for building Net::SAML2
#
# This Dockerfile shouldn't be used for production machines as we do not
# try to be super efficient nor do we do our best to keep the image size
# small. You'll want to use a multi-stage build for that.
#
# This file does allow you to quickly test the sources on a given Perl
# version.
#
# Pick any perl https://hub.docker.com/_/perl/
FROM perl:latest

ENV DEBIAN_FRONTEND=noninteractive \
    NO_NETWORK_TESTING=1

COPY cpanfile .

RUN apt-get update \
  && apt-get install -y libssl1.0-dev libxml2-dev \
  # IPC::System::Simple is dep of DateTime and friends with a unstable
  # testsuite. It fails and succeeds the run after.
  && cpanm -n IPC::System::Simple \
  # Non-declared, or otherwise failing dependency modules
  && cpanm LWP::UserAgent \
  && cpanm XML::XPath \
  # END Non-declared, or otherwise failing dependency modules
  && cpanm --installdeps . \
  || (cat /root/.cpanm/work/*/build.log ; /bin/false) \
  && apt-get purge -y libssl1.0-dev libxml2-dev \
  && apt-get autoremove -y \
  && rm -rf /root/.cpanm /var/lib/apt/ /var/cache/apt/

COPY . .
