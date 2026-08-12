# 2. Stand Up the Cluster (k3s)

k3s is a lightweight, single-binary Kubernetes distribution — ideal for a single node
or small team.

```sh
# install k3s (server)
curl -sfL https://get.k3s.io | sh -

# kubeconfig
sudo cat /etc/rancher/k3s/k3s.yaml   # copy to ~/.kube/config, adjust server IP

kubectl get nodes
```

Comes with a built-in ingress and local-path storage, so a single node is usable
immediately. Add cert-manager + an ingress controller as needed.
