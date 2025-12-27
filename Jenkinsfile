pipeline {
  agent any

  stages {

    stage('Checkout') {
      steps {
        git url: 'https://github.com/Ganesh2306/devops-project.git'
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

    stage('Terraform Deploy') {
      steps {
        sh '''
        cd terraform
        terraform init
        terraform apply -auto-approve
        '''
      }
    }

    stage('Ansible Deploy') {
      steps {
        sh '''
        cd ansible
        ansible-playbook -i inventory.ini setup.yml
        '''
      }
    }
  }
}
