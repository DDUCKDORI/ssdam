# 쓰담 - 우리 가족 쓰고 담고

## 앱 개요
'쓰담'은 가족 간의 유대감을 강화하는데 도움을 주는 앱입니다. 사용자는 주어진 질문에 답변함으로써 가족 구성원들과의 소통을 증진시키고, 가족 간의 이해도를 높일 수 있습니다.

## 주요 기능
- **답변하기**: 매일 다른 질문에 답변하며, 가족 구성원들과 소통합니다.
- **달력 보기**: 달력에서 특정 날짜의 질문과 그에 대한 가족 구성원들의 답변을 확인할 수 있습니다.
- **iCloud 동기화**: iCloud를 통해 데이터를 동기화하여 여러 기기에서도 가족의 답변을 확인할 수 있습니다.

## 개발 환경
- **언어**: Swift, SwiftUI
- **아키텍쳐**:
  - **클린 아키텍쳐**: 모듈별 구조를 가지며, 다음과 같이 구성됩니다.
    - `Data`: 데이터 처리 및 저장과 관련된 로직을 담당합니다.
    - `Domain`: 비즈니스 로직과 앱의 핵심 기능을 관리합니다.
    - `Networking`: 네트워크 통신과 관련된 로직을 처리합니다.
    - `App`: 앱의 UI 및 사용자 상호작용을 관리합니다.
    - `Utils`: 유틸리티와 UserDefaults을 포함합니다.
  - **TCA (The Composable Architecture)**: 앱의 상태 관리와 비즈니스 로직을 효율적으로 처리하기 위해 사용됩니다.

- **의존성 관리**:
  - **tuist**: 프로젝트의 의존성을 관리하고, 구성을 간소화하는 데 사용됩니다.
![iphone_5 5_05](https://github.com/DDUCKDORI/ssdam/assets/90512276/f9ff0e72-1baf-4acf-ba09-b1f8ff3c1bca)
![iphone_5 5_04](https://github.com/DDUCKDORI/ssdam/assets/90512276/5247d3d8-01eb-4bfd-87d3-9cde4fb3a6e4)
![iphone_5 5_03](https://github.com/DDUCKDORI/ssdam/assets/90512276/fbd34bcd-22c5-4a1c-9555-fdab25abb390)
![iphone_5 5_02](https://github.com/DDUCKDORI/ssdam/assets/90512276/bcd464c1-0ac8-4478-a9aa-442aeb7dc5f3)
![iphone_5 5_01](https://github.com/DDUCKDORI/ssdam/assets/90512276/4aff307c-a5ab-4c13-ab1d-9e26388e0889)
