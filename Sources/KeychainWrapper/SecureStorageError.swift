//
//  SecureStorageError.swift
//  
//
//  Created by Vsevolod Pavlovskyi on 20.03.2021.
//

import Foundation

public struct SecureStorageError: Error {

    var message: String?
    var type: KeychainErrorType

    enum KeychainErrorType {
        case badData
        case servicesError
        case itemNotFound
        case unableToConvertToString
        case unableToConvertToData
    }

    init(status: OSStatus, type: KeychainErrorType) {
        self.type = type
        if let errorMessage = SecCopyErrorMessageString(status, nil) {
            self.message = String(errorMessage)
        } else {
            self.message = "Status Code: \(status)"
        }
    }

    init(type: KeychainErrorType) {
        self.type = type
    }

    init(message: String, type: KeychainErrorType) {
        self.message = message
        self.type = type
    }

}
