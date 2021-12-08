# Build Stage 1
# This build created a staging docker image
#
FROM node:17-alpine AS builder
WORKDIR /home/app
# alpine has no curl installed
RUN apk --no-cache add curl
# install pnpm globally
RUN curl -f https://get.pnpm.io/v6.16.js | node - add --global pnpm
# Please refer to https://pnpm.io/cli/fetch
COPY pnpm-lock.yaml /home/app
RUN pnpm fetch --dev
COPY . /home/app
RUN pnpm install -r --offline --dev
RUN "pnpm" "build"
# Build Stage 2
# This build takes the production build from staging build
#
FROM node:17-alpine@sha256:e64dc950217610c86f29aef803b123e1b6a4a372d6fa4bcf71f9ddcbd39eba5c
WORKDIR /home/app
# "type": "module" in package.json enables ES module in node
COPY --from=builder /home/app/package.json /home/app
COPY --from=builder /home/app/build /home/app
EXPOSE 3000
CMD "node" "/home/app"