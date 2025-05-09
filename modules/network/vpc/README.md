# 이슈
## Tag를 모듈 내에 선언할 필요가 있나?
1. 외부에서 주는 경우.
- 모듈 선언할 때, 변수명으로 줘야한다.
- 네이밍 관리를 루트에서 가능함.
``` hcl
# /main.tf
modules "vpc" {
  name = var.vpc
}

# modules/variable
variable "name" {

}
```

2. 내부에 선언하는 경우
- 모듈 선언할 때, 변수명 안줘도됨.
- 네이밍 관리가 루트에서 불가능함.
- 이름 변경하려면 모든 모듈에 들어가야한다.
``` hcl
# modules/vpc.tf
resource "aws_vpc" "example" {
  name = "string-literal" # 나중에 수정하려면 모듈 모든 코드 바꿔야하네
}
```
**방법 1 선택함**
