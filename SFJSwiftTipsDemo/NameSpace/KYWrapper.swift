//
//  Wrapper.swift
//  SFJSwiftTipsDemo
//
//  Created by shafujiu on 2024/4/3.
//  命名空间

import UIKit

/// 新增命名空间方法实现，类似：UIColor.ky.e32kdlColor，参考：https://github.com/onevcat/Kingfisher/blob/master/Sources/General/Kingfisher.swift
public struct Wrapper<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol Compatible { }

/// 扩展快音的命名空间
public extension Compatible {
    var ky: Wrapper<Self> {
        get {return Wrapper(self)}
        set {}
    }
    
    static var ky: Wrapper<Self>.Type {
        get { Wrapper<Self>.self}
        set {}
    }
}
