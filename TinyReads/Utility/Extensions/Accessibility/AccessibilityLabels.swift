//
//  AccessibilityLabels.swift
//  TinyReads
//
//  Created by user on 21.06.2026.
//

import SwiftUI

extension SecondaryAppScreen {
  var accessibilityLabel: LocalizedStringKey {
	 switch self {
	 case .profile:
		"Open profile"
	 case .category:
		"Open categories"
	 case .dismissed:
		"Open dismissed cards"
	 case .archive:
		"Open saved cards"
	 case .store:
		"Open in app store"
	 }
  }
  
  var accessibilityHint: LocalizedStringKey {
	 switch self {
	 case .profile:
		"Shows reader settings and statistics."
	 case .category:
		"Choose the topics you want to read."
	 case .dismissed:
		"Shows cards you dismissed."
	 case .archive:
		"Shows saved and read cards."
	 case .store:
		"Shows app store"
	 }
  }
}

extension ProfileActionBarEnum {
  var accessibilityLabel: LocalizedStringKey {
	 switch self {
	 case .language:
		"Change language"
	 case .theme:
		"Change theme"
	 case .categories:
		"Change categories"
	 case .avatars:
		"Change avatar"
	 }
  }
  
  var accessibilityHint: LocalizedStringKey {
	 switch self {
	 case .language:
		"Opens language selection."
	 case .theme:
		"Opens theme selection."
	 case .categories:
		"Opens category selection."
	 case .avatars:
		"Opens avatar selection."
	 }
  }
}

extension DeckMode {
  var accessibilityLabel: LocalizedStringKey {
	 switch self {
	 case .freshOnly:
		"Show viewed cards"
	 case .repeatOld:
		"Show fresh cards"
	 }
  }
  
  var accessibilityHint: LocalizedStringKey {
	 switch self {
	 case .freshOnly:
		"Switches to cards you already read, saved, or dismissed."
	 case .repeatOld:
		"Switches back to new unread cards."
	 }
  }
}

extension ArchiveState {
  var accessibilityLabel: LocalizedStringKey {
	 switch self {
	 case .all:
		"Show all interacted cards"
	 case .dismissed:
		"Show dismissed cards"
	 case .saved:
		"Show saved cards"
	 case .read:
		"Show read cards"
	 }
  }
}
