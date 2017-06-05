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
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!

    
    let images:[UIImage] = [UIImage(named: "hide")!,UIImage(named: "quit")!]
    var imagearr:[[UIImage]] = [[UIImage]]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        imagearr.append(images)
        
        button = JDJellyButton()
        button.attachtoView(rootView: self.view,mainbutton: UIImage(named:"vk")!)
        button.delegate = self
        button.datasource = self
        button.setJellyType(type: .Cross)
        
    }

}

extension ViewController:JellyButtonDelegate
{
    func JellyButtonHasBeenTap(touch:UITouch,image:UIImage,groupindex:Int,arrindex:Int)
    {
        self.exampleimg.image = image
        label1.text = "Group Index:\(groupindex)"
        label2.text = "ArrIndex\(arrindex)"
    }
    
}

extension ViewController:JDJellyButtonDataSource
{
    func groupcount()->Int
    {
    return 1
    }
    func imagesource(forgroup groupindex:Int) -> [UIImage]
    {
    return imagearr[groupindex]
    }
}
