FROM node:16.10

WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn install

COPY . .
EXPOSE 3000

CMD ["node", "index.js"]