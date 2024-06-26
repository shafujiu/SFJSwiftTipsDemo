//
//  Notification.swift
//  SFJSwiftTipsDemo
//
//  Created by shafujiu on 2024/4/3.
//

import Foundation

fileprivate let EasyNotificationUserInfoKey = "EasyNotificationUserInfoKey"

public class EasyNotification<UserInfoType> {
    private lazy var name: NSNotification.Name = {
        Notification.Name("\(type(of: self))-\(Unmanaged.passUnretained(self).toOpaque())")
    }()
    
    public func post(_ userInfo: UserInfoType, via center: NotificationCenter = .default) {
        center.post(name: name, object: self, userInfo: [EasyNotificationUserInfoKey: userInfo])
    }
    
    public func addObserver(from center: NotificationCenter = .default, queue: OperationQueue? = nil, using block: @escaping (Notification, UserInfoType)-> Void) -> EasyNotificationObserver {
        let handle = center.addObserver(forName: name, object: self, queue: queue) { notification in
            guard let userInfo = notification.userInfo?[EasyNotificationUserInfoKey] as? UserInfoType else {
                return
            }
            block(notification, userInfo)
        }
        return EasyNotificationObserver(center: center, handle: handle)
    }
}

public class EasyNotificationObserver {
    private weak var center: NotificationCenter?
    
    private weak var handle: NSObjectProtocol?
    
    init(center: NotificationCenter, handle: NSObjectProtocol) {
        self.center = center
        self.handle = handle
    }
    
    deinit {
        center?.removeObserver(handle as Any)
    }
}

extension EasyNotificationObserver: ObserverType {
    public func invalidate() {
        center?.removeObserver(handle as Any)
    }
}

//MARK: - NotificationCenter
extension NotificationCenter {
    fileprivate func easyObserver(forName name: NSNotification.Name, object obj: Any?, queue: OperationQueue?, using block: @escaping (Notification) -> Void) -> EasyNotificationObserver {
        EasyNotificationObserver(center: self, handle: addObserver(forName: name, object: obj, queue: queue, using: block))
    }
}

extension Wrapper where Base == NotificationCenter {
    func addObserver(forName name: NSNotification.Name, object obj: Any? = nil, queue: OperationQueue? = nil, using block: @escaping (Notification) -> Void) -> EasyNotificationObserver {
        base.easyObserver(forName: name, object: obj, queue: queue, using: block)
    }
}
