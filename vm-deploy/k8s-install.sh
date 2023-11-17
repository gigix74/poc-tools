echo [INIT] Update the system
sudo add-apt-repository ppa:openjdk-r/ppa -y && \
sudo apt-get update --fix-missing && \
sudo apt-get -y upgrade && \

echo [INIT] Install utils && \
sudo apt-get install net-tools git jq -y && \

echo [INIT] Install JDK8 && \
sudo apt-get install openjdk-8-jdk-headless -y && \

echo [INIT] Install Docker and Docker Compose && \
sudo apt-get install docker-compose -y && \

echo [INIT] usermod docker for user vagrant && \
sudo usermod -aG docker vagrant && \

echo "[INIT] Install gnupg2 (needed by docker login)" && \
sudo apt-get install -y gnupg2 pass && \

echo [INIT] Install bash completion && \
sudo apt-get install -y bash-completion && \

echo [INIT] Install kubectl && \
sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
sudo sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
sudo rm kubectl && \

echo [INIT] Install bash completion for kubectl && \
echo 'source <(kubectl completion bash)' >> /home/vagrant/.bashrc && \

echo [INIT] Install kind && \
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.16.0/kind-linux-amd64 && \
chmod +x ./kind && \
sudo mv ./kind /usr/local/bin/kind && \

echo [INIT] Install helm && \
sudo curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash && \
helm plugin install https://github.com/databus23/helm-diff && \

echo [INIT] Done!
