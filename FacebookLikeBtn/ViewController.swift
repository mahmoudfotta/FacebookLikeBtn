//
//  ViewController.swift
//  FacebookLikeBtn
//
//  Created by mahmoud gamal on 7/13/18.
//  Copyright © 2018 mahmoud gamal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var selectedView: UIView!
    var selectedImageView = UIImageView()
    
    let iconsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        let iconHeight: CGFloat = 50
        let padding: CGFloat = 8
        let arrangedSubViews = [UIColor.red, .cyan, .blue, .yellow, .green].map({ (color) -> UIView in
            let v = UIImageView()
            v.backgroundColor = color
            v.layer.cornerRadius = iconHeight/2
            v.isUserInteractionEnabled = true
            return v
        })
        let stackView = UIStackView(arrangedSubviews: arrangedSubViews)
        stackView.distribution = .fillEqually
        stackView.spacing = padding
        stackView.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        stackView.isLayoutMarginsRelativeArrangement = true
        view.addSubview(stackView)
        
        let numOfICons = CGFloat(arrangedSubViews.count)
        let width = numOfICons * iconHeight + (numOfICons + 1) * padding
        
        view.frame = CGRect(x: 0, y: 0, width: width, height: iconHeight + 2 * padding)
        view.layer.cornerRadius = view.frame.height/2
        //shadow
        view.layer.shadowColor = UIColor(white: 0.4, alpha: 0.4).cgColor
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowPath = UIBezierPath(roundedRect: view.frame, cornerRadius: view.frame.height/2).cgPath
        stackView.frame = view.frame
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLongPressGesture()
    }
    
    fileprivate func setupLongPressGesture() {
        view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress)))
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            handleGestureBegan(gesture: gesture)
        } else if gesture.state == .ended {
            
           self.selectedView.backgroundColor = selectedImageView.backgroundColor
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                let stackView = self.iconsContainerView.subviews.first
                stackView?.subviews.forEach({ (imageView) in
                    imageView.transform = .identity
                })
                
                self.iconsContainerView.transform = self.iconsContainerView.transform.translatedBy(x: 0, y: self.iconsContainerView.frame.height)
                self.iconsContainerView.alpha = 0
                
            }, completion: {(_) in
                self.iconsContainerView.removeFromSuperview()
            })
            
        } else if gesture.state == .changed {
            handlGestureChanged(gesture: gesture)
        }
    }
    
    fileprivate func handlGestureChanged(gesture: UILongPressGestureRecognizer) {
        let preseedLocation = gesture.location(in: iconsContainerView)
        let fixedYLocation = CGPoint(x: preseedLocation.x, y: self.iconsContainerView.frame.height/2)
        let hitTestView = iconsContainerView.hitTest(fixedYLocation, with: nil)
        if hitTestView is UIImageView {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                let stackView = self.iconsContainerView.subviews.first
                stackView?.subviews.forEach({ (imageView) in
                    imageView.transform = .identity
                })
                let translate = CGAffineTransform(translationX: 0, y: -30)
                let scale = CGAffineTransform(scaleX: 1.4, y: 1.4)
                hitTestView?.transform = translate.concatenating(scale)
                
                self.selectedImageView = hitTestView as! UIImageView
            })
            

        }
    }
    
    fileprivate func handleGestureBegan(gesture: UILongPressGestureRecognizer) {
        view.addSubview(iconsContainerView)
        
        let pressedLocation = gesture.location(in: view)
        let centeredX = (view.frame.width-iconsContainerView.frame.width)/2
        //transformation of icons container view
        iconsContainerView.transform = CGAffineTransform(translationX: centeredX, y: pressedLocation.y)
        
        // animation
        iconsContainerView.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.iconsContainerView.alpha = 1
            if (pressedLocation.y - self.iconsContainerView.frame.height) < 15 {
                self.iconsContainerView.transform = CGAffineTransform(translationX: centeredX, y: pressedLocation.y)
            } else {
                self.iconsContainerView.transform = CGAffineTransform(translationX: centeredX, y: pressedLocation.y-self.iconsContainerView.frame.height)
            }
            
        })
    }
}

