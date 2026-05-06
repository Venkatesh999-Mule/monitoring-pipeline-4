pipeline {
    agent any 

    environment {
        DOCKER_IMAGE = "mulevenkatesh/monitoring-pipeline"
        DOCKER_TAG   = "latest"
        KUBECONFIG   = "/var/lib/jenkins/.kube/config"
        PATH         = "/usr/local/bin:/usr/bin:/bin"
    }
    stages {
        stage('1. PULLING CODE '){
            steps{
            sh 'echo "===pulling code from git hub======"'
            checkout scm
            }
        }
        stage('2.MAVEN INSTALL'){
            steps{
                sh 'echo "Maven process"'
                sh 'mvn clean install'
            }
        }
        stage('3. DOCKER IMAGE BUILD '){
            steps{
            sh 'docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .'
            }
        }
        stage('4.PUSHING DOCKER IMAGE'){
            steps{
                sh 'echo "===PUSHING docker image to docker hub ===="'
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhud_creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) 
            }
        }
        stage('5. DEPLOYMENT OF APP IN KUBERNETES'){
            steps{
                sh 'echo "Deploying app to Kubernetes..."'
                sh 'kubectl apply -f k8s/deployment.yaml'
                sh 'kubectl apply -f k8s/service.yaml'
                sh 'kubectl rollout status deployment/monitoring-app --timeout=90s'
            }
        }
        stage('6. Deploy Prometheus') {
            steps {
                echo 'Deploying Prometheus...'
                sh '''
                    kubectl apply -f k8s/prometheus-config.yaml
                    kubectl apply -f k8s/prometheus-deployment.yaml
                    kubectl rollout status deployment/prometheus \
                        --timeout=90s
                '''
            }
        }

        stage('7. Deploy Grafana') {
            steps {
                echo 'Deploying Grafana...'
                sh '''
                    kubectl apply -f k8s/grafana-deployment.yaml
                    kubectl rollout status deployment/grafana \
                        --timeout=90s
                '''
            }
        }

        stage('8. Health Check') {
            steps {
                echo 'Running health check...'
                sh 'bash scripts/health-check.sh'
            }
        }
    }
    post {
        success {
            echo 'Pipeline SUCCESS - App, Prometheus and Grafana running!'
        }
        failure {
            echo 'Pipeline FAILED - check logs!'
        }
    }
}
