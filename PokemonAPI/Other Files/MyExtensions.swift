//
//  MyExtensions.swift
//  Ku
//
//  Created by Abraham Escamilla Pinelo on 21/03/18.
//  Copyright © 2018 Dacodes. All rights reserved.
//

import Foundation
import UIKit

let defaults = UserDefaults.standard

//MARK: User Defaults

extension UserDefaults {
    var statusLogin: Bool {
        get { return defaults.bool(forKey: "status_login") }
        set { defaults.set(newValue, forKey: "status_login") }
    }
}

//MARK: - UIViewController


extension UIViewController{
    
    func resignCurrentFirstResponder() {
        UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func transitionToMain() {
        
        guard let window = self.view.window else {return}
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = storyboard.instantiateViewController(withIdentifier: "PokemonListViewController")
        self.present(mainVC, animated: true, completion: nil)
    }
    
    func transitionToLogin() {
        
        guard let window = self.view.window else {return}
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        self.present(loginVC, animated: true, completion: nil)
        
    }
    
    /**
     Function for setting the back button item of a navigation bar, to blank.
     ## Must perform in the prepareForSegue function
     */
    func setEmptyBackButtonItemTitle() {
        let backItem = UIBarButtonItem()
        backItem.title = " "
        navigationItem.backBarButtonItem = backItem
        
    }
    
    func setNavBarInvisible() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
    }
    
    func showToastWith(message : String, color: UIColor) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        //toastLabel.font = UIFont.binAvenirNextRegularFont()
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.backgroundColor = color
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    
    
    /**
     Creates and presents an alert on the ViewController is called.
     - Parameter title: the title of the alertcontroller. The default value is "Dypaq"
     - Parameter message: the message to be displayed on the alert. The default value is nil.
     - Parameter type: The UIAlertControllerStyle of the AlertController. The default is .alert
     - Parameter actions: An array of the actions that the alert is going to have. The default value is an action with title "Aceptar" and no closure.
     */
    func createAlertView(_ title: String?, _ message: String? = nil, type : UIAlertControllerStyle = .alert ,actions: UIAlertAction...) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: type)
        actions.forEach { (action) in
            alert.addAction(action)
        }
        self.present(alert, animated: true, completion:nil)
    }
    
    func showAlertOneButtonWith(alertTitle: String, alertMessage: String, buttonTitle: String, handler:  ((UIAlertAction) -> Void)? = nil){
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let button = UIAlertAction(title: buttonTitle, style: .default, handler: handler)
        
        alert.addAction(button)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertTwoButtonsWith(
        alertTitle: String,
        alertMessage: String,
        firstButtonTitle: String,
        firstButtonStyle: UIAlertActionStyle,
        firstButtonHandler: ((UIAlertAction) -> Void)? = nil,
        secondtButtonTitle: String,
        secondButtonStyle: UIAlertActionStyle,
        secondButtonHandler: ((UIAlertAction) -> Void)? = nil){
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        let firstButton = UIAlertAction(title: firstButtonTitle, style: firstButtonStyle, handler: firstButtonHandler)
        
        let secondButton = UIAlertAction(title: secondtButtonTitle, style: secondButtonStyle, handler: secondButtonHandler)
        
        
        
        alert.addAction(firstButton)
        alert.addAction(secondButton)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    /// Adds a Child ViewController to self.view of the ViewController.
    /// - Parameter child: Child ViewController to be added.
    func add(_ child: UIViewController) {
        addChildViewController(child)
        view.addSubview(child.view)
        child.view.frame = view.bounds
        child.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        child.didMove(toParentViewController: self)
    }
    
    /// Adds a Child ViewController to the given view of the ViewController.
    /// - Parameter child: Child ViewController to be added.
    /// - Parameter containerView: The view where the Child ViewController will be added.
    func add(_ child: UIViewController, to containerView: UIView) {
        addChildViewController(child)
        containerView.addSubview(child.view)
        child.view.frame = containerView.bounds
        child.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        child.didMove(toParentViewController: self)
    }
    
    
    /// Remove the current ViewController from its parent, if it has one.
    func remove() {
        guard parent != nil else {
            return
        }
        
        willMove(toParentViewController: nil)
        removeFromParentViewController()
        view.removeFromSuperview()
    }
}



//MARK: - UITextField

extension UITextField{
    
    /// Adds left padding to the text container of the textfield
    ///
    /// - Parameter amount: the amount in points to be added as padding
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setNoAutoCorrection() {
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
    }
    
    func pointCursorToBegining(){
        
        let position = self.beginningOfDocument
        self.selectedTextRange = self.textRange(from: position, to: position)
    }
    
    //    func addBottomBorderWith(color: UIColor = UIColor.white, width: CGFloat = 0.5){
    //        let border = CALayer()
    //        let width = width
    //        border.borderColor = color.cgColor
    //        border.frame = CGRect(x: 0, y: self.frame.size.height - 1.0, width:  self.frame.size.width, height: 1.0)
    //        //        border.frame = CGRect(origin: CGPoint(x: 0, y:self.frame.height - 1), size: CGSize(width: self.frame.width, height:  1))
    //        border.borderWidth = width
    //        self.layer.addSublayer(border)
    //        self.layer.masksToBounds = true
    //    }
    
    func setBottomBorder(_ color: UIColor) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: self.frame.height - 1, width: self.frame.width, height: 1.0)
        bottomLine.backgroundColor = color.cgColor
        self.layer.addSublayer(bottomLine)
        self.layer.masksToBounds = true
    }
    
    
    func roundCorners2(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    
}

//MARK: - UIImage

public extension UIImage {
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}

//MARK: - String

extension String {
    
    func trim() -> String {
        
        return self.replacingOccurrences(of: " ", with: "")
    }
    
    func restrict(to num: Int) -> String {
        
        if self.count > num {
            
            guard let lastIndex = self.index(of: self.last!) else {
                return ""
            }
            return String(self[...lastIndex])
        }else{
            return self
        }
        
    }
}

//MARK: - Double

extension Double {
    
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

//MARK: - UIButton

public enum UIButtonBorderSide {
    case Top, Bottom, Left, Right, All
}


//MARK: - UIView

extension UIView {
    
    /// Width of view.
    public var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            self.frame.size.width = newValue
        }
    }
    
    /// Height of view.
    public var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            self.frame.size.height = newValue
        }
    }
    
    func applyBottomShadow() {
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize.init(width: 0, height: 2.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 5.0
    }
    
    func addBlurEffect(_ style: UIBlurEffectStyle, alpha: CGFloat = 0.5) {
        
        let blurEffect = UIBlurEffect(style: style)
        
        let effectView = UIVisualEffectView(effect: blurEffect)
        
        effectView.frame = self.bounds
        effectView.alpha = alpha
        
        self.insertSubview(effectView, at: 0)
        
    }
    
    func removeBorder() {
        
        for layer in self.layer.sublayers! {
            if layer.name == "border" {
                layer.removeFromSuperlayer()
            }
        }
    }
    
    public func addBorder(side: UIButtonBorderSide, color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.name = "border"
        border.backgroundColor = color.cgColor
        
        switch side {
        case .Top:
            border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: width)
            self.layer.addSublayer(border)
        case .Bottom:
            border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
            self.layer.addSublayer(border)
        case .Left:
            border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
            self.layer.addSublayer(border)
        case .Right:
            border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
            
            self.layer.addSublayer(border)
        case .All:
            let topBorder = CALayer()
            let bottomBorder = CALayer()
            let rightBorder = CALayer()
            let leftBorder = CALayer()
            
            topBorder.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: width)
            topBorder.backgroundColor = color.cgColor
            
            bottomBorder.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
            bottomBorder.backgroundColor = color.cgColor
            
            leftBorder.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
            leftBorder.backgroundColor = color.cgColor
            
            rightBorder.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
            rightBorder.backgroundColor = color.cgColor
            
            
            self.layer.addSublayer(topBorder)
            self.layer.addSublayer(bottomBorder)
            self.layer.addSublayer(leftBorder)
            self.layer.addSublayer(rightBorder)
            
        }
        
        
    }
    
    func applyShadow(width: Int = 3, height: Int = 3, color: UIColor = UIColor.lightGray) {
        
        //Adds a shadow to sampleView
        
        layer.shadowOffset = CGSize(width: width, height: height)
        layer.shadowColor = color.cgColor
        layer.shadowRadius = 2
        layer.shadowOpacity = 1
        self.layer.masksToBounds = false
        
        layer.shouldRasterize = true
    }
    
    func showActivityIndicator(){
        
        //        let container: UIView = UIView()
        //        container.frame = self.frame
        //        container.center = self.center
        //        container.backgroundColor = UIColor.binLightGray
        //        container.tag = 12
        //
        //        let loadingView: UIView = UIView()
        //        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        //        loadingView.center = self.center
        //        loadingView.backgroundColor = UIColor.binDarkGray
        //        loadingView.clipsToBounds = true
        //        loadingView.layer.cornerRadius = 10
        //        loadingView.tag = 123
        
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        actInd.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
        actInd.center = CGPoint(x: (self.frame.size.width / 2) - 20, y: (self.frame.size.height / 2) - 20)
        //actInd.center = self.center
        actInd.tag = 1234
        
        self.addSubview(actInd)
        actInd.startAnimating()
    }
    
    func dismissActivityIndicator(){
        
        
        if let view = self.viewWithTag(1234) {
            view.removeFromSuperview()
        }
    }
    
    
    func applyGradient(colours: [UIColor], direction: GradientDirection = .topToBottom) -> Void {
        self.applyGradient(colours: colours, locations: nil, direction: direction)
    }
    
    enum GradientDirection {
        case topToBottom
        case leftToRight
    }
    
    func applyGradient(colours: [UIColor], locations: [NSNumber]?, direction: GradientDirection = .topToBottom) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.name = "gradientLayer"
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        
        switch direction {
        case .topToBottom:
            gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        case .leftToRight:
            
            gradient.startPoint = CGPoint(x: 0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1, y: 0.5)
        }
        
        
        
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func removeGradient() {
        
        for layer in self.layer.sublayers! {
            
            if layer.name == "gradientLayer" {
                layer.removeFromSuperlayer()
            }
            
        }
    }
    
    func animateConstraintWithDuration(duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, options: UIViewAnimationOptions, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration, delay:delay, options:options, animations: { [weak self] in
            self?.layoutIfNeeded() ?? ()
            }, completion: completion)
    }
    
    
    
    func pushTransition(_ duration:CFTimeInterval)
    {
        let animation:CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionPush
        animation.subtype = kCATransitionFromTop
        animation.duration = duration
        layer.add(animation, forKey: kCATransitionPush)
    }
    
    func topToDownTransition(_ duration: CFTimeInterval, isRemovedOnCompletion: Bool = false)
    {
        let animation:CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionPush
        animation.subtype = kCATransitionFromBottom
        animation.duration = duration
        animation.isRemovedOnCompletion = isRemovedOnCompletion
        layer.add(animation, forKey: kCATransitionPush)
        
        
    }
    
    func bottomToTopTransition(_ duration: CFTimeInterval, isRemovedOnCompletion: Bool = false)
    {
        let animation:CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionPush
        animation.subtype = kCATransitionFromTop
        animation.duration = duration
        animation.isRemovedOnCompletion = isRemovedOnCompletion
        layer.add(animation, forKey: kCATransitionPush)
        
    }
    
    func fadeTransition(_ duration: CFTimeInterval){
        
        let animation:CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionFade
        //animation.subtype = kCATransition
        animation.duration = duration
        //animation.isRemovedOnCompletion = isRemovedOnCompletion
        layer.add(animation, forKey: kCATransitionPush)
        
    }
    
    func fadeAnimation(_ duration: CFTimeInterval, animations: @escaping () -> Void,completion: (() -> Void)?) {
        UIView.animate(withDuration: duration, delay: 0.0, options: [.allowAnimatedContent], animations: {
            animations()
        }) { (success) in
            guard let handler = completion else {return}
            handler()
        }
        
    }
    
    func rightToLeftTransition(_ duration: CFTimeInterval)
    {
        let animation:CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionPush
        animation.subtype = kCATransitionFromRight
        animation.duration = duration
        layer.add(animation, forKey: kCATransitionPush)
    }
    
    func leftToRightTransition(_ duration: CFTimeInterval)
    {
        let animation:CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionPush
        animation.subtype = kCATransitionFromLeft
        animation.duration = duration
        layer.add(animation, forKey: kCATransitionPush)
    }
    
    func roundBordersWith(radius: CGFloat){
        
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = false
        self.clipsToBounds = true
        //self.layer.borderWidth = 0.5
        
    }
    
    func roundBorders(){
        
        self.layer.cornerRadius = self.frame.size.height/2
        self.layer.masksToBounds = true
        self.clipsToBounds = true
        
    }
    
    
    
    func roundCorners(_ corners: UIRectCorner, with radius: CGFloat) {
        
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        self.layer.mask = shape
    }
    
    func underlined(){
        
        let border = CALayer()
        let width = CGFloat(0.5)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - 1.0, width:  self.frame.size.width, height: 1.0)
        
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    func drawLineFromPointToPoint(startX: Int, toEndingX endX: Int, startingY startY: Int, toEndingY endY: Int, ofColor lineColor: UIColor, widthOfLine lineWidth: CGFloat, animated: Bool) {
        
        
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: startX, y: startY))
        path.addLine(to: CGPoint(x: endX, y: endY))
        
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = lineWidth
        
        self.layer.addSublayer(shapeLayer)
        
        //Animar el trazado de la linea
        if animated {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = 0
            animation.duration = 0.7
            shapeLayer.add(animation, forKey: "MyAnimation")
        }
        
        
    }
    
    func addTopBorderWith(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.borderWidth = width
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0,y: 0, width:self.frame.size.width, height:width)
        self.layer.addSublayer(border)
    }
    
    func addRightBorderWith(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.borderWidth = width
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width,y: 0, width:width, height:self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func addBottomBorderWith(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.borderWidth = width
        border.frame = CGRect(x:0, y:self.frame.height - width, width:self.frame.size.width, height:width)
        self.layer.addSublayer(border)
    }
    
    func addLeftBorderWith(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.borderWidth = width
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0, y:0, width:width, height:self.frame.size.height)
        self.layer.addSublayer(border)
    }
}



