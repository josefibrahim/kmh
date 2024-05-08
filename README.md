Steps:
1. Clone repo
2. Run ./pipeline.sh
3. When asked, enter your docker username
4. Visit localhost:8080 to view running nodejs app
5. Visit https://hub.docker.com/ to view the pushed docker image

Assumptions:
1. npm is installed
2. docker is installed
3. docker daemon is running
4. docker is configured to run without sudo
5. The project is a Node.js project
6. The project has a package.json file
7. The project has a test script in the package.json file, named test
8. The project has a start script in the package.json file, named start
9. The project does not have a Dockerfile, and it is expected to be created by the script