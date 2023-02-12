//
//  TokenListBox.swift
//  Pods
//
//  Created by 传骑 on 2/13/23
//  Copyright (c) 2023 Rajax Network Technology Co., Ltd. All rights reserved.
//
    

import Foundation

public actor TokenListBox<T:Equatable&Hashable> {
	public private(set) var list = [T]()
	public init() {}
	public func append(_ contentsOfElements:[T]) {
		self.list.append(contentsOf: contentsOfElements)
		self.list = self.list.unique()
	}
	public func append(_ element:T) {
		if !self.list.contains(element) {
			self.list.append(element)
		}
	}
	public func dropFirst(_ k: Int = 1) -> ArraySlice<T> {
		return self.list.dropFirst()
	}
	public func delete(_ element:T) {
		return self.list.removeAll { str in
			return str == element
		}
	}
	public func deleteByCondition(_ condition:(T)->Bool) {
		return self.list.removeAll { element in
			return condition(element)
		}
	}
}

public extension Array where Element: Hashable {
	func unique() -> Self {
		return Array(Set(self))
	}
}
