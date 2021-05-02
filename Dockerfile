FROM ubuntu:20.04

# install apps
RUN apt-get update &&  \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install build-essential curl docker docker-compose file git golang gzip htop hub jq locales nodejs python3 ruby-full sudo unzip wget zip zsh-y && \
    rm -rf /var/lib/apt/lists/* \
    && sudo apt-get upgrade -y

# Terraform and Packer
ENV TERRAFORM_VERSION="0.15.1"
ENV PACKER_VERSION="1.7.2"

RUN wget "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -O /tmp/terraform.zip && unzip /tmp/terraform.zip -d/usr/bin && rm /tmp/terraform.zip
RUN wget "https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip" -O /tmp/packer.zip && unzip /tmp/packer.zip -d /usr/bin && rm /tmp/packer.zip


# Awscli v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
RUN unzip /tmp/awscliv2.zip -d /tmp/ && \
    ./tmp/aws/install


# done installing apps, now for user config stuff
RUN localedef -i en_US -f UTF-8 en_US.UTF-8
RUN useradd -m -s /usr/bin/zsh vscode \
    && echo 'user ALL=(ALL) NOPASSWD:ALL' >>/etc/sudoers
USER vscode
WORKDIR /home/vscode
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
RUN wget "https://raw.githubusercontent.com/vmorganp/setupscript/master/zsh/.zshrc" -O ~/.zshrc

CMD [ "sleep", "infinity"]
