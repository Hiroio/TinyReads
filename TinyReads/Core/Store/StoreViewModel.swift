//
//  StoreViewModel.swift
//  TinyReads
//
//  Created by user on 06.07.2026.
//

import Foundation
import StoreKit

enum StoreError: Error {
  case failedVerification
}

@Observable
final class StoreViewModel {
  
  var state: StoreSectionEnum? = nil
  
  
}
