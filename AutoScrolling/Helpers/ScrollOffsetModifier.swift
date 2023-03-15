//
//  ScrollOffsetModifier.swift
//  AutoScrolling
//
//  Created by Martin.Q on 2023/03/14.
//

import SwiftUI

/// Offset Key
struct OffsetKey: PreferenceKey {
	static var defaultValue: CGRect = .zero
	
	static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
		value = nextValue()
	}
}

extension View {
	@ViewBuilder
	func offsetX(_ addObserver: Bool = false, completion: @escaping (CGRect) -> ()) -> some View {
		self
			.overlay {
				if addObserver {
					GeometryReader {
						let rect = $0.frame(in: .global)
						Color.clear
							.preference(key: OffsetKey.self, value: rect)
							.onPreferenceChange(OffsetKey.self, perform: completion)
					}
				}
			}
	}
}
