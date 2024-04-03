import Foundation

/// 加载数据的状态
public enum ViewControllerLoadDataState: Equatable {
    case initial, reload, loadMore
}

/// 异步加载数据完成回调
public typealias AsynLoadDataCompletion = (_ respondData: Any?, _ error: CustomNSError?) -> Void

/// 视图控制器的模板方法
public protocol ViewControllerProtocol: AnyObject {
    /// 初始化subViews与view state
    func initSubviewsAndStates()
    
    /// 设置布局
    func installLayout()
    
    /// 处理view action
    func handleViewActions()
    
    /// 将Subviews与数据进行绑定
    func bindSubviewsAndData()
    
    /// 异步加载动态数据
    func asyncLoadData(state: ViewControllerLoadDataState, completion: @escaping AsynLoadDataCompletion)
    
    /// 异步数据加载失败
    func asyncLoadFailed(error: CustomNSError)
    
    /// 处理/持有异步数据
    func handleAsyncData(_ data: Any?)
}

extension ViewControllerProtocol {
    public func controllerProcess(needAutoLoad: Bool = true) {
        initSubviewsAndStates()
        installLayout()
        handleViewActions()
        bindSubviewsAndData()
        if needAutoLoad {
            loadAsyncData(state: .initial)
        }
    }
    
    public func loadAsyncData(state: ViewControllerLoadDataState = .reload) {
        asyncLoadData(state: state) {[weak self] respondData, error in
            if let error = error {
                self?.asyncLoadFailed(error: error)
            } else {
                self?.handleAsyncData(respondData)
            }
        }
    }
    
    public func asyncLoadData(state: ViewControllerLoadDataState, completion: @escaping AsynLoadDataCompletion) {
        completion(nil, nil)
    }
    
    public func asyncLoadFailed(error: CustomNSError) {
        #if DEBUG
        print("未处理的数据加载报错: ")
        print(error.errorUserInfo)
        #endif
    }
    
    //MARK: ViewControllerProtocol 默认空实现
    public func handleViewActions() {}
    
    public func bindSubviewsAndData() {}
    
    public func handleAsyncData(_ data: Any?) {}
}
