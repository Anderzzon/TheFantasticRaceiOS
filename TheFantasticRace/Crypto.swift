//
//  Crypto.swift
//  The Fantastic Race
//
//  Created by Erik Westervind on 2021-05-17.
//

import Foundation
import CryptoKit

class Crypto {
    static let key = "maga2020!"
    var symetricKey: SymmetricKey?
    
    init() {
        symetricKey = createKey(key: Crypto.key)
    }
    
    func encryptData(input: String, password: SymmetricKey) throws -> String {
        let textData = input.data(using: .utf8)! //convert to data
        let encrypted = try AES.GCM.seal(textData, using: password) //Encrypt using AES-GCM
        return encrypted.combined!.base64EncodedString() //Return string
    }
    
    func decryptData(input: String, password: SymmetricKey) -> String {
        do {
            guard let data = Data(base64Encoded: input) else {
                return "\(input)"
            }
            
            let sealedBox = try AES.GCM.SealedBox(combined: data) //Sealed box
            let decryptedData = try AES.GCM.open(sealedBox, using: password) //decrypt sealed box using password
            
            //Convert data to text:
            guard let text = String(data: decryptedData, encoding: .utf8) else {
                return "Could not decode data: \(decryptedData)"
            }
            
            return text
        } catch let error {
            return "Error decrypting message: \(error.localizedDescription)"
        }
    }
    
    func createKey(key: String) -> SymmetricKey {
        let inputKey = Data(key.utf8) //Convert string to Data
        
        let hashed = SHA256.hash(data: inputKey) // hash the key
        
        return SymmetricKey(data: hashed)
    }

}
