pipeline {
  agent any

  stages {
    stage('Build') {
      steps {
        // Clone the git repository
        git branch: 'main', url: 'https://github.com/my-github-user/my-python-app.git'

        // Set the version number to be the same as the Jenkins build number
        script {
          env.VERSION = "${BUILD_NUMBER}"
        }

        // Build the Docker image with the same version tag as the Jenkins build number
        sh "docker build -t my-docker-registry/python-app:${env.VERSION} ."
      }
    }

    stage('Deploy') {
      environment {
        KUBECONFIG = credentials('my-kubeconfig')
      }

      steps {
        // Create the ArgoCD application
        sh 'argocd app create my-python-app --repo https://github.com/my-github-user/my-python-app.git --path . --dest-namespace my-namespace --dest-server https://kubernetes.default.svc'

        // Sync the application to deploy the latest changes
        sh 'argocd app sync my-python-app'
      }
    }
  }
}
