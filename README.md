# Terraform with Ansible
Create two ec2 machines using terraform and run the ansible playbook that installs mysql and wordpress on both of them at the same time.

# Prerequisites
- Terraform
- Ansible
- AWS account

- The file ``vars.yml`` should define the following variables:
    ```yaml
    region: <AWS-REGION>
    access_key: <AWS-ACCESS-KEY-ID>
    secret_key: <AWS-SECRET-ACCESS-KEY>

    mysql_root_password: <MYSQL-ROOT-PASSWORD>
    mysql_db: <MYSQL-DB-NAME>
    mysql_user: <MYSQL-DB-USER>
    mysql_password: <MYSQL-DB-PASSWORD>
    ```

# Usage
1. Clone the repository
    ```bash
    git clone https://github.com/Ahmedelsa3eed/Terraform-With-Ansible
    cd Terraform-With-Ansible
    ```
2. Run the following commands to create the ec2 instances and install mysql and wordpress on them
    ```bash
    cd tf
    terraform init
    terraform apply
    ```