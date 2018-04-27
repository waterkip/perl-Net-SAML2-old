# Just a simple dockerfile
# We don't try to minimize layers or optimize the build
# We just want to see if the build will succeed
FROM perl:latest

COPY cpanfile .
RUN apt-get update \
    && apt-get install -y libssl1.0-dev libxml2-dev \
    && cpanm --installdeps . || (cat /root/.cpanm/work/*/build.log ; /bin/false)

COPY . .
RUN cpanm . || (cat /root/.cpanm/work/*/build.log ; /bin/false)
