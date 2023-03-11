# Proxmox + Kubernetes Infrastructure as a Code

> Provisioning Kubernetes on Proxmox with Ansible and Terraform

## What is this project about?

This project aims to provision Kubernetes on a Proxmox server and consists of three stages:

- Stage 1: Ansible
  In this stage, a VM template is prepared for use on the Proxmox server. Additionally, SSH is configured for the Proxmox server.

- Stage 2: Terraform
  This stage involves launching servers for Kubernetes nodes. Once provisioning is complete, Terraform generates an `inventory.yml` file for use in Stage 3.

- Stage 3: Ansible
  This stage involves bootstrapping Kubernetes clusters by following the steps outlined in ["Bootstrapping clusters with kubeadm"](<https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/>).

## Prerequisite

1. Set up Terraform Cloud and create an API key.

2. Install Proxmox on a server.

3. Node installed in your computer.

4. It is assumed that the VMs will use IP addresses in the range of 192.168.1.150 to 192.168.1.152.

## Steps

### Stage 0: Setup the environment

1. Copy the .env.sample file to a new file named .env and configure it accordingly.

2. Ensure that you have an SSH key file ready for use with Proxmox (e.g., ~/.ssh/id_rsa.pub).

### Stage 1: Prepare VM template

1. Add the public key located at ~/.ssh/id_rsa.pub to the authorized_keys file for the root user on Proxmox.

2. Verify access by running the following commands:

    ```bash
    $ npm run docker:exec
    /srv# cd stage1
    /srv/stage1# ansible all -i "inventories/inventory.yml" -m ping
    ```

3. Prepare the VM template by running the following command:

    ```bash
    /srv/stage1# ansible-playbook --become -i "inventories/inventory.yml" prepare-vm.yml
    ```

### Stage 2: Launch VM for Kubernetes nodes

1. Initialize Terraform by running the following commands:

    ```bash
    $ npm run docker:exec
    /srv# cd stage2
    /srv/stage2# terraform workspace select <workspace name>
    /srv/stage2# terraform init
    ```

2. Provision VM nodes using Terraform by running the following commands:

    ```bash
    /srv/stage2# terraform plan
    /srv/stage2# terraform apply
    ```

### Stage 3: Provision Kubernetes

1. Verify access by running the following commands:

    ```bash
    $ npm run docker:exec
    /srv# cd stage3
    /srv/stage3# ansible all -i "inventories/inventory.yml" -m ping
    ```

2. Setup Kubernetes by running the following command:

    ```bash
    /srv/stage3# ansible-playbook --become -i "inventories/inventory.yml" setup-kubernetes.yml
    ```

### Stage 4: Provision services

TBD

## Troubleshooting

### If you need to add an ssh passphrase, then use ssh-add

```bash
eval "$(ssh-agent)"
ssh-add
```

Please note that this process has been added to the .bashrc file, and therefore it will automatically execute when you launch the Docker container.

## Todo

- [ ] CI to validate/lint code
- [ ] Support upgrade
- [ ] Add Terraform to deploy some helm charts
