# Artifact storage module

This provisions GCS bucket for artifacts and optionally renders jobs with automatic artifact upload.


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| project_id | The project ID to deploy to | string | - | yes |
| jobs | A list of Jenkins jobs to populate | list | [] | no |
| jobs_count | Amount of jobs to populate | number | 0 | no |

## Outputs

| Name | Description |
|------|-------------|
| artifact_bucket | Artifact bucket name |
| jobs | List of rendered jobs |

[^]: (autogen_docs_end)
