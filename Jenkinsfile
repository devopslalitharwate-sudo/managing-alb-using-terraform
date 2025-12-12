pipeline{
    agent any
    
    environment{
        AWS_ACCESS_KEY_ID = credentials("AWS_ACCESS_KEY_ID")
        AWS_SECRET_ACCESS_ID = credentials("AWS_SECRET_ACCESS_ID")
        AWS_DEFAULT_REGION = "us-east-1"
    }

    parameters {
        choice(
            name: 'ACTION', 
            choices: ['Apply',"Destroy"].join('\\n'),
            description: 'Select the target environment'
        )
    }

    stages{
        stage("Checkout"){
            steps{
                checkout scm
            }
        }

        stage("Terraform Init"){
            steps{
                sh "terraform init"
            }
        }

        stage("Terraform Validate"){
            steps{
                sh "terraform validate"
            }
        }

        stage("Terraform Plan"){
            steps{
                script{
                    if(params.ACTION == "apply"){
                        sh "terraform plan"
                    }
                }
            }
        }

        stage("Terraform Execute"){
            steps{
                script{
                    if(params.ACTION == "apply"){
                        input message: "Approve Terraform Apply?"
                        sh "terraform apply --auto-approve"
                    }
                    else if(params.ACTION == "destroy"){
                        input message: "Approve Terraform Destroy?"
                        sh "terraform destroy --auto-approve"
                    }
                }
            }
        }
    }
}