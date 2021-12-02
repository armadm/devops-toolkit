FROM alpine:3.15 AS builder
ARG TERRAFORM_VERSION
ARG KUBECTL_VERSION
ARG HELM_VERSION
ARG ISTIOCTL_VERSION

# Install requirements
RUN apk update \
 && apk add gnupg  tree curl

# Install terraform
RUN curl -LO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
RUN unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
RUN rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip
RUN chmod +x terraform
RUN mv terraform /usr/local/bin

# Install kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl
RUN chmod +x kubectl
RUN mv kubectl /usr/local/bin/kubectl

# Install Helm
RUN curl -LO https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz
RUN tar -xvzf helm-v${HELM_VERSION}-linux-amd64.tar.gz
RUN rm helm-v${HELM_VERSION}-linux-amd64.tar.gz
RUN chmod +x linux-amd64/helm
RUN mv linux-amd64/helm /usr/local/bin/


# Install istioctl
RUN curl -LO https://github.com/istio/istio/releases/download/${ISTIOCTL_VERSION}/istio-${ISTIOCTL_VERSION}-linux-amd64.tar.gz
RUN tar -zxf istio-${ISTIOCTL_VERSION}-linux-amd64.tar.gz
RUN mv istio-${ISTIOCTL_VERSION}/bin/istioctl /usr/local/bin/


FROM ubuntu:20.04
ENV TZ=Europe/Moscow

COPY --from=builder /usr/local/bin/* /usr/local/bin/

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone
# Install latest ansible
RUN apt update -y && apt upgrade -y  && \
    apt install -y python3 python3-pip  && \
    pip3 install ansible

# Install extra tools
RUN apt install -y mc vim tcpdump curl httpie





