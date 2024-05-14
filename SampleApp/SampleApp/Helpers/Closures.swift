//
//  Closures.swift
//  SampleApp
//
//  Created by Daniel Velikov on 11.02.24.
//

import Foundation

typealias VoidClosure = () -> Void
typealias ItemClosure<T> = (T) -> Void
typealias BoolClosure = ItemClosure<Bool>
typealias ReturnItemClosure<T> = () -> T
