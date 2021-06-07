FROM node:14.1.0-alpine3.11
#build settings
ADD app /Fargate
RUN npm install aws-sdk express -g
# RUN echo 'export NODE_PATH=$(npm root -g)' >> ~/.bashrc
#run settings
WORKDIR /Fargate
EXPOSE 3000
ENV NODE_PATH /usr/local/lib/node_modules
CMD ["node","app.js"]