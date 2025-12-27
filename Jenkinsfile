pipeline {
  agent any

  stages {

    stage('Checkout') {
      steps {
        git branch: 'main',
            url: 'https://github.com/Ganesh2306/devops-project.git'
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
    terraform plan -out=tfplan
    terraform apply -input=false -auto-approve tfplan
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
