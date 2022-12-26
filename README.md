# Daemonset to maintain high availability with Hetzner Cloud Floating IPs and keepalived

## Usage

- Assign two floating ip's for a and b daemonsets and set corresponding variables on configmap YAMLs.

- Create hcloud api token secret: `kubectl -n kube-system create secret generic hcloud --from-literal=token=<HCLOUD API TOKEN>`

- Create keepalived password secret: `kubectl -n kube-system create secret generic floating-ip --from-literal=keepalived_password=<KEEPALIVED PASSWORD, MAX 8 CHARACTERS>`

- Apply YAMLs:
```
kubectl apply -f rbac.yaml
kubectl apply -f floating-ip-a-configmap.yaml
kubectl apply -f floating-ip-a-daemonset.yaml
kubectl apply -f floating-ip-b-configmap.yaml
kubectl apply -f floating-ip-b-daemonset.yaml
```