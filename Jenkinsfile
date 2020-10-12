pipeline{
        agent any
        environment {
            app_version = 'v3'
            rollback = 'false'
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
            stage('Deploy into Kubernetes Cluster'){
                steps{
                    sh '''
                    cd kubernetes
                    export app_version=$app_version
                    export DATABASE_URI=$dburl
                    export TEST_DATABASE_URI=$tdburl
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
