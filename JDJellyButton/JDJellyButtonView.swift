import UIKit

 protocol JellyButtonDelegate {
    func JellyButtonHasBeenTap(touch:UITouch,image:UIImage,groupindex:Int,arrindex:Int)
}

extension JellyButtonDelegate{
    func JellyButtonHasBeenTap(touch:UITouch,image:UIImage,groupindex:Int,arrindex:Int)
      {
      }
}



class JDJellyButtonView:UIView
{
    var tapdelegate:JellyButtonDelegate?
    var dependingMainButton:JDJellyMainButton?
    var imgView:UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(frame: CGRect,BGColor:UIColor) {
        super.init(frame: frame)
       
        self.layer.cornerRadius = 0.4 * self.frame.width
        self.backgroundColor = BGColor
    }
    
    init(frame: CGRect,bgimg:UIImage, isMainButton:Bool? = false) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 0.4 * self.frame.width
        imgView = UIImageView(image: bgimg)
        imgView?.bounds = self.bounds
        imgView?.center = self.center
        if isMainButton! {
            imgView?.frame = self.bounds
        }
        self.addSubview(imgView!)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
       let image = self.imgView?.image
       let groupindex = dependingMainButton?.getGroupIndex()
       let arrindex = dependingMainButton?.getJellyButtonIndex(jelly: self)
       tapdelegate?.JellyButtonHasBeenTap(touch: touches.first!,image: image!,groupindex: groupindex!,arrindex: arrindex!)
    }
    
}

