//
//  SFJObserve.swift
//
//  Created by Aiwei on 2022/8/3.
//

import Foundation

public typealias SFJObserve = SFJObserved & KYObserving

public protocol SFJObserved: AnyObject {
    typealias Observable<Value>  = ObservableWrapper<Self, Value>
    
    typealias Weak<Value: AnyObject>  = WeakWrapper<Self, Value>
}

public typealias ObserverTable = UnionObserver

public protocol KYObserving: Compatible, AnyObject {}

extension KYObserving {
    fileprivate var observerTable: ObserverTable {
        if let table = objc_getAssociatedObject(self, &observerTableKey) as? ObserverTable {
            return table
        } else {
            let table = ObserverTable()
            objc_setAssociatedObject(self, &observerTableKey, table, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return table
        }
    }
    
    fileprivate func cleanObserverTable() {
        observerTable.removeAll()
    }
}
private var observerTableKey: UInt8 = 0

extension Wrapper where Base: KYObserving {
    public var observerTable: ObserverTable {
        base.observerTable
    }
    
    public func cleanObserverTable() {
        base.cleanObserverTable()
    }
}

extension ObserverType {
    public func held(by table: ObserverTable) {
        table += self
    }
}

