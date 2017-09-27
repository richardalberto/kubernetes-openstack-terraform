variable "glance_image_name" {
    default = "ubuntu-16.04"
}

variable "node_count" {
    default = 2
}

variable "cluster_name" {
    default = "kubernetes"
}

variable "kubernetes_flavor" {
    default = "m1.xlarge"
}

variable "kubernetes_token" {
    default = "kubernetes"
}

variable "kubernetes_user" {
    default = "admin"
}

variable "username" {
    description = "Your openstack username"
}

variable "password" {
    description = "Your openstack password"
}

variable "tenant" {
    description = "Your openstack tenant/project"
}

variable "tenant_id" {
    description = "Your openstack tenant id"
}

variable "auth_url" {
    description = "Your openstack auth URL"
}

variable "region" {
    description = "Your openstack region"
    default = "RegionOne"
}

variable "security_group_name" {
    description = "Security group name"
    default = "allow-all"
}

variable "kubernetes_version" {
    description = "Kubernetes version to download"
    default = "v1.7.6"
}

variable "network_id" {
    description = "neutron network id"
}

variable "network_name" {
    default = "internal"
}

variable "key_pair_name" {
    description = "Name of the key_pair to use"
}

variable "private_key_path" {
    description = "Private key to access nodes"
    default = "~/.ssh/id_rsa.pub"
}

variable "token" {
    description = "Kubeadm token. A token can be generate with `kubeadm token generate`"
}