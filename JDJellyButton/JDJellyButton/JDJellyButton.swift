import UIKit

enum ExpandType {
    case Cross
}

class JelllyContainer:UIView
{
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews {
            if !subview.isHidden && subview.alpha > 0 && subview.isUserInteractionEnabled && subview.point(inside: convert(point, to: subview), with: event) {
                return true
            }
        }
        return false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class JDJellyButton
{
    var MainButton:JDJellyMainButton!
    var Container:JelllyContainer!
    var RootView:UIView?
    var delegate:JellyButtonDelegate?
    
    var buttonWidth:CGFloat = 80.0
    var buttonHeight:CGFloat = 80.0
    
    init(Landscape:Bool? = false) {
        if Landscape! {
            Container = JelllyContainer(frame: CGRect(x: 0, y: 0, width: Screen.height, height: Screen.width))
        }else{
            Container = JelllyContainer(frame: CGRect(x: 0, y: 0, width: Screen.width, height: Screen.height))
        }
    }
    
    func reloadData()
    {
        cleanButtonGroup()
        addButtonGroup()
    }
    
    func attachtoView(rootView:UIView,mainbutton image:UIImage, Landscape:Bool? = false)
    {
        RootView = rootView
        
        var MainButtonFrame:CGRect = CGRect()
        if Landscape! {
            MainButtonFrame = CGRect(x: (Screen.height - image.size.width) / 2, y: Screen.width - image.size.height, width: image.size.width, height: 80)
        }else{
            MainButtonFrame = CGRect(x: (Screen.width - image.size.width) / 2, y: Screen.height - image.size.height, width: image.size.width, height: 80)
        }
        
        MainButton = JDJellyMainButton(frame: MainButtonFrame, img: image, Parent: Container)
        MainButton.imgView?.contentMode = .top
        
        MainButton.rootView = rootView
        MainButton.delegate = self
        Container.addSubview(MainButton)
        rootView.addSubview(Container)
        
        reloadData()
    }
    
    func addButtonGroup()
    {
        var jellybuttons:[JDJellyButtonView] = [JDJellyButtonView]()
        let imgarr:[UIImage] = [UIImage(named: "skill_hide")!, UIImage(named: "skill_quit")!]
        for img in imgarr
        {
            let MainButtonFrame:CGRect = CGRect(x: (MainButton.width - buttonWidth)/2, y: 0, width: buttonWidth, height: buttonHeight)
            
            let jellybutton:JDJellyButtonView = JDJellyButtonView(frame: MainButtonFrame, bgimg: img)
            jellybutton.layer.masksToBounds = true
            jellybutton.tapdelegate = self
            jellybuttons.append(jellybutton)
        }
        let jellybuttongroup:ButtonGroups = ButtonGroups(buttongroup: jellybuttons, groupPositionDiff: nil)
        MainButton.appendButtonGroup(bgs: jellybuttongroup)
    }
    
    func cleanButtonGroup()
    {
        MainButton.closingButtonGroup(expandagain: false)
        MainButton.cleanButtonGroup()
    }
    
    func setJellyType(type:JellyButtonExpandType)
    {
        MainButton.setExpandType(type: type)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hide(){
        MainButton.removeFromSuperview()
        Container.removeFromSuperview()
    }
}

extension JDJellyButton:MainButtonDelegate
{
    func MainButtonHasBeenTap(touch:UITouch)
    {
        let point = touch.location(in: RootView!)
        Container.x = point.x - 0.5 * self.Container.width
        Container.y = point.y - 0.5 * self.Container.height
    }
    
}

extension JDJellyButton:JellyButtonDelegate
{
    func JellyButtonHasBeenTap(touch:UITouch,image:UIImage,groupindex:Int,arrindex:Int)
    {
        delegate?.JellyButtonHasBeenTap(touch: touch, image: image, groupindex: groupindex, arrindex: arrindex)
    }
}




