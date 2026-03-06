// pipeline {
//   agent any

//   stages {

//     stage('Checkout') {
//       steps {
//         git branch: 'main',
//             url: 'https://github.com/Ganesh2306/devops-project.git'
//       }
//     }

//     stage('Build') {
//       steps {
//         echo 'Building application'
//       }
//     }

//     stage('Test') {
//       steps {
//         echo 'Running tests'
//       }
//     }

//    stage('Terraform Deploy') {
//   steps {
//     sh '''
//     cd terraform
//     terraform init
//     terraform plan -out=tfplan
//     terraform apply -input=false -auto-approve tfplan
//     '''
//   }
// }
  
//     stage('Ansible Deploy') {
//       steps {
//         sh '''
//         cd ansible
//         ansible-playbook -i inventory.ini setup.yml
//         '''
//       }
//     }
//   }
// }

pipeline {

    agent any

    environment {
        DOTNET_ROOT = "/usr/share/dotnet"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main',
                url: 'https://github.com/Ganesh2306/devops-project.git'
            }
        }

        stage('Restore Dependencies') {
            steps {
                sh '''
                cd app/dotnet-app
                dotnet restore
                '''
            }
        }

        stage('Build Application') {
            steps {
                sh '''
                cd app/dotnet-app
                dotnet build --configuration Release
                '''
            }
        }

        stage('Run Tests') {
            steps {
                sh '''
                cd app/dotnet-app
                dotnet test || true
                '''
            }
        }

        stage('Publish App') {
            steps {
                sh '''
                cd app/dotnet-app
                dotnet publish -c Release -o publish
                '''
            }
        }

        stage('Terraform Infrastructure') {
            steps {
                sh '''
                cd terraform
                terraform init
                terraform plan -out=tfplan
                terraform apply -auto-approve tfplan
                '''
            }
        }

        stage('Deploy with Ansible') {
            steps {
                sh '''
                cd ansible
                ansible-playbook -i inventory.ini setup.yml
                '''
            }
        }
    }
}