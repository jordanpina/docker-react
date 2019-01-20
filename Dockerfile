# this is setup for production dockerfile

# build phase
# tag your base image
#everything below will now refer the base image as builder
FROM node:alpine as builder
WORKDIR '/app'
COPY package.json .
RUN npm install
COPY . .
# this will run on our build folder
RUN npm run build

# path to our build folder in the running container
# /app/build <-- all the stuff we want to copy over to our run phase

# now let's create the run phase

# run phase
# use nginx image as base, copy all the contents in the build folder from build phase, run nginx
# to start a new phase all we have to do is write FROM <image name>
# think of FROM in your dockerfile as sepearte blocks that run and then terminate
FROM nginx
# --from means from another phase
# --from takes two inputs
    # where we want to copy from
    # where we want to copy to in our nginx container
# https://hub.docker.com/_/nginx
    # under Hosting some simple static content
    # we can see where we should place our build contents in the nginx container   
COPY --from=builder /app/build /usr/share/nginx/html

# what about running nginx?
    # the default command for nginx starts the nginx container so we don't have to specify it here