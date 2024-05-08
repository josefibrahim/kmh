#!/bin/bash

#remove node-modules if found for a clear installation
[ -d node-modules ] && rm node-modules -rf && echo 'removed node-modules'

#install dependencies in package.json
echo 'Installing dependencies ..'
npm install || exit 1

#auditing
echo 'Running audit ..'
npm audit

# check if .eslintrc.js file exists, if not, create it with default configuration
if [ ! -f .eslintrc.js ]; then
    echo 'Creating .eslintrc.js ..'
    echo "module.exports = {
    env: {
        es2021: true,
        node: true,
    },
    extends: [
        'eslint:recommended',
    ],
    parserOptions: {
        ecmaVersion: 12,
        sourceType: 'module',
    },
    rules: {
    },
};" > .eslintrc.js  || exit 1
fi

#run eslint
#yes | npm init @eslint/config@latest #--config .eslintrc.json --force 
#npm init @eslint/config@latest -- --config eslint-config-standard

echo 'Running eslint ..'
#npx eslint .  || exit 1

# delete .eslintrc.js file
rm .eslintrc.js

#run unit test
echo 'Running unit tests ..'
npm run test || exit 1

#node . || exit 1

# create .dockerignore file
echo "node_modules" > .dockerignore

# create Dockerfile
echo 'Creating Docker File ..'
echo "FROM node:22

COPY package.json /usr/src/app/

WORKDIR /usr/src/app

RUN npm install

COPY . /usr/src/app

ENV PORT 3001

EXPOSE 3001

CMD [\"npm\", \"run\", \"start\"]
" > Dockerfile  || exit 1


# build docker image
docker build -t kmh_image .

# run docker container
docker run -d --rm -p 8080:3001 --name kmh_container kmh_image

#integration test
npm run test:integration

echo 'Enter username for tagging and pushing docker image:'
read docker_user

# push docker image
echo 'Tagging image ..'
docker tag kmh_image $docker_user/kmh_image

docker login

echo 'Pushing image ..'
docker push $docker_user/kmh_image

# remove Dockerfile and .dockerignore files
rm Dockerfile
rm .dockerignore