pipeline{
        agent any
        environment {
            app_version = 'v1'
            rollback = 'false'
        }
        stages{
            stage('Build Image'){
                steps{
                    script{
                        if (env.rollback == 'false'){
                            image = docker.build("maccpr7/frontend")
                        }
                    }
                }          
            }
            stage('Tag & Push Image'){
                steps{
                    script{
                        if (env.rollback == 'false'){
                            docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials'){
                                image.push("${env.app_version}")
                            }
                        }
                    }
                }          
            }
            stage('Environment setup'){
                steps{
                    sh "cd scripts/ && chmod +x docker-install.sh && ./docker-install.sh"
                }
            }

            stage('Deploy Application'){
                steps{
                    sh "docker-compose up -d"
                }
            }
           stage('Test Application'){
                agent {
                  docker {
                    image 'python:3.7'
                  }
                }
                steps{
                    sh "pytest && pytest --cov application"
                }
            }
        }    
}