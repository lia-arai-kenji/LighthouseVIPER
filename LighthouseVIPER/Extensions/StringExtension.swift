//
//  StringExtension.swift
//  LighthouseVIPER
//
//  Created by udwiqut on 2026/05/22.
//

extension String {
    
    var nilIfEmpty: String? {
        self.isEmpty ? nil : self
    }
}

extension Optional where Wrapped == String {
    
    var nilIfEmpty: String? {
        self?.nilIfEmpty ?? nil
    }
}

