#!/bin/bash

cd ./aws-cloudwatch
cp ../var.tf ./var.tf

terraform init

cat > terraform.tfvars << EOF
AWS_ACCESS_KEY = "$AWS_ACCESS_KEY"
AWS_SECRET_KEY = "$AWS_SECRET_KEY"
EOF

terraform destroy --auto-approve

rm -rf terraform.tfvars var.tf
cd ../
