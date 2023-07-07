# dealver-infra

### Terraform

#### 설치

- `brew install terraform`

#### Deploy

```bash
terraform init
terraform plan
terraform apply
```

#### Destroy

- Deploy에 실패했을 경우 반드시 아래의 명령어를 실행 후 다시 Deploy 해주세요.

```bash
terraform destroy
```