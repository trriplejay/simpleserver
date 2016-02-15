FROM node:4-onbuild
ARG mytag="none"
ENV BUILD_NUMBER=$mytag
EXPOSE 8888
