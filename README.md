# Kubernetes on Openstack with Terraform

Provision a Kubernetes cluster with [Terraform](https://www.terraform.io) on Openstack

## Status
This project is still a concept. Please DO NOT USE on production clusters.

## Requirements

- [Install Terraform](https://www.terraform.io/intro/getting-started/install.html)
- [Ubuntu 16.04 image](http://cloud-images.ubuntu.com/releases/16.04/release/ubuntu-16.04-server-cloudimg-amd64-disk1.img)

### Quick run

```
$ terraform init
$ terraform plan \
      -var "username=$OS_USERNAME" \
      -var "password=$OS_PASSWORD" \
      -var "tenant=$OS_TENANT_NAME" \
      -var "auth_url=$OS_AUTH_URL" \
      -var "tenant_id=$OS_TENANT_ID"
$ terraform apply \
      -var "username=$OS_USERNAME" \
      -var "password=$OS_PASSWORD" \
      -var "tenant=$OS_TENANT_NAME" \
      -var "auth_url=$OS_AUTH_URL" \
      -var "tenant_id=$OS_TENANT_ID"
```

### Destroy

```
$ terraform destroy \
      -var "username=$OS_USERNAME" \
      -var "password=$OS_PASSWORD" \
      -var "tenant=$OS_TENANT_NAME" \
      -var "auth_url=$OS_AUTH_URL" \
      -var "tenant_id=$OS_TENANT_ID"
```
