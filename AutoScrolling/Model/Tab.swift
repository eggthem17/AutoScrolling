//
//  Tab.swift
//  AutoScrolling
//
//  Created by Martin.Q on 2023/03/14.
//

import SwiftUI

/// Enum Tab Cases
/// - rawValue: Asset Image Name

enum Tab: String, CaseIterable {
	case dance = "Dance"
	case fruite = "Fruite"
	case mirror = "Mirror"
	case night = "Night"
	case road = "Road"
	
	/// Tab Index
	var index: Int {
		return Tab.allCases.firstIndex(of: self) ?? 0
	}
	
	/// Total Count
	var count: Int {
		return Tab.allCases.count
	}
}
