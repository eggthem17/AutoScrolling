//
//  AnimationEndCallBack.swift
//  AutoScrolling
//
//  Created by Martin.Q on 2023/03/14.
//

import SwiftUI

struct AnimationState {
	var progress: CGFloat = 0
	var status: Bool = false
	
	mutating func startAnimation() {
		progress = 1.0
		status = true
	}
	
	mutating func reset() {
		progress = .zero
		status = false
	}
}

struct AnimationEndCallBack<Value: VectorArithmetic>: Animatable, ViewModifier {
	var animatableData: Value {
		didSet {
			checkIfAnimationFinished()
		}
	}
	
	var endValue: Value
	var onEnd: () -> ()
	
	init(endValue: Value, onEnd: @escaping () -> ()) {
		self.endValue = endValue
		self.animatableData = endValue
		self.onEnd = onEnd
	}
	
	func body(content: Content) -> some View {
		content
	}
	
	func checkIfAnimationFinished() {
		if animatableData == endValue {
			DispatchQueue.main.async {
				onEnd()
			}
		}
	}
}
