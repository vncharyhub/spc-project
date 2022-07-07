pipeline {
    agent {
        label 'spc_java_11'
    }
    triggers {
        pollSCM '0 */1 * * *'
    }
    stages {
        stage('SCM') {
            steps {
                git branch: 'main', url: 'https://github.com/vncharyhub/SPC-Project.git'
            }
        }
        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }
        stage('SonarQube-Analysis') {
            steps {
                withSonarQubeEnv ('SONAR_9.4.0'){
                    
                    sh "mvn clean verify sonar:sonar -Dsonar.projectKey=SPC-Build"
                }
            }
        }
        stage ('JFrog-Artifactory-Configuration') {
            steps {
                rtMavenDeployer (
                    id: "MAVEN_DEPLOYER",
                    serverId: 'JFrog-Artifactory',
                    releaseRepo: 'naresh-libs-release-local',
                    snapshotRepo: 'naresh-libs-snapshot-local'
                )          
            }
        }
        stage ('Exec Maven') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'JFrog_Artifactory', usernameVariable: 'ARTIFACTORY_USERNAME', passwordVariable: 'ARTIFACTORY_PASSWORD')]) {
                    rtMavenRun (
                        tool: 'maven_3.8.5', 
                        pom: 'pom.xml',
                        goals: 'clean install',
                        deployerId: "MAVEN_DEPLOYER"
                    )
                }
            }
        }
        stage ('Publish build info') {
            steps {
                rtPublishBuildInfo (
                    serverId: 'JFrog-Artifactory'
                )
            }
        }
        stage('Docker-Build') {
            steps {
              sh 'docker image build -t $JOB_NAME:v1.$BUILD_ID .'
              sh 'docker image tag $JOB_NAME:v1.$BUILD_ID itschary/$JOB_NAME:v1.$BUILD_ID'
              sh 'docker image tag $JOB_NAME:v1.$BUILD_ID itschary/$JOB_NAME:latest'
            }
        }
        stage('Push Image to Docker-Registry') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'Docker-hub', passwordVariable: 'dockerhubpassword', usernameVariable: 'itschary')]) {
                    sh 'docker login -u itschary -p ${dockerhubpassword}'
                    sh 'docker image push itschary/$JOB_NAME:v1.$BUILD_ID'
                    sh 'docker image push itschary/$JOB_NAME:v1.$BUILD_ID'
                    sh 'docker image rmi $JOB_NAME:v1.$BUILD_ID itschary/$JOB_NAME:v1.$BUILD_ID itschary/$JOB_NAME:latest'
                }
            }
        }
    }
}
