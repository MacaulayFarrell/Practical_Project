pipeline{
        agent any
        environment {
            app_version = 'v1'
            rollback = 'true'
        }
        stages{
            stage('Build Image'){
                steps{
                    script{
                        if (env.rollback == 'false'){
                            image = docker.build("maccpr7/frontend", "./frontend")
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
                    sh '''
                    cd kubernetes
                    export app_version=$app_version
                    export DATABASE_URI=$DATABASE_URI
                    export TEST_DATABASE_URI=$TEST_DATABASE_URI
                    export SECRET_KEY=$SECRET_KEY
                    envsubst < backend.yaml | kubectl apply -f -
                    envsubst < frontend.yaml | kubectl apply -f -
                    kubectl apply -f nginx.yaml
                    kubectl apply -f config-map.yaml
                    sleep 25 
                    kubectl get services 
                    '''
                }
            }
 
   }
}
