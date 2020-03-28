pipeline {
    agent any

    stages {
        stage('lint') {
            agent {
                dockerfile {
                    filename 'Dockerfile-idea'
                    reuseNode true
                }
            }
            steps {
                sh 'rm -rf target/idea_inspections'
                sh 'idea.sh inspect $WORKSPACE $WORKSPACE/.idea/inspectionProfiles/Project_Inspections.xml $WORKSPACE/target/idea_inspections -v2 -d $WORKSPACE/src'
            }
            post {
                always {
                    recordIssues(tools: [ideaInspection(pattern: 'target/idea_inspections/*.xml')])
                }
            }
        }
        stage('build') {
            agent {
                docker {
                    label 'master'
                    image 'maven'
                    reuseNode true
                }
            }
            steps {
                sh 'mvn -B -DskipTests clean package'
            }
        }
        stage('test') {
            agent {
                docker {
                    label 'master'
                    image 'maven'
                    reuseNode true
                }
            }
            steps {
                sh 'mvn -B test'
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }
        stage('deploy') {
            environment {
                IMAGE_NAME='awesome-image'
                IMAGE_TAG="$BUILD_TAG"
            }
            steps {
                // BUILD_TAG must have at most 128 characters
                sh "docker build -t $IMAGE_NAME:$BUILD_TAG ."
                sh 'echo ./deploy.sh'
            }
        }
    }
}
