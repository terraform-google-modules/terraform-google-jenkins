# Simple Example

This example illustrates how to use the jenkins-gce module.

## Agent Image

This example includes a [packer](https://www.packer.io) manifest for building a Jenkins agent image. The Terraform deployment expects this image to exist in your GCP account, and will fail if it does not. To build and upload the agent image, you can run `make pack`.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| jenkins\_instance\_metadata | Additional metadata to pass to the Jenkins master instance | map(string) | `<map>` | no |
| jenkins\_instance\_zone | The zone to deploy the Jenkins VM in | string | `"us-east4-b"` | no |
| jenkins\_network\_project\_id | The project ID of the Jenkins network | string | `""` | no |
| jenkins\_workers\_zone | The name of the zone into which to deploy Jenkins workers | string | `"us-east4-c"` | no |
| network | The GCP network to launch the instance in | string | `"default"` | no |
| project\_id | The project ID to deploy to | string | n/a | yes |
| region | The region to deploy to | string | `"us-east4"` | no |
| subnetwork | The GCP subnetwork to launch the instance in | string | `"default"` | no |

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
