<?xml version='1.0' encoding='UTF-8'?>
<project>
	<actions/>
	<description>Job ${job_name}</description>
	<keepDependencies>false</keepDependencies>
	<properties/>
	<scm class="hudson.scm.NullSCM"/>
	<assignedNode>!master</assignedNode>
	<canRoam>false</canRoam>
	<disabled>false</disabled>
	<blockBuildWhenDownstreamBuilding>false</blockBuildWhenDownstreamBuilding>
	<blockBuildWhenUpstreamBuilding>false</blockBuildWhenUpstreamBuilding>
	<triggers/>
	<concurrentBuild>true</concurrentBuild>
	<builders>
		${job_builders}
	</builders>
	<publishers>
		<com.google.jenkins.plugins.storage.GoogleCloudStorageUploader plugin="google-storage-plugin@1.1">
			<credentialsId>${project_id}</credentialsId>
			<uploads>
				<com.google.jenkins.plugins.storage.StdoutUpload>
					<bucketNameWithVars>${build_artifact_bucket}/\$JOB_NAME/\$BUILD_NUMBER</bucketNameWithVars>
					<sharedPublicly>false</sharedPublicly>
					<forFailedJobs>true</forFailedJobs>
					<showInline>false</showInline>
					<module/>
					<logName>build-log.txt</logName>
				</com.google.jenkins.plugins.storage.StdoutUpload>
			</uploads>
		</com.google.jenkins.plugins.storage.GoogleCloudStorageUploader>
	</publishers>
	<buildWrappers/>
</project>
