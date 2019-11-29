# Terraform Jenkins GCE Module

This module handles the creation of a GCE instance running [Jenkins](https://jenkins.io/), configured to [run builds on Google Cloud](https://cloud.google.com/solutions/using-jenkins-for-distributed-builds-on-compute-engine). Creates an instance that can be logged into with the username `user` and the password `bitnami`.

## Compatibility

 This module is meant for use with Terraform 0.12. If you haven't [upgraded](https://www.terraform.io/upgrade-guides/0-12.html)
  and need a Terraform 0.11.x-compatible version of this module, the last released version intended for
  Terraform 0.11.x is [v0.1.0](https://registry.terraform.io/modules/terraform-google-modules/jenkins/google/0.1.0).

## Usage

Please see the [examples](./examples/) folder.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| create\_firewall\_rules | If worker firewall rules should be created | bool | `"false"` | no |
| gcs\_bucket | The name of an existing GCS bucket to associate with the created service account, allowing build artifacts to be uploaded. Leave blank to skip | string | `""` | no |
| jenkins\_boot\_disk\_source\_image | The name of the disk image to use as the boot disk for the Jenkins master | string | `"bitnami-jenkins-2-176-2-0-linux-debian-9-x86-64"` | no |
| jenkins\_boot\_disk\_source\_image\_project | The project within which the disk image to use as the Jenkins master boot disk exists | string | `"bitnami-launchpad"` | no |
| jenkins\_initial\_password | The initial password to protect Jenkins logins with. Defaults to a random 8-character alphanumeric string. This may not contain special characters. | string | `""` | no |
| jenkins\_instance\_access\_cidrs | CIDRs to allow to access Jenkins over HTTP(s) | list(string) | `<list>` | no |
| jenkins\_instance\_additional\_metadata | Additional instance metadata to assign to the Jenkins VM | map(string) | `<map>` | no |
| jenkins\_instance\_machine\_type | The machine type to provision for Jenkins | string | `"n1-standard-4"` | no |
| jenkins\_instance\_name | The name to assign to the Jenkins VM | string | `"jenkins"` | no |
| jenkins\_instance\_network | The GCP network to deploy the Jenkins VM in. The firewall rules will be created in the project which hosts this network. | string | n/a | yes |
| jenkins\_instance\_subnetwork | The GCP subnetwork to deploy the Jenkins VM in | string | n/a | yes |
| jenkins\_instance\_tags | Tags to assign to the Jenkins VM | list(string) | `<list>` | no |
| jenkins\_instance\_zone | The zone to deploy the Jenkins VM in | string | n/a | yes |
| jenkins\_jobs | A list of Jenkins jobs to configure on the instance | list | `<list>` | no |
| jenkins\_network\_project\_id | The project ID of the Jenkins network | string | `""` | no |
| jenkins\_service\_account\_display\_name | The display name of the service account to create for Jenkins VM provisioning | string | `"Jenkins"` | no |
| jenkins\_service\_account\_name | The name of the service account to create for Jenkins VM provisioning | string | `"jenkins"` | no |
| jenkins\_workers\_boot\_disk\_size\_gb | The size of Jenkins worker boot disks, in gigabytes | string | `"10"` | no |
| jenkins\_workers\_boot\_disk\_source\_image | The fully qualified URL to the disk image to use as the boot disk for Jenkins workers | string | `"ubuntu-1604-xenial-v20181023"` | no |
| jenkins\_workers\_boot\_disk\_source\_image\_project | The project within which the disk image to use as the Jenkins worker boot disk exists | string | `"ubuntu-os-cloud"` | no |
| jenkins\_workers\_boot\_disk\_type | The boot disk type to associate with Jenkins workers. Valid options are 'local-ssd', 'pd-ssd', and 'pd-standard' | string | `"pd-ssd"` | no |
| jenkins\_workers\_description | A description of the Jenkins worker cloud to show in Jenkins | string | `"Jenkins worker"` | no |
| jenkins\_workers\_instance\_cap | The maximum number of GCE instances to create as Jenkins workers | string | `"1"` | no |
| jenkins\_workers\_labels | GCP labels to apply to Jankins workers | list(string) | `<list>` | no |
| jenkins\_workers\_launch\_timeout\_seconds | The number of seconds to wait for a Jenkins worker to come online before timing out | string | `"300"` | no |
| jenkins\_workers\_machine\_type | The machine type to deploy Jenkins workers onto | string | `"n1-standard-1"` | no |
| jenkins\_workers\_min\_cpu\_platform | The [minimum CPU platform](https://cloud.google.com/compute/docs/instances/specify-min-cpu-platform) to deploy Jenkins workers onto. Leave blank for no restriction. | string | `""` | no |
| jenkins\_workers\_name\_prefix | A prefix for the Jenkins workers instance names | string | `"jenkins"` | no |
| jenkins\_workers\_network | The URL of the network to deploy Jenkins workers into | string | n/a | yes |
| jenkins\_workers\_network\_tags | A list of network tags to apply to Jenkins workers | list(string) | `<list>` | no |
| jenkins\_workers\_num\_executors | The number of concurrent jobs that can run on each Jenkins worker | string | `"1"` | no |
| jenkins\_workers\_preemptible | Whether to launch Jenkins workers as preemptible instances | string | `"false"` | no |
| jenkins\_workers\_project\_id | The GCP project to deploy Jenkins workers within | string | n/a | yes |
| jenkins\_workers\_region | The name of the region into which to deploy Jenkins workers | string | n/a | yes |
| jenkins\_workers\_retention\_time\_minutes | The number of minutes for Jenkins workers to remain online after completing their last job | string | `"6"` | no |
| jenkins\_workers\_run\_as\_user | The user to run Jenkins jobs as on workers | string | `"ubuntu"` | no |
| jenkins\_workers\_service\_account\_email | The service account email to assign to Jenkins workers. Leave blank for the default compute service account | string | `""` | no |
| jenkins\_workers\_startup\_script | Any additional configuration to run on boot of Jenkins workers | string | `""` | no |
| jenkins\_workers\_subnetwork | The name of the subnetwork to deploy Jenkins workers into | string | `"default"` | no |
| jenkins\_workers\_zone | The name of the zone into which to deploy Jenkins workers | string | `"us-east4-b"` | no |
| project\_id | The project ID to deploy to | string | n/a | yes |
| region | The region to deploy to | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| jenkins\_instance\_initial\_password | The initial password assigned to the Jenkins instance's `user` username |
| jenkins\_instance\_name | The name of the running Jenkins instance |
| jenkins\_instance\_public\_ip | The public IP of the Jenkins instance |
| jenkins\_instance\_service\_account\_email | The email address of the created service account |
| jenkins\_instance\_zone | The zone in which Jenkins is running |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements
### Terraform plugins
- [Terraform](https://www.terraform.io/downloads.html) 0.10.x
- [terraform-provider-google](https://github.com/terraform-providers/terraform-provider-google) plugin v1.8.0
- ruby-2.5.x

### Configure a Service Account
In order to execute this module you must have a Service Account with the following project roles:

- roles/compute.admin
- roles/iam.serviceAccountUser
- roles/compute.networkAdmin

`roles/compute.networkAdmin` is required on the host project if a shared VPC is used.

### Enable API's
In order to operate with the Service Account you must activate the following APIs on the project where the Service Account was created:

- Compute Engine API - compute.googleapis.com

## Install

### Terraform
Be sure you have the correct Terraform version (0.10.x), you can choose the binary here:
- https://releases.hashicorp.com/terraform/

## File structure
The project has the following folders and files:

- `/`: root folder
- `/examples`: examples for using this module
- `/helpers`: scripts used in the build process
- `/templates`: templates used in the provisioning process
- `/test`: folders with files for testing the module (see Testing section on this file)
- `/main.tf`: contains the resources to create
- `/variables.tf`: all the variables for the module
- `/output.tf`: the outputs of the module
- `/README.md`: this file
