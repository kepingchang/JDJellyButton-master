//
//  ViewController.swift
//  JDJellyButton
//
//  Created by JamesDouble on 2016/12/9.
//  Copyright © 2016年 jamesdouble. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    var button:JDJellyButton!
    @IBOutlet weak var exampleimg: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        button = JDJellyButton()
        button.attachtoView(rootView: view,mainbutton: UIImage(named:"launcher_globalback")!)
        button.delegate = self
    }
}

extension ViewController:JellyButtonDelegate
{
    func JellyButtonHasBeenTap(touch:UITouch,image:UIImage,groupindex:Int,arrindex:Int)
    {
        self.exampleimg.image = image
    }
    
}
