//
//  ViewController.swift
//  MotionVisualize
//
//  Created by 渡辺泰伎 on 2017/01/14.
//  Copyright © 2017年 Project. All rights reserved.
//

import UIKit

class title: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //startボタンでgetMotion画面に遷移
    @IBAction func goGetMotion(_ sender: AnyObject) {
        let targetView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "getMotion")
        targetView.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(targetView, animated: true, completion: nil)
    }

    
}

