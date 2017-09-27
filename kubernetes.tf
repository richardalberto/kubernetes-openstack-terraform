data "template_file" "cloud_conf" {
    template = "${file("templates/cloud.conf")}"

    vars {
        auth_url = "${var.auth_url}"
        username = "${var.username}"
        password = "${var.password}"
        tenant_id = "${var.tenant_id}"
        region = "${var.region}"
    }
}

resource "openstack_compute_instance_v2" "master" {
    name = "${var.cluster_name}-master-${count.index}"
    count = "1"
    image_name = "${var.glance_image_name}"
    flavor_name = "${var.kubernetes_flavor}"
    key_pair = "${var.key_pair_name}"

    network {
        name = "${var.network_name}"
    }

    security_groups = [
        "${var.security_group_name}"
    ]

    provisioner "file" {
        source = "files"
        destination = "/tmp/stage"
        connection {
            user = "ubuntu"
            private_key = "${file(var.private_key_path)}"
        }
    }

    provisioner "file" {
        content = "${data.template_file.cloud_conf.rendered}"
        destination = "/tmp/stage/cloud.conf"
        connection {
            user = "ubuntu"
            private_key = "${file(var.private_key_path)}"
        }
    }

    provisioner "remote-exec" {
        inline = [
            "sudo chmod +x /tmp/stage/prepare.sh",
            "sudo /tmp/stage/prepare.sh",
        ]
        connection {
            user = "ubuntu"
            private_key = "${file(var.private_key_path)}"
        }
    }

    provisioner "remote-exec" {
        inline = [
            "sudo chmod +x /tmp/stage/master.sh",

            "sed -i 's/TOKEN/${var.token}/' /tmp/stage/*",

            "sudo /tmp/stage/master.sh",

            "sudo cp /tmp/stage/10-kubeadm.conf /etc/systemd/system/kubelet.service.d",
            "sudo cp /tmp/stage/cloud.conf /etc/kubernetes",

            "sudo systemctl daemon-reload",
            "sudo systemctl restart kubelet",
        ]
        connection {
            user = "ubuntu"
            private_key = "${file(var.private_key_path)}"
        }
    }
}

resource "openstack_compute_instance_v2" "node" {
    name = "${var.cluster_name}-node-${count.index}"
    count = "2"
    image_name = "${var.glance_image_name}"
    flavor_name = "${var.kubernetes_flavor}"
    key_pair = "${var.key_pair_name}"

    network {
        name = "${var.network_name}"
    }

    security_groups = [
        "${var.security_group_name}"
    ]

    provisioner "file" {
        source = "files"
        destination = "/tmp/stage"
        connection {
            user = "ubuntu"
            private_key = "${file(var.private_key_path)}"
        }
    }

    provisioner "file" {
        content = "${data.template_file.cloud_conf.rendered}"
        destination = "/tmp/stage/cloud.conf"
        connection {
            user = "ubuntu"
            private_key = "${file(var.private_key_path)}"
        }
    }

    provisioner "remote-exec" {
        inline = [
            "sudo chmod +x /tmp/stage/prepare.sh",
            "sudo /tmp/stage/prepare.sh",
        ]
        connection {
            user = "ubuntu"
            private_key = "${file(var.private_key_path)}"
        }
    }

    provisioner "remote-exec" {
        inline = [
            "sudo chmod +x /tmp/stage/join.sh",

            "sed -i 's/MASTER_IP/${openstack_compute_instance_v2.master.0.network.0.fixed_ip_v4}/' /tmp/stage/*",
            "sed -i 's/TOKEN/${var.token}/' /tmp/stage/*",

            "sudo /tmp/stage/join.sh",

            "sudo cp /tmp/stage/10-kubeadm.conf /etc/systemd/system/kubelet.service.d",
            "sudo cp /tmp/stage/cloud.conf /etc/kubernetes",

            "sudo systemctl daemon-reload",
            "sudo systemctl restart kubelet",
        ]
        connection {
            user = "ubuntu"
            private_key = "${file(var.private_key_path)}"
        }
    }
    depends_on = [
        "openstack_compute_instance_v2.master",
    ]
}
