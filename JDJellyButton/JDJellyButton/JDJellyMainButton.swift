import UIKit

enum JellyButtonExpandType
{
    case Cross
}

struct ButtonGroups {
    var buttongroup:[JDJellyButtonView]!
    var groupPositionDiff:[CGPoint]?
}

protocol MainButtonDelegate {
    func MainButtonHasBeenTap(touch:UITouch)
}

class JDJellyMainButton:JDJellyButtonView
{
    var rootView:UIView?
    var ExpandType:JellyButtonExpandType = .Cross
    var ContainerView:UIView?
    var buttongroups:[ButtonGroups] = [ButtonGroups]()
    var Expanding:Bool = false
    var animating:Bool = false
    var Moving:Bool = false
    var expandignMove:Bool = false
    var LastPoint:CGPoint?
    var LastTime:TimeInterval?
    var radius:CGFloat = 30.0
    var halfWidth:CGFloat = 0.0
    var GroupIndex:Int = 0
    var xs:[CGFloat] = [CGFloat]()
    var ys:[CGFloat] = [CGFloat]()
    var converView:UIView = UIView()
    
    var delegate:MainButtonDelegate?
    
    init(frame: CGRect,img:UIImage,Parent:UIView)  {
        super.init(frame: frame, bgimg: img, isMainButton: true)
        self.ContainerView = Parent
        halfWidth = self.width * 0.5
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(buttonOpenAnimation))
        self.addGestureRecognizer(tap)
        
        caculateJellyPosition()
    }
    
    func setExpandType(type:JellyButtonExpandType)
    {
        self.ExpandType = type
        caculateJellyPosition()
        updateJellyPosition()
        self.closingButtonGroup(expandagain: true)
    }
    
    func cleanButtonGroup()
    {
        buttongroups = [ButtonGroups]()
    }
    
    func getGroupIndex() -> Int
    {
        return GroupIndex
    }
    
    func getJellyButtonIndex(jelly:JDJellyButtonView) -> Int
    {
        var index = 0
        let nowgroup:ButtonGroups = buttongroups[GroupIndex]
        let buttongroup = nowgroup.buttongroup
        for jellybutton in buttongroup!
        {
            if(jellybutton.imgView == jelly.imgView)
            {
                return index
            }
            index += 1
        }
        return index
    }
    
    func caculateJellyPosition()
    {
        xs = [CGFloat]()
        ys = [CGFloat]()
        if(ExpandType == .Cross)
        {
            xs = [-(halfWidth + radius),halfWidth + radius ,halfWidth + radius,0]
            ys = [-(halfWidth + radius),-(halfWidth + radius),0 ,halfWidth + radius]
        }
    }
    
    func updateJellyPosition()
    {
        var index:Int = 0
        for bg in buttongroups
        {
            var temp_bgs:ButtonGroups = bg
            temp_bgs.groupPositionDiff?.removeAll()
            for i in 0..<bg.buttongroup.count
            {
                temp_bgs.groupPositionDiff?.append(CGPoint(x: xs[i], y: ys[i]))
            }
            buttongroups[index] = temp_bgs
            index += 1
        }
        
    }
    
    func appendButtonGroup(bgs:ButtonGroups)
    {
        var temp_bgs:ButtonGroups = bgs
        for jelly in temp_bgs.buttongroup
        {
            jelly.dependingMainButton = self
        }
        temp_bgs.groupPositionDiff = [CGPoint]()
        
        for i in 0..<bgs.buttongroup.count
        {
            let cgpoint:CGPoint = CGPoint(x: xs[i] , y: ys[i])
            temp_bgs.groupPositionDiff?.append(cgpoint)
        }
        buttongroups.append(temp_bgs)
    }
    
    
    func expandButtonGroup()
    {
        if(GroupIndex < buttongroups.count)
        {
            let nowgroup:ButtonGroups = buttongroups[GroupIndex]
            let buttongroup = nowgroup.buttongroup
            if(!animating)
            {
                let jellyButtonView_1 = buttongroup!.first
                
                jellyButtonView_1!.alpha = 0.0
                jellyButtonView_1!.frame = self.frame
                self.ContainerView!.addSubview(jellyButtonView_1!)
                UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut , animations: {
                    jellyButtonView_1!.frame.origin.y +=  -57
                    jellyButtonView_1!.frame.origin.x +=  -59
                    jellyButtonView_1!.alpha = 1.0
                }, completion:   { (value: Bool) in
                    self.animating = false
                    self.Expanding = true
                })
                
                let jellyButtonView_2 = buttongroup!.last
                
                jellyButtonView_2!.alpha = 0.0
                jellyButtonView_2!.frame = self.frame
                self.ContainerView!.addSubview(jellyButtonView_2!)
                UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut , animations: {
                    jellyButtonView_2!.frame.origin.y +=  -57
                    jellyButtonView_2!.frame.origin.x +=  59
                    jellyButtonView_2!.alpha = 1.0
                }, completion:   { (value: Bool) in
                    self.animating = false
                    self.Expanding = true
                })
                
                converView = UIView(frame: CGRect(x: 0, y: 0, width:Screen.width , height: Screen.height-150))
                converView.backgroundColor = UIColor.clear
                jellyButtonView_2?.superview?.insertSubview(converView, at: 1)
                let tap = UITapGestureRecognizer(target: self, action: #selector(viewDidTap))
                converView.addGestureRecognizer(tap)
            }
        }
    }
    
    func viewDidTap(){
        closingButtonGroup(expandagain: false)
    }
    
    
    func closingButtonGroup(expandagain:Bool)
    {
        if(GroupIndex < buttongroups.count)
        {
            let nowgroup:ButtonGroups = buttongroups[GroupIndex]
            let buttongroup = nowgroup.buttongroup
            var index = 0
            if(!animating)
            {
                for jellybutton in buttongroup!
                {
                    animating = true
                    jellybutton.alpha = 0.0
                    self.animating = false
                    self.Expanding = false
                    jellybutton.removeFromSuperview()
                    index += 1
                }
            }
        }
        converView.removeFromSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buttonOpenAnimation(){
        let transform = CGAffineTransform(translationX: 0, y:6);
        UIView.animate(withDuration: 0.25, animations: {
            self.transform = transform
        }) { (_) in
            UIView.animate(withDuration: 0.3, animations: {
                self.transform = CGAffineTransform.identity
            })
            self.expandButtonGroup()
        }
    }
}



