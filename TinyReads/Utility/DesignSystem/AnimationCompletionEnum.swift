//
//  AnimationCompletionEnum.swift
//  TinyReads
//
//  Created by user on 18.06.2026.
//

import Foundation


enum AnimationCompletionEnum{
  case success, failure
  
  
  var name: String{
	 switch self {
	 case .failure:
		return "FailureSprite"
	 case .success:
		return "CompleteSprite"
	 }
  }
  
  var sprites: Int{
	 switch self {
	 case .success:
		13
	 case .failure:
		26
	 }
  }
  
}

