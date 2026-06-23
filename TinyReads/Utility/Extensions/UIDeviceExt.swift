//
//  UIDeviceExt.swift
//  TinyReads
//
//  Created by user on 23.06.2026.
//

import Foundation
import SwiftUI

extension UIDevice {
	 static var isIPad: Bool {
		  UIDevice.current.userInterfaceIdiom == .pad
	 }
	 
	 static var isIPhone: Bool {
		  UIDevice.current.userInterfaceIdiom == .phone
	 }
}
