FROM alpine:3.6
LABEL maintainer "ocowchun@gmail.com"
RUN apk -v --update add \
        python \
        py-pip \
        groff \
        less \
        mailcap \
        curl \
        tar \
        gzip \
        ca-certificates \
        git \
        openssh-client\
        && \
    pip install --upgrade awscli==1.16.82 && \
    apk -v --purge del py-pip && \
    rm /var/cache/apk/*
RUN curl -L -o /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v1.11.2/bin/linux/amd64/kubectl; \
    chmod +x /usr/local/bin/kubectl
RUN curl -o /usr/local/bin/aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.11.5/2018-12-06/bin/linux/amd64/aws-iam-authenticator; \
    chmod +x /usr/local/bin/aws-iam-authenticator

ENV HELM_VERSION=v2.12.1
ENV HELM_FILENAME=helm-${HELM_VERSION}-linux-amd64.tar.gz
ENV HELM_SHA256SUM=891004bec55431b39515e2cedc4f4a06e93782aa03a4904f2bd742b168160451
RUN curl -L https://storage.googleapis.com/kubernetes-helm/${HELM_FILENAME} > ${HELM_FILENAME} && \
    echo "${HELM_SHA256SUM}  ${HELM_FILENAME}" > helm_${HELM_VERSION}_SHA256SUMS && \
    sha256sum -cs helm_${HELM_VERSION}_SHA256SUMS && \
    tar zxv -C /tmp -f ${HELM_FILENAME} && \
    rm -f ${HELM_FILENAME} && \
    mv /tmp/linux-amd64/helm /usr/local/bin/helm