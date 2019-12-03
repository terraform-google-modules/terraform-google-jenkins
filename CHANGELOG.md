# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this
project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]

## [v1.2.0] - 2019-12-03

### Added

- The `artifacts_storage` submodule. [#2]
- The `create_firewall_rules` variable which toggles Jenkins agent rules. [#2]

## [v1.1.0] - 2019-12-02

### Added

- The `jenkins_network_project_id` variable provides enhanced support for shared VPC deployments. [#3]

## [v1.0.0] - 2019-08-27

### Changed

- The supported version of Terraform is 0.12 [#12]

### Fixed

- The `wait-for-jenkins.sh` script respects `GOOGLE_APPLICATION_CREDENTIALS`. [#16]

### Fixed

- Wrong path to user's config in the startup script [#12]
- bitnami-jenkins-2-138-2-0-linux-debian-9-x86-64 image is not found [#12]

### Changed

## [v0.1.0] - 2018-12-20

### Added

* Initial release of module

[Unreleased]: https://github.com/terraform-google-modules/terraform-google-jenkins/compare/v1.2.0...HEAD
[v1.2.0]: https://github.com/terraform-google-modules/terraform-google-jenkins/compare/v1.1.0...v1.2.0
[v1.1.0]: https://github.com/terraform-google-modules/terraform-google-jenkins/compare/v1.0.0...v1.1.0
[v1.0.0]: https://github.com/terraform-google-modules/terraform-google-jenkins/compare/v0.1.0...v1.0.0
[v0.1.0]: https://github.com/terraform-google-modules/terraform-google-jenkins/releases/tag/v0.1.0

[#16]: https://github.com/terraform-google-modules/terraform-google-jenkins/issues/16
[#12]: https://github.com/terraform-google-modules/terraform-google-jenkins/pull/12
[#3]: https://github.com/terraform-google-modules/terraform-google-jenkins/issues/3
[#2]: https://github.com/terraform-google-modules/terraform-google-jenkins/issues/2
