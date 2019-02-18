# Terraform Jenkins GCE Module

This module handles the creation of a GCE instance running [Jenkins](https://jenkins.io/), configured to [run builds on Google Cloud](https://cloud.google.com/solutions/using-jenkins-for-distributed-builds-on-compute-engine). Creates an instance that can be logged into with the username `user` and the password `bitnami`.

## Usage

Please see the [examples](./examples/) folder.

[^]: (autogen_docs_start)


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| gcs_bucket | The name of an existing GCS bucket to associate with the created service account, allowing build artifacts to be uploaded. Leave blank to skip | string | `` | no |
| jenkins_boot_disk_source_image | The name of the disk image to use as the boot disk for the Jenkins master | string | `bitnami-jenkins-2-138-2-0-linux-debian-9-x86-64` | no |
| jenkins_boot_disk_source_image_project | The project within which the disk image to use as the Jenkins master boot disk exists | string | `bitnami-launchpad` | no |
| jenkins_initial_password | The initial password to protect Jenkins logins with. Defaults to a random 8-character alphanumeric string. This may not contain special characters. | string | `` | no |
| jenkins_instance_access_cidrs | CIDRs to allow to access Jenkins over HTTP(s) | list | `<list>` | no |
| jenkins_instance_additional_metadata | Additional instance metadata to assign to the Jenkins VM | map | `<map>` | no |
| jenkins_instance_machine_type | The machine type to provision for Jenkins | string | `n1-standard-4` | no |
| jenkins_instance_name | The name to assign to the Jenkins VM | string | `jenkins` | no |
| jenkins_instance_network | The GCP network to deploy the Jenkins VM in | string | - | yes |
| jenkins_instance_subnetwork | The GCP subnetwork to deploy the Jenkins VM in | string | - | yes |
| jenkins_instance_tags | Tags to assign to the Jenkins VM | list | `<list>` | no |
| jenkins_instance_zone | The zone to deploy the Jenkins VM in | string | - | yes |
| jenkins_jobs | A list of Jenkins jobs to configure on the instance | string | `<list>` | no |
| jenkins_service_account_display_name | The display name of the service account to create for Jenkins VM provisioning | string | `Jenkins` | no |
| jenkins_service_account_name | The name of the service account to create for Jenkins VM provisioning | string | `jenkins` | no |
| jenkins_workers_boot_disk_size_gb | The size of Jenkins worker boot disks, in gigabytes | string | `10` | no |
| jenkins_workers_boot_disk_source_image | The fully qualified URL to the disk image to use as the boot disk for Jenkins workers | string | `ubuntu-1604-xenial-v20181023` | no |
| jenkins_workers_boot_disk_source_image_project | The project within which the disk image to use as the Jenkins worker boot disk exists | string | `ubuntu-os-cloud` | no |
| jenkins_workers_boot_disk_type | The boot disk type to associate with Jenkins workers. Valid options are 'local-ssd', 'pd-ssd', and 'pd-standard' | string | `pd-ssd` | no |
| jenkins_workers_description | A description of the Jenkins worker cloud to show in Jenkins | string | `Jenkins worker` | no |
| jenkins_workers_instance_cap | The maximum number of GCE instances to create as Jenkins workers | string | `1` | no |
| jenkins_workers_labels | GCP labels to apply to Jankins workers | list | `<list>` | no |
| jenkins_workers_launch_timeout_seconds | The number of seconds to wait for a Jenkins worker to come online before timing out | string | `300` | no |
| jenkins_workers_machine_type | The machine type to deploy Jenkins workers onto | string | `n1-standard-1` | no |
| jenkins_workers_min_cpu_platform | The [minimum CPU platform](https://cloud.google.com/compute/docs/instances/specify-min-cpu-platform) to deploy Jenkins workers onto. Leave blank for no restriction. | string | `` | no |
| jenkins_workers_name_prefix | A prefix for the Jenkins workers instance names | string | `jenkins` | no |
| jenkins_workers_network | The URL of the network to deploy Jenkins workers into | string | - | yes |
| jenkins_workers_network_tags | A list of network tags to apply to Jenkins workers | list | `<list>` | no |
| jenkins_workers_num_executors | The number of concurrent jobs that can run on each Jenkins worker | string | `1` | no |
| jenkins_workers_preemptible | Whether to launch Jenkins workers as preemptible instances | string | `false` | no |
| jenkins_workers_project_id | The GCP project to deploy Jenkins workers within | string | - | yes |
| jenkins_workers_region | The name of the region into which to deploy Jenkins workers | string | `us-east4` | no |
| jenkins_workers_retention_time_minutes | The number of minutes for Jenkins workers to remain online after completing their last job | string | `6` | no |
| jenkins_workers_run_as_user | The user to run Jenkins jobs as on workers | string | `ubuntu` | no |
| jenkins_workers_service_account_email | The service account email to assign to Jenkins workers. Leave blank for the default compute service account | string | `` | no |
| jenkins_workers_startup_script | Any additional configuration to run on boot of Jenkins workers | string | `` | no |
| jenkins_workers_subnetwork | The name of the subnetwork to deploy Jenkins workers into | string | `default` | no |
| jenkins_workers_zone | The name of the zone into which to deploy Jenkins workers | string | `us-east4-b` | no |
| project_id | The project ID to deploy to | string | - | yes |
| region | The region to deploy to | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| jenkins_instance_initial_password | The initial password assigned to the Jenkins instance's `user` username |
| jenkins_instance_name | The name of the running Jenkins instance |
| jenkins_instance_public_ip | The public IP of the Jenkins instance |
| jenkins_instance_service_account_email | The email address of the created service account |
| jenkins_instance_zone | The zone in which Jenkins is running |

[^]: (autogen_docs_end)

## Requirements
### Terraform plugins
- [Terraform](https://www.terraform.io/downloads.html) 0.10.x
- [terraform-provider-google](https://github.com/terraform-providers/terraform-provider-google) plugin v1.8.0

### Configure a Service Account
In order to execute this module you must have a Service Account with the following project roles:

- roles/compute.viewer
- roles/iam.serviceAccountUser

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

## Testing

### Requirements
- [bundler](https://github.com/bundler/bundler)
- [terraform-docs](https://github.com/segmentio/terraform-docs/releases) 0.3.0

### Autogeneration of documentation from .tf files

Run `make generate_docs`

### Integration test

Integration tests are run through [test-kitchen](https://github.com/test-kitchen/test-kitchen), [kitchen-terraform](https://github.com/newcontext-oss/kitchen-terraform), and [InSpec](https://github.com/inspec/inspec).

One test-kitchen instance is defined:

- `simple_example`

The test-kitchen instances in `test/fixtures/` wrap identically-named examples in the `examples` directory.

#### Setup

1. Configure the [test fixtures](#test-configuration)
2. Download a Service Account key with the necessary permissions and put it in the module's root directory with the name `credentials.json`.
3. Build the Docker containers for testing:

```
CREDENTIALS_FILE="credentials.json" make docker_build_terraform
CREDENTIALS_FILE="credentials.json" make docker_build_terraform
```
4. Run the testing container in interactive mode:

```
make docker_run
```

The module root directory will be loaded into the Docker container at `/cftk/workdir/`.
5. Run kitchen-terraform to test the infrastructure:
  1. `kitchen create` creates Terraform state and downloads modules, if applicable.
  2. `kitchen converge` creates the underlying resources. Run `kitchen converge <INSTANCE_NAME>` to create resources for a specific test case.
  3. `kitchen verify` tests the created infrastructure. Run `kitchen verify <INSTANCE_NAME>` to run a specific test case.
  4. `kitchen destroy` tears down the underlying resources created by `kitchen converge`. Run `kitchen destroy <INSTANCE_NAME>` to tear down resources for a specific test case.

Alternatively, you can simply run `CREDENTIALS_FILE="credentials.json" make test_integration_docker` to run all the test steps non-interactively.

#### Test configuration

Each test-kitchen instance is configured with a `terraform.tfvars` file in the test fixture directory, e.g. `test/fixtures/simple_example/terraform.tfvars`.
For convenience, these files have been symlinked to `test/fixtures/shared/terraform.tfvars`.
Similarly, each test fixture has a `variables.tf` to define these variables, and an `outputs.tf` to facilitate providing necessary information for `inspec` to locate and query against created resources.

Each test-kitchen instance creates a GCP Network and Subnetwork fixture to house resources, and may create any other necessary fixture data as needed.

### Autogeneration of documentation from .tf files
Run
```
make generate_docs
```

### Linting
The makefile in this project will lint or sometimes just format any shell,
Python, golang, Terraform, or Dockerfiles. The linters will only be run if
the makefile finds files with the appropriate file extension.

All of the linter checks are in the default make target, so you just have to
run

```
make -s
```

The -s is for 'silent'. Successful output looks like this

```
Running shellcheck
Running flake8
Running go fmt and go vet
Running terraform validate
Running hadolint on Dockerfiles
Checking for required files
Testing the validity of the header check
..
----------------------------------------------------------------------
Ran 2 tests in 0.026s

OK
Checking file headers
The following lines have trailing whitespace
```

The linters are as follows:
* Shell - shellcheck. Can be found in homebrew
* Python - flake8. Can be installed with 'pip install flake8'
* Golang - gofmt. gofmt comes with the standard golang installation. golang
is a compiled language so there is no standard linter.
* Terraform - terraform has a built-in linter in the 'terraform validate'
command.
* Dockerfiles - hadolint. Can be found in homebrew<Paste>