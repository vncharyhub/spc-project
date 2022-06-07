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
    }
}
