pipeline {
    agent any

    tools {
        maven 'maven'       // Matches Jenkins tool name
        jdk 'jdk-17'
        dockerTool 'docker'
    }

    environment {
        DOCKER_USERNAME = "gchauhan1517"
    }

    stages {
        stage('Cleanup Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Git Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Gaurav1517/java-maven-webapp.git'
            }
        }

        stage('Maven Unit Test') {
            steps {
                sh 'mvn test'
            }
        }

        stage('Maven Build') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Maven Integration Test') {
            steps {
                sh 'mvn verify'
            }
        }

        stage('Docker Image Build') {
            steps {
                script {
                    def job = env.JOB_NAME.toLowerCase()
                    sh "docker build -t ${job}:${BUILD_NUMBER} ."
                }
            }
        }

        stage('Docker Image Tag') {
            steps {
                script {
                    def job = env.JOB_NAME.toLowerCase()
                    sh "docker tag ${job}:${BUILD_NUMBER} ${DOCKER_USERNAME}/${job}:v${BUILD_NUMBER}"
                    sh "docker tag ${job}:${BUILD_NUMBER} ${DOCKER_USERNAME}/${job}:latest"
                }
            }
        }

        stage('Trivy Image Scan') {
            steps {
                script {
                    def job = env.JOB_NAME.toLowerCase()
                    sh "trivy image --format table ${DOCKER_USERNAME}/${job}:v${BUILD_NUMBER} -o image-report.html"
                }
            }
        }

        stage('Docker Image Push') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', passwordVariable: 'docker_pass', usernameVariable: 'docker_user')]) {
                        sh "docker login -u '${docker_user}' -p '${docker_pass}'"
                        def job = env.JOB_NAME.toLowerCase()
                        sh "docker push ${docker_user}/${job}:v${BUILD_NUMBER}"
                        sh "docker push ${docker_user}/${job}:latest"
                    }
                }
            }
        }

        stage('Docker Image Cleanup') {
            steps {
                script { 
                    echo "🧹 Cleaning up Docker images matching gchauhan1517 or java-maven"
                    sh 'docker images --format "{{.Repository}}:{{.Tag}}" | grep -E "^(gchauhan1517|java-maven)" | xargs -r docker rmi -f'
                }
            }
        }

        // 🔥 CD Starts Here
        stage('Deploy to Container') {
            steps {
                script {
                    def job = env.JOB_NAME.toLowerCase()
                    def containerName = "${job}-container"

                    // Stop and remove previous container if running
                    sh """
                        docker stop ${containerName} || true
                        docker rm ${containerName} || true
                    """

                    // Run new container on port 8080 inside, 8081 on host
                    sh """
                        docker run -d --name ${containerName} -p 8081:8080 ${DOCKER_USERNAME}/${job}:latest
                    """
                }
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline completed successfully!'
        }
        failure {
            echo '❌ Pipeline failed. Check logs for details.'
        }
    }
}
