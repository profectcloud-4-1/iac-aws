# IaC - AWS

Terraform으로 AWS 인프라를 프로비저닝하는 프로젝트입니다.

> 현재 chore 단계로, 브랜치 구성 및 프로젝트 세부 운용 계획중입니다.
>
> 현재 단계에서는 main 브랜치에서 직접 작업을 수행하기 때문에 **branch 생성**, **저장소 Fork**을 금지합니다.

## Feature

- 네트워크 인프라 프로비저닝
- ECS 리소스 프로비저닝
- API Gateway, NLB, CloudFront 프로비저닝

## Workflow

1. Write

- 로컬환경에서 진행
- 코드 작성
- script/pre-commit 스크립트 실행
  - 코드 포매팅 (`terraform fmt`)
  - 프로비저닝 검증 (`terraform validate`)
  - 실행계획 사전 점검 (`terraform plan`)

2. Plan

- tfsec, terrascan 등을 통해, 코드상 보안취약점 점검
  - PR 오픈 시 워크플로우를 실행하여 점검, 취약점 탐지 시 PR 코멘트 작성 자동화
- 실행계획 확인 및 리뷰

3. Apply

- 실제 인프라에 적용
