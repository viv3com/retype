FROM ubuntu:18.04

RUN apt-get update -y
RUN apt-get install nodejs npm curl wget -y
RUN npm install -g n && n 16 && npm i --g npm@latest

# Installing Dotnet 5 arm64 and setting new PATH for dotnet cli to work
RUN mkdir /lib/dotnet-arm64 && tar zxf /tmp/dotnet-sdk-5.0.100-linux-arm64.tar.gz -C /lib/dotnet-arm64
ENV DOTNET_ROOT=/lib/dotnet-arm64
ENV PATH=/lib/dotnet-arm64:$PATH
ENV PATH=$PATH:/root/.dotnet/tools
RUN dotnet tool install --global retypeapp

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY ./package.json /usr/src/app/
RUN npm install && npm cache clean --force
COPY ./ /usr/src/app
ENV NODE_ENV production
ENV PORT 80
EXPOSE 80

RUN retype build
CMD node app.js