//
//  CopyableLabel.swift
//  福大助手
//
//  Created on 16/3/29.

import UIKit
class CopyableLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        sharedInit()
    }
    
    func sharedInit() {
        userInteractionEnabled = true
        addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(CopyableLabel.showMenu(_:))))
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func copy(sender: AnyObject?) {
        let board = UIPasteboard.generalPasteboard()
        board.string = text
        let menu = UIMenuController.sharedMenuController()
        menu.setMenuVisible(false, animated: true)
    }
    
    func showMenu(sender: AnyObject?) {
        becomeFirstResponder()
        let menu = UIMenuController.sharedMenuController()
        if !menu.menuVisible {
            menu.setTargetRect(bounds, inView: self)
            menu.setMenuVisible(true, animated: true)
        }
    }
    
    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        if action == #selector(NSObject.copy) {
            return true
        }
        return false
    }
    
}
