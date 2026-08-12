# 4. Secrets with Sealed Secrets

## The problem

Kubernetes `Secret` objects are only base64-encoded, not encrypted — anyone with
cluster read access (or repo access, if you commit Secret YAML) can read them.

## Sealed Secrets

The Bitnami sealed-secrets controller runs in the cluster and holds a private key.
You encrypt secrets with `kubeseal` into a `SealedSecret` that only that controller
can decrypt — so it's safe to commit to Git.

```sh
# install controller
helm repo add sealed-secrets https://bitnami.github.io/sealed-secrets
helm install sealed-secrets sealed-secrets/sealed-secrets -n kube-system

# install matching kubeseal CLI (version must match the controller)

# seal a secret
kubectl create secret generic app-secret \
  --from-literal=DB_PASSWORD='REPLACE' \
  --dry-run=client -o yaml \
  | kubeseal --controller-namespace kube-system --format yaml \
  > sealed-app-secret.yaml   # <- commit THIS, not the plaintext
```

## Critical: back up the controller key

Lose the controller's private key and every sealed secret becomes undecryptable.

```sh
kubectl get secret -n kube-system \
  -l sealedsecrets.bitnami.com/sealed-secrets-key -o yaml > master.key
# store OFF-cluster (password manager), never in Git
```

## Notes

- `SealedSecret`s are scoped to namespace+name — resealing for a different
  namespace/name won't decrypt.
- Sealing protects secrets *in Git*. Tightening RBAC and encrypting etcd at rest are
  separate, complementary layers.
