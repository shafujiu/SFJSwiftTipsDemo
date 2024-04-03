//
//  ProtocolDemoController.swift
//  SFJSwiftTipsDemo
//
//  Created by shafujiu on 2024/4/3.
//

import UIKit

class ProtocolDemoController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // need call this, if have network data and want get data first use "controllerProcess(needAutoLoad: true)"
        controllerProcess()
    }
}


extension ProtocolDemoController: ViewControllerProtocol {
    
    func initSubviewsAndStates() {
        
    }
    
    func installLayout() {
        
    }
    
    func handleViewActions() {
        
    }
    
    func asyncLoadData(state: ViewControllerLoadDataState, completion: @escaping AsynLoadDataCompletion) {
        
    }
}
