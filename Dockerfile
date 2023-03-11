# syntax=docker/dockerfile:1
FROM --platform=$BUILDPLATFORM alpine:3.17

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG BUILDARCH

ARG KUBECTL_VERSION=1.26.2
ARG HELM_VERSION=3.11.2
ARG TERRAFORM_VERSION=1.4.0

# BUILDPLATFORM=linux/arm64/v8, TARGETPLATFORM=linux/arm64/v8, BUILDARCH=arm64
RUN echo "BUILDPLATFORM=$BUILDPLATFORM, TARGETPLATFORM=$TARGETPLATFORM, BUILDARCH=$BUILDARCH" 

WORKDIR /srv

# For installing Ansible
COPY requirements-* /tmp

RUN set -eux; \
    \
    apk add --no-cache \
    ca-certificates=20220614-r4 \
    curl=7.88.1-r0 \
    bash=5.2.15-r0 \
    && \
    \
    cd /tmp && \
    # Install kubectl - https://dl.k8s.io/release/v1.26.1/bin/linux/arm64/kubectl
    curl -L https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/${BUILDARCH}/kubectl \
    -o /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl && \
    kubectl version --short || true && \
    \
    # Install Helm - https://get.helm.sh/helm-v3.11.1-linux-arm64.tar.gz
    curl -L https://get.helm.sh/helm-v${HELM_VERSION}-linux-${BUILDARCH}.tar.gz | tar xz && \
    mv linux-${BUILDARCH}/helm /usr/local/bin/helm && \
    chmod +x /usr/local/bin/helm && \
    rm -rf linux-${BUILDARCH} && \
    helm version && \
    \
    # Install Terraform - https://releases.hashicorp.com/terraform/1.3.9/terraform_1.3.9_linux_arm64.zip
    wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${BUILDARCH}.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_${BUILDARCH}.zip && \
    rm terraform_${TERRAFORM_VERSION}_linux_${BUILDARCH}.zip && \
    mv terraform /usr/local/bin/terraform && \
    terraform version && \
    \
    # Install Ansible
    apk add --no-cache \
    openssh=9.1_p1-r2 \
    sshpass=1.09-r1 \
    gcc=12.2.1_git20220924-r4 \
    libc-dev=0.7.2-r3 \
    libffi-dev=3.4.4-r0	\
    python3-dev=3.10.10-r0 \
    py3-pip=22.3.1-r1 \
    && \
    pip install --no-cache-dir -r /tmp/requirements-pip.txt && \
    ansible --version && \
    # Run Ansible Galaxy to install required collections
    ansible-galaxy install -r /tmp/requirements-ansible.yml && \
    \
    # Cleanup
    rm -rf /var/cache/apk/* /usr/share/doc /usr/share/man/ /usr/share/info/* /var/cache/man/* /tmp/*

COPY container/ /

COPY . .
