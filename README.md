# Daemonset to maintain high availability with Hetzner Cloud Floating IPs and keepalived

## Usage

- Create two floating ip's on Hetzner Cloud console for a and b daemonsets and set corresponding variables on configmap YAMLs.

```
  DOMAIN: "<DOMAIN USED ON SERVER HOSTNAMES>" # Domain name used on server hostnames. Will be used on hcloud commands to identify servers.
  FLOATING_IP: "<HETZNER FLOATING IP A/B>" # Floating IP address
  FLOATING_IP_ID: "<HETZNER FLOATING IP A/B ID>" # Floating ip ID can be seen from Cloud console or which `hcloud floating-ip list`.
  FLOATING_INTERFACE: "eth0" # Default is eth0 for cloud server public ip's
  MASTER_NODE: "<PREFERRED MASTER NODE HOSTNAME>" # Set different preferred node for a and b to keep ip's assigned to different nodes
```

- Create hcloud api token secret:

```
kubectl -n kube-system create secret generic hcloud \
--from-literal=token=<HCLOUD API TOKEN>
```

- Create keepalived password secret:

```
kubectl -n kube-system create secret generic floating-ip \
--from-literal=keepalived_password=<KEEPALIVED PASSWORD, MAX 8 CHARACTERS>
```

- Apply YAMLs:

```
kubectl apply -f rbac.yaml
kubectl apply -f floating-ip-a-configmap.yaml
kubectl apply -f floating-ip-a-daemonset.yaml
kubectl apply -f floating-ip-b-configmap.yaml
kubectl apply -f floating-ip-b-daemonset.yaml
```
