# argocd deplyment
helm install my-release oci://registry-1.docker.io/bitnamicharts/argo-cd

# argocd cli installation
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64 -f
