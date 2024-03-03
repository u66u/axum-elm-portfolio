FROM node:latest

WORKDIR /app

RUN npm install -g elm elm-spa

COPY . .

RUN npm install

CMD ["elm-spa", "server"]

