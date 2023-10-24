pipeline {
    tools {
        gradle 'gradle8.4'
    }
    environment {
        dockerimagename = "kogunniyi/helloworld"
        dockerImage = ""
    }
    agent any
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', credentialsId: 'git-cred', url: 'https://github.com/kogunniyi/my-gradleproject.git'
            }
        }
        stage('Build Artifacts') {
            steps {
                sh 'gradle build'
            }
        }
        stage('Build Image') {
            steps {
                script {
                    dockerImage = docker.build dockerimagename
                }
            }
        }
        stage('Push Image to dockerhub') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker-cred') {
                        dockerImage.push("latest")
                    }
                }
            }
        }
        stage('Deploying to kubernetes') {
            steps {
                script {
                    kubernetesDeploy(configs: "k8s-spring-boot-deployment.yml", kubeconfigId: "kubernetes")
                }
            }
        }
    }
}