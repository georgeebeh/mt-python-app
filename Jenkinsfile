pipeline {
  agent any

  stages {
    stage('Checkout') {
      steps {
        git 'https://github.com/georgeebeh/mt-python-app.git'
      }
    }

    stage('Build Artifact') {
      steps {
        sh 'pip install -r requirements.txt'
        sh 'python setup.py sdist'
      }
      post {
        success {
          archiveArtifacts artifacts: 'dist/*.tar.gz', onlyIfSuccessful: true
        }
      }
    }

    stage('Build Docker Image') {
      steps {
        sh 'docker build -t my-python-app .'
        sh 'docker tag mt-python-app georgeebeh/mt-python-app'
        withCredentials([usernamePassword(credentialsId: 'DOCKERHUB_CREDS', usernameVariable: 'DOCKERHUB_USER', passwordVariable: 'DOCKERHUB_PASS')]) {
          sh 'docker login -u $DOCKERHUB_USER -p $DOCKERHUB_PASS DOCKERHUB_CREDS'
          sh 'docker push georgeebeh/mt-python-app'
        }
      }
    }
  }
}

