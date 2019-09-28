//
//  LoggingViewController.swift
//  trackproj
//
//  Created by Danil on 28/09/2019.
//  Copyright © 2019 levinda. All rights reserved.
//

/* Currently logging this actions
viewDidLoad
viewWillAppear
viewDidAppear
viewWillLayoutSubviews
viewDidLayoutSubviews
viewWillDisappear
viewDidDisappear

 */

import UIKit

class LoggingViewController: UIViewController {
    
    
    override func viewDidLoad() {
          super.viewDidLoad()
          print("\(self): DidLoad")
          // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print( "\(self): WillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("\(self): DidAppear")
    }
    
     override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("\(self): WillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("\(self): DidDisappear")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print("\(self): WillLayoutSubviews")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("\(self): DidLayoutSubviews")
    }
        
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
