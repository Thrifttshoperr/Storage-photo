import Foundation
import SwiftyKeychainKit

class KeychainClass {
    
    static let shared = KeychainClass()
    private init() {}
    
    let keychain = Keychain(service: "Check")
    let key = KeychainKey<String>(key: "Allow")


}
