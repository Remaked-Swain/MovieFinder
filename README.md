#  MovieFinder
영화진흥위원회 오픈API를 활용한 영화 정보 앱

SwiftUI 환경에서 Clean Architecture와 MVVM을 실습한 프로젝트

## Overview
이 저장소는 iOS 및 SwiftUI 환경에서 Clean Architecture를 비롯한 구조 설계를 연습해보고, 의존성 주입과 그 방법에 대해 고민해본 앱 프로젝트를 담고 있습니다.

### 앱의 주요 기능에 대해 설명합니다.

**일일 박스오피스 영화 목록 뷰**: DailyBoxOfficeListView
* 일일 박스오피스 영화 목록을 순위별로 화면에 표시합니다.
* 나열된 영화에 대해 자세한 영화 정보를 확인할 수 있는 디테일 뷰로 이동할 수 있습니다.

**디테일 뷰**: DetailMovieInfoView
* 식별자로 구분되는 해당 영화에 대하여 보다 자세한 정보를 화면에 표시합니다.

---

### 프로젝트 진행 간 얻을 수 있었던 개념적인 내용을 소개합니다.

#### Clean Architecture with MVVM
이 프로젝트를 진행한 최대의 이유이자 목표입니다. 클린 아키텍처라는 구조 설계 기법에 대해 이해해야 현업의 코드에 적응하기 수월할 것으로 예상됐기 때문입니다.

**MVVM이란 무엇인가?**
기존 MVC 모델에서 컨트롤러의 책임은 상태(혹은 데이터)에 따라 뷰의 변화를 관리하고 뷰를 표현하기 위해 필요한 일련의 데이터들을 가공, 처리하는 것이었습니다.

특히 '일련의 데이터를 가공, 처리하는 것.'이라는 책임은 서비스의 규모나 목적 등에 좌지우지되는데, 서비스가 성장함에 따라 필연적으로 코드가 증가하게 되어있습니다.

때문에 컨트롤러 역시 알아보기 어려워지도록 방대한 코드를 담게 되고 이로 인한 문제점들이 많이 발생하기 시작하는데 이를 해소하고자 MVVM 모델을 사용합니다.

'뷰의 변화를 관리하는 것.'이라는 책임은 컨트롤러가 담당하되, '데이터를 처리하는 것.'은 다른 객체가 담당하는 것으로 개선하고 그 객체를 뷰모델이라고 합니다.

컨트롤러는 뷰의 노출만을 관리하며 뷰모델은 컨트롤러가 필요로 하는 데이터를 준비하고 전달하는 것으로 역할이 분리되었다고 볼 수 있습니다. 

**Clean Architecture란 무엇인가?**
MVVM이 화면에 표시되는 것들에 대한 해답이었다면, 클린 아키텍처는 그것을 넘어선 다른 분야에서도 역할 분리를 통해 다양한 문제를 해결하려는 시도라고 볼 수 있습니다.

특히 이번 프로젝트에서 얻고자 한 점은, 앱 진입점으로부터 화면에 표시되는 부분인 Application, Presentation 레이어와 앱의 핵심 기능 및 관련 데이터를 기술한 Domain 레이어,

앱의 핵심 기능이 동작하기 위해 연결되어야 할 외부 요소인 Infrastructure 레이어, 그리고 그것을 도메인 계층과 연결시켜줄 Data 레이어까지, 다양한 관심사를 어떤 기준으로 나누고,

어떤 객체를 준비시켜야 하며, 역할을 분리하면서도 메세징 관계는 유지하는 방법들입니다.

클린 아키텍처를 통해 계층 별로 분리된 요소들에 대하여 모듈로 만들어 재사용하기도 용이하고 테스트하기 좋게 만들어주는데, 이는 네트워킹 모델을 만들 때 가장 잘 느낄 수 있었습니다.

**SwiftUI에서의 의존성 주입**
SwiftUI는 `@EnvironmentObject`와 같은 여러 뷰에 걸쳐 사용될 의존성 객체를 `.environmentObject(_:)` 수정자를 통해 주입시켜 줄 수 있습니다.

이것은 가장 SwiftUI다운 방향이지만 수정자를 붙이지 않는 등의 실수로 런타임에러가 곧잘 발생하기도 합니다.

하나의 뷰와 뷰모델 간의 상황이라면 `@ObservableObject`로 만들어 의존성을 관리할 수도 있습니다.

또, Constructor(Initializer) Injection, Method Injection 등 다양한 주입 방법도 있지만 추가적인 코드가 필요해진다거나 하는 등, 각자의 장단점이 존재하는 것 같습니다.

이번에는 생성자를 통해 의존성을 주입해주는 Constructor Injection 방법으로 프로젝트를 진행해보았는데, 이것이 가장 무난해보이면서도 여러 문제 상황을 마주하게 될 것 같다고 판단했기 때문입니다.

---

## Discussion
프로젝트를 진행하며 고민한 내용에 대해 일부의 코드와 함께 공유합니다.

### Domain Layer
Domain 계층은 서비스의 핵심 기능과 앱 전반에서 다루는 데이터로 이루어져 있습니다.

즉, 기능 자체를 표현하고 설명하는 로직인 '유즈케이스', 그것의 구동을 위해 필요한 데이터 형식들이라면 Domain 계층으로 분류하기 좋겠습니다.

이 과정에서 유즈케이스란 무엇인지 스스로 설명해보기가 꽤 어려웠는데, '사용자가 이 서비스를 이용하기 위해 앱이 제공해야할 행동'이라고 정의해보기로 했습니다.

이 프로젝트는 일일 박스오피스 영화 순위를 조회할 수 있고, 어떤 영화의 자세한 정보를 찾아볼 수 있습니다.

즉, 사용자 입장에서는 영화 순위를 궁금해하고 영화 정보를 찾기 위해 이 서비스를 이용한다고 볼 수 있습니다.

따라서 유즈케이스는 API에서 영화 목록 가져오기, API에서 영화 상세 정보 가져오기로 생각할 수 있습니다.

**FetchDailyBoxOfficeListUseCase**
```swift
protocol FetchDailyBoxOfficeListUseCase {
    func fetchDailyBoxOfficeList() -> AnyPublisher<[BasicMovieInfo], Error>
}

final class DefaultFetchDailyBoxOfficeListUseCase {
    private let repository: DailyBoxOfficeListRepository
    
    init(repository: DailyBoxOfficeListRepository) {
        self.repository = repository
    }
}

// MARK: FetchDailyBoxOfficeListUseCase Confirmation
extension DefaultFetchDailyBoxOfficeListUseCase: FetchDailyBoxOfficeListUseCase {
    func fetchDailyBoxOfficeList() -> AnyPublisher<[BasicMovieInfo], Error> {
        return Future<[BasicMovieInfo], Error> { [weak self] promise in
            guard let self = self else { return }
            
            let yesterday = Date.now.addingTimeInterval(-86400)
            
            Task {
                do {
                    let result = try await self.repository.fetchDailyBoxOfficeList(date: yesterday)
                    promise(.success(result))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
```
> 
