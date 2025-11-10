# IaC - AWS

Terraform으로 AWS 인프라를 프로비저닝하는 프로젝트입니다.

## Feature

- 네트워크 인프라 프로비저닝
- ECS 리소스 프로비저닝
- API Gateway, NLB, CloudFront 프로비저닝

## Workflow

1. 개발

- 로컬환경에서 진행
- 코드 작성
- script/pre-commit 스크립트 실행
  - 코드 포매팅 (`terraform fmt`)
  - 프로비저닝 검증 (`terraform validate`)

2. Pull Request

- tfsec, terrascan 등을 통해, 코드상 보안취약점 점검
  - PR 오픈 시 워크플로우를 실행하여 점검, 취약점 탐지 시 PR 코멘트 작성 자동화
- 실행계획 확인 및 리뷰
  - 계산된 실행계획이 PR 댓글로 자동 등록됩니다.

3. Apply

- 실제 인프라에 적용
- main에 머지되면 HCP Terraform에서 이를 감지하여 실제 인프라에 apply 합니다.
