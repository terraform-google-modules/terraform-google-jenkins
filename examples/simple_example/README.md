# Simple Example

This example illustrates how to use the jenkins-gce module.

## Agent Image

This example includes a [packer](https://www.packer.io) manifest for building a Jenkins agent image. The Terraform deployment expects this image to exist in your GCP account, and will fail if it does not. To build and upload the agent image, you can run `make pack`.

[^]: (autogen_docs_start)


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| credentials_path | The path to a Google Cloud Service Account credentials file | string | - | yes |
| jenkins_instance_metadata | Additional metadata to pass to the Jenkins master instance | map | `<map>` | no |
| network | The GCP network to launch the instance in | string | `default` | no |
| project_id | The project ID to deploy to | string | - | yes |
| region | The region to deploy to | string | - | yes |
| subnetwork | The GCP subnetwork to launch the instance in | string | `default` | no |

## Outputs

| Name | Description |
|------|-------------|
| jenkins_instance_initial_password | The initial password for the `user` user on the Jenkins master |
| jenkins_instance_name | The name of the Jenkins master in GCP |
| jenkins_instance_public_ip | The public IP address of the Jenkins master |
| jenkins_instance_zone | The GCP zone the Jenkins instance was launched into |

[^]: (autogen_docs_end)

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure