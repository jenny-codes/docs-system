# syntax=docker/dockerfile:1

FROM alpine:3.14.3

# Install asciidoctor
RUN apk -U add --no-cache \
  ruby
RUN gem install --no-document \
  "asciidoctor:2.0.16"

# Install development dependencies: The easy ones
RUN apk add --no-cache \
  make rsync websocketd

# Install development dependencies: fswatch
WORKDIR /usr/local/share
RUN apk add --no-cache \ 
  file git autoconf automake libtool gettext gettext-dev g++ texinfo curl
RUN git clone https://github.com/emcrisostomo/fswatch.git
RUN cd fswatch; ./autogen.sh && ./configure && make -j && make install

WORKDIR /app

EXPOSE 8080

CMD ["make"]