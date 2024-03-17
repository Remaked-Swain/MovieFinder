import XCTest
@testable import MovieFinder

final class MovieFinderTests: XCTestCase {
    
}

// MARK: NetworkService TestCases
final class NetworkServiceTests: XCTestCase {
    private var systemUnderTest: NetworkServiceProtocol!
    
    override func setUpWithError() throws {
        systemUnderTest = NetworkService()
        try super.setUpWithError()
    }
    
    override func tearDownWithError() throws {
        systemUnderTest = nil
        try super.tearDownWithError()
    }
}
