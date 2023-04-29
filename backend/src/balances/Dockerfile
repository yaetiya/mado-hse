FROM node:16-alpine

WORKDIR /usr/src/app

COPY package.json ./
COPY package-lock.json ./
# RUN apk add --update python make g++\
#    && rm -rf /var/cache/apk/*
RUN npm ci

COPY . .

RUN NODE_OPTIONS="--max-old-space-size=8192" npm run prebuild

COPY .env ./dist

RUN apk add bash
ENTRYPOINT ["sh", "-c"]

CMD ["node dist/index.js"]