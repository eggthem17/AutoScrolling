//
//  Home.swift
//  AutoScrolling
//
//  Created by Martin.Q on 2023/03/14.
//

import SwiftUI

struct Home: View {
	/// View Properties
	@State private var activeTab: Tab = .dance
	@State private var scrollProgress: CGFloat = .zero
	
    var body: some View {
		VStack(spacing: 0) {
			TabIndicatorView()
			
			TabView(selection: $activeTab) {
				ForEach(Tab.allCases, id: \.rawValue) { tab in
					TabImageView(tab)
				}
			}
			.tabViewStyle(.page(indexDisplayMode: .never))
			.ignoresSafeArea(.container, edges: .bottom)
		}
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
		ContentView()
    }
}

extension Home {
	/// Image View
	func TabImageView(_ tab: Tab) -> some View {
		GeometryReader {
			let size = $0.size
			
			Image(tab.rawValue)
				.resizable()
				.aspectRatio(contentMode: .fill)
				.frame(width: size.width, height: size.height)
				.clipped()
		}
		.ignoresSafeArea(.container, edges: .bottom)
	}
	
	/// Tab Indicator
	func TabIndicatorView() -> some View {
		GeometryReader {
			let size = $0.size
			let tabWidth = size.width / 3
			
			HStack(spacing: 0) {
				ForEach(Tab.allCases, id: \.rawValue) { tab in
					Text(tab.rawValue)
						.font(.title3.bold())
						.foregroundColor(activeTab == tab ? .primary : .gray)
						.frame(width: tabWidth)
				}
			}
			.frame(width: CGFloat(Tab.allCases.count) * tabWidth)
			.padding(.leading, tabWidth)
			.offset(x: scrollProgress * tabWidth)
		}
		.frame(height: 50)
		.padding(.top, 15)
	}
}
