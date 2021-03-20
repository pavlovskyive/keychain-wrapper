import XCTest
@testable import KeychainWrapper

/// IMPORTANT
///
/// Launch tests with Mac target selected (iOS keychain works incorrectly in spm unit tests).
/// Could write mocks, but no time for that now.


final class KeychainWrapperTests: XCTestCase {
    
    let keychainWrapper = KeychainWrapper()
    
    let testKey1 = "testKey1"
    let testKey2 = "testKey2"
    
    let testValue1 = "testValue1"
    let testValue2 = "testValue2"

    override func tearDown() {
        
        try? keychainWrapper.delete(forKey: testKey1)
        
        super.tearDown()
    }
    
    func testWrapperSet() {
        
        do {
            try keychainWrapper.set(testValue1, forKey: testKey1)
            let value = try keychainWrapper.get(forKey: testKey1)
            XCTAssertEqual(value, testValue1)
        } catch {
            XCTFail(error.localizedDescription)
        }

    }
    
    func testWrapperUpdate() {
        
        do {
            try keychainWrapper.set(testValue1, forKey: testKey1)
            try keychainWrapper.set(testValue2, forKey: testKey1)
            let value = try keychainWrapper.get(forKey: testKey1)
            XCTAssertEqual(value, testValue2)
        } catch {
            XCTFail(error.localizedDescription)
        }
        
        do {
            try keychainWrapper.set(testValue1, forKey: testKey1)
            try keychainWrapper.update(testValue2, forKey: testKey1)
            let value = try keychainWrapper.get(forKey: testKey1)
            XCTAssertEqual(value, testValue2)
        } catch {
            XCTFail(error.localizedDescription)
        }

    }
    
    func testWrapperDelete() {
        
        try? keychainWrapper.set(testValue1, forKey: testKey1)
        
        do {
            try keychainWrapper.delete(forKey: testKey1)
            let _ = try keychainWrapper.get(forKey: testKey1)
            XCTFail("Should be an error")
        } catch {
            return
        }
        
        try? keychainWrapper.set(testValue1, forKey: testKey1)
        
        do {
            try keychainWrapper.set("", forKey: testKey1)
            let _ = try keychainWrapper.get(forKey: testKey1)
            XCTFail("Should be an error")
        } catch {
            return
        }
        
    }
    
    func testReadError() {
        
        do {
            let _ = try keychainWrapper.get(forKey: testKey1)
            XCTFail()
        } catch {
            return
        }
        
    }

    static var allTests = [
        ("testWrapperSet", testWrapperSet)
    ]

}
