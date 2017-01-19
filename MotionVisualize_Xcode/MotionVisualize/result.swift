//
//  result.swift
//  MotionVisualize
//
//  Created by 合田 和馬 on 2017/01/15.
//  Copyright © 2017年 Project. All rights reserved.
//

import UIKit

class result: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backTop(_ sender: AnyObject) {
        let targetView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "title")
        targetView.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(targetView, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
