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
	@State private var tapState: AnimationState = .init()
	@State private var avgColor: Color = .clear
	
    var body: some View {
		GeometryReader {
			let size = $0.size
			
			VStack(spacing: 0) {
				TabIndicatorView()
				
				TabView(selection: $activeTab) {
					ForEach(Tab.allCases, id: \.rawValue) { tab in
						TabImageView(tab)
							.tag(tab)
							.offsetX(activeTab == tab) { rect in
								let minX = rect.minX
								let pageOffset = minX - (size.width * CGFloat(tab.index))
								
								/// Converting Page Offset into Progress
								let pageProgress = pageOffset / size.width
								
								/// Limiting Progress
								/// Simply Disable when the TapState value is true
								if !tapState.status {
									scrollProgress = max(min(pageProgress, 0), -CGFloat(Tab.allCases.count - 1))
								}
							}
					}
				}
				.tabViewStyle(.page(indexDisplayMode: .never))
			}
			.background{
				avgColor
					.overlay(Material.ultraThinMaterial)
			}
			.ignoresSafeArea(.container, edges: .bottom)
		}
		.onChange(of: activeTab) { newValue in
			withAnimation {
				self.setAverageColor(tab: activeTab)
			}
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
	@ViewBuilder
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
	@ViewBuilder
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
						.contentShape(Rectangle())
						.onTapGesture {
							withAnimation(.easeInOut(duration: 0.3)) {
								activeTab = tab
								/// Scroll Progess Explicitly
								scrollProgress = -CGFloat(tab.index)
								tapState.startAnimation()
							}
						}
				}
			}
			.frame(width: CGFloat(Tab.allCases.count) * tabWidth)
			.padding(.leading, tabWidth)
			.offset(x: scrollProgress * tabWidth)
		}
		.modifier(
			AnimationEndCallBack(endValue: tapState.progress, onEnd: {
				print("reset")
				tapState.reset()
			})
		)
		.frame(height: 50)
		.padding(.top, 15)
	}
	
	private func setAverageColor(tab: Tab) {
		let uiColor = UIImage(named: tab.rawValue)?.averageColor ?? .clear
		avgColor = Color(uiColor)
	}
}
