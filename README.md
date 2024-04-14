#  MovieFinder
영화진흥위원회 오픈API를 활용한 영화 정보 앱

SwiftUI 환경에서 Clean Architecture와 MVVM을 실습한 프로젝트

## Overview
이 저장소는 iOS 및 SwiftUI 환경에서 Clean Architecture를 비롯한 구조 설계를 연습해보고, 의존성 주입과 그 방법에 대해 고민해본 앱 프로젝트를 담고 있습니다.

### 앱의 주요 기능에 대해 설명합니다.

<p>
    <img src="https://github.com/Remaked-Swain/ScreenShotRepository/blob/main/MovieFinder/DailyBoxOfficeListView.png?raw=true" alt="DailyBoxOfficeListView" width="250px">
    <img src="https://github.com/Remaked-Swain/ScreenShotRepository/blob/main/MovieFinder/DetailMovieInfoView.png?raw=true" alt="DetailMovieInfoView" width="250px">
</p>

**일일 박스오피스 영화 목록 뷰**: DailyBoxOfficeListView
* 일일 박스오피스 영화 목록을 순위별로 화면에 표시합니다.
* 나열된 영화에 대해 자세한 영화 정보를 확인할 수 있는 디테일 뷰로 이동할 수 있습니다.

**디테일 뷰**: DetailMovieInfoView
* 식별자로 구분되는 해당 영화에 대하여 보다 자세한 정보를 화면에 표시합니다.

---

### 프로젝트 진행 간 얻을 수 있었던 개념적인 내용을 소개합니다.

#### Clean Architecture with MVVM
이 프로젝트를 진행한 최대의 이유이자 목표입니다. 클린 아키텍처라는 구조 설계 기법에 대해 이해해야 현업의 코드에 적응하기 수월할 것으로 예상됐기 때문입니다.

**1. MVVM이란 무엇인가?**

기존 MVC 모델에서 컨트롤러의 책임은 상태(혹은 데이터)에 따라 뷰의 변화를 관리하고 뷰를 표현하기 위해 필요한 일련의 데이터들을 가공, 처리하는 것이었습니다.
특히 '일련의 데이터를 가공, 처리하는 것.'이라는 책임은 서비스의 규모나 목적 등에 좌지우지되는데, 서비스가 성장함에 따라 필연적으로 코드가 증가하게 되어있습니다.
때문에 컨트롤러 역시 알아보기 어려워지도록 방대한 코드를 담게 되고 이로 인한 문제점들이 많이 발생하기 시작하는데 이를 해소하고자 MVVM 모델을 사용합니다.
'뷰의 변화를 관리하는 것.'이라는 책임은 컨트롤러가 담당하되, '데이터를 처리하는 것.'은 뷰모델이라는 객체가 담당하는 것으로 합니다.
컨트롤러는 뷰의 노출만을 관리하며 뷰모델은 컨트롤러가 필요로 하는 데이터를 준비하고 전달하는 것으로 역할이 분리되었다고 볼 수 있습니다. 

**2. Clean Architecture란 무엇인가?**

MVVM이 화면에 표시되는 것들에 대한 해답이었다면, 클린 아키텍처는 그것을 넘어선 다른 분야에서도 역할 분리를 통해 다양한 문제를 해결하려는 시도라고 볼 수 있습니다.
특히 이번 프로젝트에서 얻고자 한 점은, 앱 진입점으로부터 화면에 표시되는 부분인 Application, Presentation 계층과 앱의 핵심 기능 및 관련 데이터를 기술한 Domain 계층,
앱의 핵심 기능이 동작하기 위해 연결되어야 할 외부 요소인 Infrastructure 계층, 그리고 그것을 도메인 계층과 연결시켜줄 Data 계층까지, 다양한 관심사를 어떤 기준으로 나누고,
어떤 객체를 준비시켜야 하며, 역할을 분리하면서도 메세징 관계는 유지하는 방법들입니다.
클린 아키텍처를 통해 계층 별로 분리된 요소들에 대하여 모듈로 만들어 재사용하기도 용이하고 테스트하기 좋게 만들어주는데, 이는 네트워킹 모델을 만들 때 가장 잘 느낄 수 있었습니다.

**3. SwiftUI에서의 의존성 주입**

SwiftUI는 `@EnvironmentObject`와 같은 여러 뷰에 걸쳐 사용될 의존성 객체를 `.environmentObject(_:)` 수정자를 통해 주입시켜 줄 수 있습니다. 
이것은 가장 SwiftUI다운 방향이지만 수정자를 붙이지 않는 등의 실수로 런타임에러가 곧잘 발생하기도 합니다.
또는 비교적 가까운 범위에서 사용될 의존성 객체를 주입할 수 있는 Property Wrapper들도 존재합니다.
예를 들어, 하나의 뷰와 뷰모델 간의 상황이라면 `@ObservableObject`로 만들어 의존성을 관리할 수도 있습니다.
일반적으로 Constructor(Initializer) Injection, Method Injection 등 다양한 주입 방법도 있지만 추가적인 코드가 필요해진다거나 하는 등, 각자의 장단점이 존재하는 것 같습니다.
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

---

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
> 영화 목록을 가져오는 유즈케이스에서는 단지 영화 순위 정보를 전달해주는 것을 주된 관심사로 설정합니다.
>
> 유즈케이스는 자신에게 요청을 보내는 객체에게 이렇게 말하는 것과 같습니다: '이게 저장소에서 올지 인터넷으로부터 올지 출처는 나도 모르겠지만, 어떤 게시자로 데이터를 스트리밍 해줄테니 구독자 준비해둬.'
>
> 물론 유즈케이스는 어떤 객체가 자신을 이용하게 될지 모른채 이런 인터페이스를 제공했습니다.
>
> 앱의 다른 부분보다 먼저 정의되는 Domain 계층인 만큼, 이렇게 AnyPublisher를 반환 타입으로 제공하겠다고 인터페이스를 작성하면 이후에 이를 이용할 객체를 설계할 때 영향을 받는다는 사실을 알게 되었습니다.
>
> 실제로 뷰모델이 Combine 프레임워크를 사용해 구독자를 준비하도록 유도했습니다.
>
> 따라서 Domain 계층 만큼은 미래에 설계될 다른 계층이 어떻게 구현해야할지 부담스럽지 않도록 최대한 추상화 해두는게 좋겠습니다. 

---

**BasicMovieInfo**
```swift
struct BasicMovieInfo {
    let rank: String
    let movieCode, movieName: String
    let audienceAccumulatedAmount: String
}
```
> 영화 목록 뷰에서 노출되는 각 영화의 정보는 많은 데이터도 필요없습니다. 순위나 이름 따위만 표시하면 됩니다.
>
> 이렇게 서비스의 목적에 맞는 데이터를 정의해둘 수 있는데, 역시 Domain 계층에 포함되는 것이 좋겠습니다.
>
> 서비스 자체가 바뀌지 않는 이상 이러한 데이터는 쉽게 바뀌지 않습니다. 즉, 영화 순위를 알려준다는 기능 자체가 사라지면 몰라도 이 작은 모델은 다른 비즈니스 로직의 변경과 무관하게 생존합니다.
>
> 보통 Domain 계층에서(특히 유즈케이스들이) 사용될 모델이라는 점 때문에 다른 계층에서도 통용시키는게 좋을지, 아니면 각 계층별로 호환되는 다른 모델(DTO)들을 준비해야 좋을지도 생각해볼 수 있었습니다.
>
> 다른 모델들을 준비할 시간이 불충분하여 우선은 통용하는 방법을 취했지만, 이 경우 모듈화를 진행했을 때 `BasicMovieInfo`라는 모델을 다른 모듈에서 알아볼 방법을 강구해야 할 것 같습니다.

---

### Data Layer
Data 계층은 Domain 계층과 Infrastruct 계층의 메세징을 중개해주는 구간입니다.
유즈케이스가 데이터를 준비할 때 데이터가 저장소에서 올지 인터넷과 같은 새로운 데이터소스로부터 올지 몰랐던 것을 실질적으로 판단해 조정해주어야 합니다.
또한 각 계층에서 사용하는 모델(DTO)이 서로 다를 수 있는 점을 해결해주기도 합니다.
용도에 맞는 레포지토리의 인터페이스만을 유즈케이스에 제공하고, 또 다양한 형태의 레포지토리가 수평확장을 통해 양산될 수 있습니다.
Clean Architecture에서 설명하는 의존성의 방향은 Data Layer에서 Domain Layer로 흘러가기 때문에 의존성 역전 원칙 등으로 유즈케이스가 레포지토리의 인터페이스만을 알도록 합니다.

---

**DailyBoxOfficeListRepository**
```swift
protocol DailyBoxOfficeListRepository {
    func fetchDailyBoxOfficeList(date: Date) async throws -> [BasicMovieInfo]
    func fetchMovieDetail(movieCode code: String) async throws -> DetailMovieInfo
}
```
> 서비스에서 제공하는 기능이 두 가지, 즉 유즈케이스가 두 개이기 때문에 레포지토리에서도 두 개의 인터페이스를 제공하도록 간단하게 만들어보았습니다.
>
> 레포지토리를 이용하는 객체는 매개변수를 통해 최소한의 정보를 제공하여 필요로 하는 데이터를 요청할 수 있습니다. `date`나 `movieCode`가 그것입니다.
>
> 유즈케이스 입장에서는 이러한 정보가 어떻게 사용되는지 알 필요도, 알 방법도 없습니다. 그저 자신이 원하는 데이터만 내려주면 괜찮습니다.

```swift
final class DefaultDailyBoxOfficeListRepository {
    // MARK: Dependencies
    private let networkService: NetworkService
    
    // MARK: Properties
    private let apiKey: String? = Bundle.main.koficAPIKey
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    // 생략...
}

// MARK: DailyBoxOfficeListRepository Confirmation
extension DefaultDailyBoxOfficeListRepository: DailyBoxOfficeListRepository {
    func fetchDailyBoxOfficeList(date: Date) async throws -> [BasicMovieInfo] {
        let key = try validateAPIKey()
        let endpoint = EndpointType.dailyBoxOffice(key: key, date: date)
        let entity = try await networkService.request(endpoint: endpoint, for: DailyBoxOfficeModel.self)
        return mapToBasicMovieInfoList(with: entity)
    }
    
    func fetchMovieDetail(movieCode code: String) async throws -> DetailMovieInfo {
        let key = try validateAPIKey()
        let endpoint = EndpointType.movieInfo(key: key, code: code)
        let entity = try await networkService.request(endpoint: endpoint, for: MovieDetailInfoModel.self)
        return mapToDetailMovieInfo(with: entity)
    }
}
```
> Data 계층은 Domain 계층과 Infrastructure 계층을 연결해주는 중간 계층이라는 점에서, 두 계층에 모두 발을 담그고 있다는 듯한 느낌을 받았습니다.
>
> 때문에 레포지토리 객체를 구현할 때 '영화진흥위원회 오픈API의 API Key를 Intrastructure 계층의 네트워킹모델이 아닌 Data 계층의 레포지토리가
> 갖고 있는 것이 옳은가?' 하는 의문점도 들었고, 또한 네트워크 요청에 필요한 EndpointType이라는 모델도 역시 비슷한 이유로 혼란했습니다.
>
> 만약 모든 계층 간에 데이터를 서로 알아보지 못하도록 만들어 의존성을 떨어트리고 싶다면 각 계층 별로 DTO를 두어 변환하는 작업을 거치도록 만들어야 합니다.
>
> 또한 제네릭이나 타입 별칭 등으로 메세징에 필요한 입력 형태와 출력 형태를 지정해주는 것으로도 해소할 수 있을 것 같습니다.
>
> 현재 Infrastructure 계층에 저장소 객체는 구현되어 있지 않아 불가능하지만, 네트워킹 모델을 통해 이미 영화 정보를 얻어냈다면 저장소에 저장해두었다가
> 네트워크 작업 없이 재사용하는 분기점을 바로 이 레포지토리 로직에서 해줄 수 있습니다.
>
> 물론 유즈케이스 입장에서는 데이터가 흘러나오는 곳이 In-Memory 캐싱일지 On-Disk 영구 저장소일지는 몰라도 됩니다.
>
> 레포지토리가 적절히 처리해줄 것이기 때문입니다.

--- 

### Infrastructure Layer
Infrastructure 계층은 앱 서비스가 동작하기 위해 연결되어야 할 외부 요소를 관장하는 영역입니다.
이번 프로젝트에서는 영화진흥위원회 오픈API에 네트워크 작업이 필요하므로 네트워킹 모델이 존재합니다.
또한 데이터를 영속성 저장하고 싶다면 저장고 객체를 만들어 Infrastructure 계층으로 분류하는 것이 좋겠습니다.
재미있던 점은 Infrastructure 계층에서도 데이터 모델이 존재한다는 것이었습니다.
사람마다 다른 용어로 부르는 모양이지만 저는 이것을 Entity라고 불렀습니다.
API로부터 들어오는 JSON을 Swift 코드로 변환했을 때 그것을 Entity라고 불렀기도 하고, CoreData 프레임워크에서도 그러한 모델을 Entity로 불렀기 때문입니다.
이번 프로젝트에서 네트워킹 모델은 역할 별로 조금 더 나누어서 여러가지 객체로 설계했습니다. 이를 뭉뚱그려 Network Layer라고 불렀습니다.

---

**NetworkService**
```swift
protocol NetworkService {
    func request<T: Decodable>(endpoint: Requestable, for type: T.Type) async throws -> T
}

final class DefaultNetworkService {
    private let sessionManager: NetworkSessionManager
    private let decoder: JSONDecoder
    
    init(sessionManager: NetworkSessionManager, decoder: JSONDecoder = JSONDecoder()) {
        self.sessionManager = sessionManager
        self.decoder = decoder
    }
    
    // 생략...
}

// MARK: NetworkService Confirmation
extension DefaultNetworkService: NetworkService {
    func request<T: Decodable>(endpoint: Requestable, for type: T.Type) async throws -> T {
        guard let request = endpoint.urlRequest() else {
            throw NetworkServiceError.invalidURL
        }
        
        do {
            let (data, response) = try await sessionManager.request(request)
            try handleResponse(response)
            let decodedData = try decode(for: type, with: data)
            return decodedData
        } catch {
            throw resolveError(error: error)
        }
    }
}
```
> 레포지토리가 알고 있었던 네트워킹 모델의 인터페이스가 바로 이것입니다. 인터페이스 이용에 필요했던 EndpointType은 열거형으로, 스스로 URLRequest를 만들 수 있는 Requestable 프로토콜을 준수합니다.
>
> 네트워크 서비스는 실질적인 네트워크 통신을 하지는 않는데, 그것은 이후에 기술할 네트워크 세션 매니저의 역할로 분리했습니다.
>
> 네트워크 서비스는 네트워크 세션 매니저를 통해 인터넷으로부터 응답을 받아오고 그것에 대한 사후처리를 담당합니다.
>
> Entity에 대한 Decoding을 어디서 수행하는 것이 적절할지 고민했는데, 실질적인 사용 용도를 고려하여 만든 도메인 모델 `BasicMovieInfo`와는 달리 Entity는 API에서 내려주는
> 거대한 JSON 덩어리를 파싱한 것이므로 이것을 Data 계층까지 가져가봤자 의미가 없을 것이라고 판단, Infrastructure 계층에서 Decoding 하는 것으로 결정했습니다.

---

**NetworkSessionManager**
```swift
protocol NetworkSessionManager {
    func request(_ request: URLRequest) async throws -> (Data, URLResponse)
}

final class DefaultNetworkSessionManager {
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
}

// MARK: NetworkSessionManager Confirmation
extension DefaultNetworkSessionManager: NetworkSessionManager {
    func request(_ request: URLRequest) async throws -> (Data, URLResponse) {
        return try await session.data(for: request)
    }
}
``` 
> 네트워크 세션 매니저는 본격적으로 URLSession 클래스를 다루는 타입입니다.
>
> URLSession의 메서드를 그대로 지원하면서도, 만약 테스트 상황이라면 URLSession의 싱글턴 인스턴스가 아닌 테스트용 인스턴스로 갈아끼우면 됩니다.

---

### Presentation Layer
Presentation 계층은 사용자에게 보여지는 UI 부분을 관장하는 영역입니다.
따라서 뷰 혹은 뷰모델을 Presentation 계층으로 분류했습니다.

---

**DailyBoxOfficeListView**
```swift
struct DailyBoxOfficeListView<ViewModel: MovieListViewModel>: View {
    @ObservedObject private var vm: ViewModel
    
    private let navigationTitle: String = "일일 박스오피스 순위"
    
    init(vm: ViewModel) {
        self.vm = vm
    }
    
    var body: some View {
        List(vm.movies ?? [], id: \.movieCode) { movie in
            movieCell(movie)
        }
        .navigationTitle(navigationTitle)
        .onAppear {
            vm.updateDailyBoxOfficeList()
        }
    }
}

extension DailyBoxOfficeListView {
    private func movieCell(_ movie: BasicMovieInfo) -> some View {
        NavigationLink {
            DetailMovieInfoView(vm: vm, code: movie.movieCode)
        } label: {
            HStack {
                Text(movie.rank)
                    .font(.largeTitle)
                    .padding(4)
                
                VStack(alignment:.leading, spacing: 10) {
                    HStack {
                        Text(movie.movieName)
                            .font(.headline)
                            .lineLimit(1)
                    }
                    
                    HStack {
                        Text("누적 관객수: \(movie.audienceAccumulatedAmount)")
                    }
                }
            }
        }
    }
}
```
> 앱 구동 후 LaunchScreen을 제외하면 가장 처음 보여지게 될 뷰입니다.
>
> 따라서 `@main`엔트리가 있는 Application 계층으로부터 뷰모델을 주입받기 때문에 뷰모델의 생명주기는 `DailyBoxOfficeListView`의 생명주기와 같지 않으므로,
> `@StateObject`가 아닌 `@ObservedObject`로 선언되는 것이 적절해보입니다.
>
> 목록 형태로 이루어진 일일 박스오피스 순위에서 하나의 셀마다 NavigationLink를 달아두어, 보다 자세한 정보를 볼 수 있는 `DetailMovieInfoView`로 연결되게 하였습니다.
>
> 하나의 뷰에 하나의 뷰모델이 매칭되는 구조로 설계할 수도 있었겠지만 SwiftUI에서는 `DetailMovieInfoView`와 같은 컴포넌트 단위의 뷰를 하나 만들어놓고 재사용하는 것이 아주 편리합니다.
>
> 따라서 `MovieListViewModel`의 통제를 받는 하위 뷰로 만들었습니다.
>
> 만약 이 컴포넌트 뷰도 다양한 기능이 생기고 무거워질 수 있다면 그때는 해당 뷰 전용의 뷰모델을 추가로 만드는 것도 고려해볼만 합니다.
>
> 같은 Presentation 계층이어도 마찬가지로 뷰는 뷰모델에 의존합니다.
> 뷰모델을 추상화하여 인터페이스만 제공하는 것으로 의존성을 낮출 수 있습니다.
>
> 뷰에서 쓸 뷰모델은 프로토콜로 추상화되어 정확한 타입을 알 수 없는 불명확 타입(Opaque)이 됩니다.
> 이는 제네릭과 제약설정을 통해 컴파일러가 타입을 알아볼 수 있게 만드는 것으로 해결할 수 있습니다.  

---

**MovieListViewModel**
```swift
protocol MovieListViewModel: ObservableObject {
    var movies: [BasicMovieInfo]? { get }
    var selectedMovieInfo: DetailMovieInfo? { get }
    
    func updateDailyBoxOfficeList()
    func updateDetailMovieInfo(movieCode code: String)
    func flushMovieInfo()
}
```
> `MovieListViewModel`은 영화정보를 표시할 수 있다는 책임을 갖습니다. 

```swift
final class DefaultMovieListViewModel {
    // MARK: Dependencies
    private let fetchDailyBoxOfficeListUseCase: FetchDailyBoxOfficeListUseCase
    private let fetchMovieDetailUseCase: FetchMovieDetailUseCase
    
    // MARK: Properties
    @Published var movies: [BasicMovieInfo]? = []
    @Published var selectedMovieInfo: DetailMovieInfo?
    private var cancellables: Set<AnyCancellable> = []
    
    init(
        fetchDailyBoxOfficeListUseCase: FetchDailyBoxOfficeListUseCase,
        fetchMovieDetailUseCase: FetchMovieDetailUseCase
    ) {
        self.fetchDailyBoxOfficeListUseCase = fetchDailyBoxOfficeListUseCase
        self.fetchMovieDetailUseCase = fetchMovieDetailUseCase
    }
    
    private func handleCompletion(_ completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished: break
        case .failure(let error): print(error)
        }
    }
}

// MARK: MovieListViewModel Confirmation
extension DefaultMovieListViewModel: MovieListViewModel {
    func updateDailyBoxOfficeList() {
        fetchDailyBoxOfficeListUseCase.fetchDailyBoxOfficeList()
            .sink { [weak self] completion in
                self?.handleCompletion(completion)
            } receiveValue: { [weak self] value in
                self?.movies = value
            }
            .store(in: &cancellables)
    }
    
    func updateDetailMovieInfo(movieCode code: String) {
        fetchMovieDetailUseCase.fetchMovieDetail(movieCode: code)
            .sink { [weak self] completion in
                self?.handleCompletion(completion)
            } receiveValue: { [weak self] value in
                self?.selectedMovieInfo = value
            }
            .store(in: &cancellables)
    }
    
    func flushMovieInfo() {
        selectedMovieInfo = nil
        cancellables.forEach { cancellable in
            cancellable.cancel()
        }
    }
}
```
> `MovieListViewModel`의 능력을 실제로 구현하는 구현체는 필요한 의존성 객체를 주입받아 지니게 됩니다.
>
> 의존성 객체에 맞춰서 프로토콜을 준수하면 됩니다.

---

### Application Layer
Application 계층은 앞서 소개한 계층 이외의 것들이 포함되는 영역입니다. 예를 들어, 의존성 주입을 위해 열어놓은 생성자나 메서드 등은 필연적으로 앱 메인으로 모이게 됩니다.
따라서 이러한 의존성 관계 설정 작업이나 뷰 이동을 관리하는 코디네이터 등이 Application 계층에 위치하면 좋습니다.
Application 계층은 서비스 전체의 준비나 통제에 관여한다는 관심사가 모인 곳이라고 생각하면 되겠습니다.
이 프로젝트에서 코디네이터는 없지만 의존성 주입을 위한 의존성 컨테이너를 투박하게나마 만들어보았습니다. 

---

**AppDependencyContainer**
![의존성 관계 모식도](https://github.com/Remaked-Swain/ScreenShotRepository/blob/main/MovieFinder/의존성주입모식도.jpeg?raw=true)

> 서비스를 구성하는 핵심 객체들의 의존성 관계는 이런 모습입니다.
>
> 생성자를 통해 의존성을 주입받고 있으므로, "뷰를 초기화하려면 뷰모델이, 뷰모델을 초기화하려면 유즈케이스가, 유즈케이스를 초기화하려면..."처럼 꼬리에 꼬리를 무는 모습이 나타나게 됩니다.

```swift
DailyBoxOfficeListView(
    vm: MovieListViewModel(
        fetchDailyBoxOfficeListUseCase: DefaultFetchDailyBoxOfficeListUseCase(
            repository: DefaultDailyBoxOfficeListRepository(
                networkService: DefaultNetworkService(
                    sessionManager: DefaultNetworkSessionManager()
                )
            )
        ),
        fetchMovieDetailUseCase: DefaultFetchMovieDetailUseCase(
            repository: DefaultDailyBoxOfficeListRepository(
                networkService: DefaultNetworkService(
                    sessionManager: DefaultNetworkSessionManager()
                )
            )
        )
    )
)
```
> 예를 들어, 앱 구동의 첫 화면인 `DailyBoxOfficeListView`를 초기화하기 위해서는 위와 같은 코드가 되어버립니다.
>
> 단순히 보기에 불편하다는 정도의 문제가 아니었습니다.
>
> 문제는 레포지토리나 네트워킹 레이어 쪽은 단 하나의 인스턴스만 존재하도록 설계하고 싶었으나, 위와 같은 코드에서는 또 새로운 인스턴스를 만들게 되어버린다는 것입니다.

```swift
#Preview {
    DailyBoxOfficeListView(vm: PreviewProvider.shared.movieListViewModel)
}

final class PreviewProvider {
    static let shared = PreviewProvider()
    
    private init() {}
    
    lazy var sessionManager = DefaultNetworkSessionManager()
    lazy var networkService = DefaultNetworkService(sessionManager: sessionManager)
    lazy var dailyBoxOfficeListRepository = DefaultDailyBoxOfficeListRepository(networkService: networkService)
    lazy var fetchDailyBoxOfficeListUseCase = DefaultFetchDailyBoxOfficeListUseCase(repository: dailyBoxOfficeListRepository)
    lazy var fetchMovieDetailUseCase = DefaultFetchMovieDetailUseCase(repository: dailyBoxOfficeListRepository)
    lazy var movieListViewModel = MainViewModel(fetchDailyBoxOfficeListUseCase: fetchDailyBoxOfficeListUseCase, fetchMovieDetailUseCase: fetchMovieDetailUseCase)
}
```
> 때문에 위와 같은 편법적인 코드를 작성하는 행위도 저질렀습니다. 
>
> 이러한 문제를 해결해보고자 의존성 컨테이너를 만들게 되었습니다.

```swift
protocol DependencyResolvable {
    func resolve<T>(for type: T.Type) -> T
}

protocol DependencyRegistrable {
    func register<T>(for key: T.Type, instance: T)
    func register<T>(for type: T.Type, _ handler: @escaping (DependencyResolvable) -> T)
}

typealias AppDependencyContainer = DependencyResolvable & DependencyRegistrable
```
> 의존성 관리를 위한 컨테이너는 의존성 객체를 등록하고 풀어주는 것으로 관계 설정을 가능케 합니다.
>
> 특히 `register<T>(for: _:)` 메서드와 같은 아이디어를 떠올리는 것이 오래 걸렸습니다.

```swift
final class DefaultDependencyContainer {
    // MARK: Properties
    private var dependencies: [String: Any] = [:]
}

// MARK: AppDependencyContainer Confirmation
extension DefaultDependencyContainer: AppDependencyContainer {
    func register<T>(for key: T.Type, instance: T) {
        let key = String(describing: key)
        dependencies[key] = instance
    }
    
    func register<T>(for type: T.Type, _ handler: @escaping (DependencyResolvable) -> T) {
        let key =  String(describing: type)
        dependencies[key] = handler
    }
    
    func resolve<T>(for type: T.Type) -> T {
        let key = String(describing: type)
        
        if let resolver = dependencies[key] as? (DependencyResolvable) -> T {
            return resolver(self)
        } else if let value = dependencies[key] as? T {
            return value
        } else {
            fatalError("의존성 객체 없음: \(type)")
        }
    }
}
```
> 단순하게 타입명을 키 값으로 하는 딕셔너리에 의존성 인스턴스의 참조를 보관합니다.
>
> 또는, 레포지토리나 네트워킹 레이어처럼 하나만 존재하여야 하는 의존성 인스턴스를 다시 가져와 의존성을 연결시킬 수 있도록 핸들러를 보관할 수도 있습니다.

```swift
@main
struct MovieFinderApp: App {
    private let container: AppDependencyContainer = {
        let container: AppDependencyContainer = DefaultDependencyContainer()
        container.register(for: DefaultNetworkSessionManager.self, instance: DefaultNetworkSessionManager())
        container.register(for: DefaultNetworkService.self) { resolver in
            DefaultNetworkService(sessionManager: resolver.resolve(for: DefaultNetworkSessionManager.self))
        }
        container.register(for: DefaultDailyBoxOfficeListRepository.self) { resolver in
            DefaultDailyBoxOfficeListRepository(networkService: resolver.resolve(for: DefaultNetworkService.self))
        }
        container.register(for: DefaultFetchDailyBoxOfficeListUseCase.self) { resolver in
            DefaultFetchDailyBoxOfficeListUseCase(repository: resolver.resolve(for: DefaultDailyBoxOfficeListRepository.self))
        }
        container.register(for: DefaultFetchMovieDetailUseCase.self) { resolver in
            DefaultFetchMovieDetailUseCase(repository: resolver.resolve(for: DefaultDailyBoxOfficeListRepository.self))
        }
        container.register(for: MainViewModel.self) { resolver in
            DefaultMovieListViewModel(fetchDailyBoxOfficeListUseCase: resolver.resolve(for: DefaultFetchDailyBoxOfficeListUseCase.self), fetchMovieDetailUseCase: resolver.resolve(for: DefaultFetchMovieDetailUseCase.self))
        }
        return container
    }()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                DailyBoxOfficeListView(vm: container.resolve(for: DefaultMovieListViewModel.self))
            }
        }
    }
}
```
> `NavigationStack`으로 감싸진 `DailyBoxOfficeListView`를 위해 **이미 의존성 관계가 정립된** 뷰모델을 줄 수 있도록
> 의존성 컨테이너의 도움을 받아 의존성을 주입, 연결시킵니다.
>
> SwiftUI 환경에서 Property Wrapper를 사용하지 않고도 Dependency Injection을 구현할 수 있는 방법과 영감을 얻기 위해 Swinject 라이브러리를 참고했습니다.
>
> Swinject에서는 관련있는 의존성 객체들을 모아두고 한번에 주입, 연결시킬 수 있도록 `Assembly` 프로토콜 등으로 코드를 깔끔히 유지하게 해줍니다만,
> 이 프로젝트에서는 그 부분까지 진행하지는 않았습니다.
>
> 현재 `Assembly` 프로토콜과 같은 기능이 없기에 위와 같이 코드를 작성하게 되면 최초 설정 작업이 번거로운 문제도 있지만, 의존성 주입 순서도 까다롭다는 문제도 있습니다.
>
> 의존성을 무사히 뷰모델까지 주입하기 위해서는 네트워크 세션 매니저부터 **순서대로** 의존성 관계를 설정해주어야 하는데,
> 순서를 지키지 않는 실수를 저지른다면 보관되지 않은 의존성을 꺼내오려고 시도하게 되고, 현재 그런 에러 상황을 대응하는 코드가 컨테이너에 없기 때문입니다.
>
> 또한 뷰에 뷰모델을 전달하는 것이 아니라, 뷰 자체도 컨테이너에서 뷰모델과의 의존성을 주입해주고 뷰를 그릴 시에는 컨테이너를 전달해 각 화면에서 필요한 의존성을 꺼내다 쓰는 방법으로도 개선할 수 있을 것 같습니다.

---

## Rewind
이번 프로젝트를 통해 SwiftUI 환경에서 Clean Architecture와 MVVM 구조 설계 기법을 도입해 다양한 문제 상황을 마주하고 해결해보면서 새로운 개념을 학습할 수 있었습니다.
물론 더욱 개선하고 싶지만 그러지 못했던 부분, 충분히 개선할 수 있었지만 그냥 놔둔 부분(특히 네이밍...) 등등 아쉬움도 남은 프로젝트였습니다.
특별히 좋았던 점은, 매번 Clean Architecture를 궁금해하면서도 그 높은 진입장벽 때문에 쉽게 시작하질 못했으나 드디어 해보았다는 성취감과,
Navigation Coordinator를 SwiftUI 방식으로 구현해볼 수 있지 않을까 하는 새로운 목표도 생겼다는 점입니다.
