pipeline {
  agent any

  stages {

    stage('Checkout') {
      steps {
        git url: 'https://github.com/company/devops-project.git'
      }
    }

    stage('Build') {
      steps {
        echo 'Building application'
      }
    }

    stage('Test') {
      steps {
        echo 'Running tests'
      }
    }

    stage('Deploy Infrastructure') {
      steps {
        sh '''
        cd terraform
        terraform init
        terraform apply -auto-approve
        '''
      }
    }

    stage('Configure Server') {
      steps {
        sh '''
        cd ansible
        ansible-playbook -i inventory.ini setup.yml
        '''
      }
    }
  }
}
