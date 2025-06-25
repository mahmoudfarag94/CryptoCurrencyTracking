//
//  NetworkManagerTests.swift
//  CryptoTrackingTests
//
//  Created by Mahmoud Farag on 27/12/2024.
//

import XCTest
@testable import CryptoTracking

final class NetworkManagerTests: XCTestCase {
    private var sut: NetworkManager!
    private var mockSession: MockURLSession!
    private var decoder: JSONDecoder!
    
    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        decoder = JSONDecoder()
        sut = NetworkManager(session: mockSession, decoder: decoder)
    }
    
    override func tearDown() {
        sut = nil
        mockSession = nil
        decoder = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func test_fetch_withValidResponse_shouldReturnDecodedObject() async throws {
        // Given
        let expectedObject = TestModel(id: 1, name: "Test")
        let mockData = try! JSONEncoder().encode(expectedObject)
        let mockResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        mockSession.mockData = mockData
        mockSession.mockResponse = mockResponse
        
        let endpoint = MockAPIEndpoint()
        
        // When
        let result: TestModel = try await sut.fetch(endpoint: endpoint)
        
        // Then
        XCTAssertEqual(result.id, expectedObject.id)
        XCTAssertEqual(result.name, expectedObject.name)
    }
    
    func test_fetch_withInvalidURL_shouldThrowBadURLError() async {
        // Given
        let endpoint = MockAPIEndpoint()
        
        // When
        do {
            _ = try await sut.fetch(endpoint: endpoint) as TestModel
            XCTFail("Expected to throw, but did not throw")
        } catch let error as AppError {
            // Then
            XCTAssertEqual(error, .unknown(message: "Mock response not set."))
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
    
    func test_fetch_withServerErrorResponse_shouldThrowServerError() async {
        // Given
        let mockResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 500, httpVersion: nil, headerFields: nil)
        mockSession.mockResponse = mockResponse
        mockSession.mockData = Data()
        
        let endpoint = MockAPIEndpoint()
        
        // When
        do {
            _ = try await sut.fetch(endpoint: endpoint) as TestModel
            XCTFail("Expected to throw, but did not throw")
        } catch let error as AppError {
            // Then
            XCTAssertEqual(error, .server(statusCode: 500))
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
    
    
    func test_fetch_withInvalidData_shouldThrowDecodingFailed() async {
        // Given
        let invalidData = "Invalid JSON".data(using: .utf8)
        let mockResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        mockSession.mockData = invalidData
        mockSession.mockResponse = mockResponse
        
        let endpoint = MockAPIEndpoint()
        
        // When
        do {
            _ = try await sut.fetch(endpoint: endpoint) as TestModel
            XCTFail("Expected to throw, but did not throw")
        } catch let error as AppError {
            // Then
            XCTAssertEqual(error, .decodingFailed)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
}
