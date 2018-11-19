FROM blueapron/node:6.10.3-static

MAINTAINER O&L Inventory <ol-inventory@blueapron.com>

WORKDIR /opt/bwip-js

COPY package.json /opt/bwip-js

RUN npm install

ARG GIT_COMMIT
ENV GIT_COMMIT ${GIT_COMMIT}

COPY . /opt/bwip-js
