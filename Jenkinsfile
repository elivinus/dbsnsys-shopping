pipeline {
    agent any
    options {
        skipStagesAfterUnstable()
        disableConcurrentBuilds()
        parallelsAlwaysFailFast()
    }

    stages {
        stage('Micro Service Deploy') {
            //  when {
                //  branch 'main'
                //  beforeAgent true
            //  }
            stages {
                stage('Checkout') {
                    steps {
                    cleanWs()
                    checkout scm: [
                        $class: 'GitSCM',
                        branches: [[name: "main"]],
                        userRemoteConfigs: [[credentialsId: 'github_ssh', url: "git@github.com:elivinus/dbsnsys-shopping.git"]]
                        ]
                        sh "ls -la"
                    }
                }
                
                stage('Install For API') {
                    
                    environment {
                        ecrRepository = "606232962614.dkr.ecr.us-east-1.amazonaws.com"
                        NAME = "dbsnsys-shopping"
                    }
                    steps {
                            withAWS(credentials:'bad5a27a-442a-4f71-bc32-fde078a3929f') {
                                sh "aws ecr describe-repositories --repository-names ${NAME} || aws ecr create-repository --repository-name ${NAME} --image-scanning-configuration scanOnPush=true"
                                sh "aws ecr get-login-password \
                                | docker login \
                                    --password-stdin \
                                    --username AWS \
                                    '${ecrRepository}/${NAME}'"
                                sh "ls -la"
                                sh "docker build -t ${NAME} -f Dockerfile ."
                                sh "docker tag ${NAME} ${ecrRepository}/${NAME}:latest"
                                sh "docker push ${ecrRepository}/${NAME}:latest"
                                sh "aws eks --region us-east-1 update-kubeconfig --name dev-dbs-cluster"
                                sh "cd deployment"
                                sh "kubectl apply -f shopfront-service.yaml"
                    }
                }
            }
        }
    }
}
}
