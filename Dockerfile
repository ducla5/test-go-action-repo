##### golang container for installing dependencies and building application #####
FROM golang:1.13-alpine

RUN apk update && apk add build-base

ADD goapp /goapp
WORKDIR /goapp
ARG ENV_TYPE
ENV ENV_TYPE $ENV_TYPE

#install dependencies and build
RUN go build -tags ${ENV_TYPE} api

##### container for running binary file #####
FROM alpine

RUN apk update && apk add libaio libaio-dev libnsl libc6-compat gcompat bash

ADD ./oracle/instantclient_12_1.tar.gz /usr/lib

# to run the application, it is necessary to extract all  libraries.
RUN ln -s /usr/lib/libclntsh.so.12.1 /usr/lib/libclntsh.so && \
    ln -s /usr/lib/libocci.so.12.1 /usr/lib/libocci.so && \
    ln -s /usr/lib/libnsl.so.2 /usr/lib/libnsl.so.1

ENV PATH /usr/lib:$PATH
ENV ORACLE_BASE /usr/lib
ENV LD_LIBRARY_PATH /usr/lib
ENV TNS_ADMIN /usr/lib
ENV ORACLE_HOME /usr/lib

WORKDIR /api

COPY --from=0 /goapp/api /api
COPY ./oracle/tnsnames.ora /usr/lib/tnsnames.ora

CMD ./api
