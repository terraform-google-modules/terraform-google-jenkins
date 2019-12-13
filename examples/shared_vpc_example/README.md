# Shared VPC Example

This example illustrates how to use the jenkins-gce module to deploy
Jenkins server to the network hosted in the shared VPC host project.

# Pre-requirements
Shared VPC host project, shared VPC service projects, shared network and sub-network should be created before.
[Example](../../test/setup/main.tf) how to do it in correct way is presented on `setup` folder.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| project\_id | The project ID to deploy jenkins to | string | n/a | yes |
| svpc\_host\_project\_id | The Shared VPC host project ID. In example the project the Jenkins network is hosted in | string | n/a | yes |
| svpc\_network\_name | The network in Shared VPC host account to deploy the Jenkins instance to | string | n/a | yes |
| svpc\_subnetwork\_name | The subnetwork name to deploy Jenkins to | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| jenkins\_instance\_initial\_password | The initial password for the `user` user on the Jenkins master |
| jenkins\_instance\_name | The name of the Jenkins master in GCP |
| jenkins\_instance\_public\_ip | The public IP address of the Jenkins master |
| jenkins\_instance\_zone | The name of the Jenkins zone in GCP |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
