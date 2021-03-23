//
//  SecureStorage.swift
//  
//
//  Created by Vsevolod Pavlovskyi on 23.03.2021.
//

import Foundation

public protocol SecureStorage {

    func set(_ value: String, forKey service: String) throws
    func get(forKey service: String) throws -> String
    func update(_ value: String, forKey service: String) throws
    func delete(forKey service: String) throws

}
