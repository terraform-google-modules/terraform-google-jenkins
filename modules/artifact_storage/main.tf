/**
 * Copyright 2019 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


resource "google_storage_bucket" "artifacts" {
  name          = var.bucket_name
  project       = var.project_id
  force_destroy = true
}

data "local_file" "artifact_upload_job_template" {
  filename = "${path.module}/templates/artifact_upload_job.xml.tpl"
}

data "template_file" "artifact_upload_job" {
  count = var.jobs_count

  template = data.local_file.artifact_upload_job_template.content

  vars = {
    project_id            = var.project_id
    build_artifact_bucket = google_storage_bucket.artifacts.url

    job_name     = var.jobs[count.index].name
    job_builders = join("\n", var.jobs[count.index].builders)
  }
}

data "null_data_source" "jobs" {
  count = var.jobs_count

  inputs = {
    name     = var.jobs[count.index].name
    manifest = data.template_file.artifact_upload_job[count.index].rendered
  }
}
