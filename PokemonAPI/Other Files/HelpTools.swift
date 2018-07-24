//
//  HelpTools.swift
//
//  Created by Abraham Escamilla Pinelo on 25/05/17.
//  Copyright © 2017 DaCodes. All rights reserved.
//

import Foundation
import MessageUI
import MBProgressHUD

class HelpTools {
    
    
    //MARK: - Other tools
    
    public static func isUserLoggedIn() -> Bool {
        
        return UserDefaults.standard.bool(forKey: "login")
    }
    
    public static func setLogin() {
        
        UserDefaults.standard.set(true, forKey: "login")
    }
    
    public static func logout() {
        UserDefaults.standard.removeObject(forKey: "login")
    }
    
    public static func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
    
    public static func restrictCharactersInTextField(maxLength: Int, text: String, range: NSRange, string: String) -> Bool{
        
        let currentString: NSString = text as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        
        return newString.length <= maxLength
    }
    
    
    public static func areThereEmptyFields(fields: String?...) -> Bool{
        
        for field in fields {
            
            guard let f = field, !f.isEmpty else {
                return true
            }
        }
        
        return false
        
    }
    
    public static func isAppFirstTime() -> Bool {
        
        let defaults = UserDefaults.standard
        
        if defaults.bool(forKey: "hasRunBefore") == false {
            
            return true
        }else{
            
            return false
        }
    }
    
    public static func setAppFirstTime () {
        
        let defaults = UserDefaults.standard
        
        defaults.set(true, forKey: "hasRunBefore")
        defaults.synchronize()
    }
    
    
    public static func stringFormatOf(date: Date?, withFormat format: String = "dd/MM/yyyy") -> String {
        
        guard let currentDate = date else {
            return "No disponible"
        }
        
        var formattedDate = ""
        let myDateFormatter = DateFormatter()
        myDateFormatter.dateFormat = format
        myDateFormatter.locale = Locale.init(identifier: "es_MX")
        
        formattedDate = myDateFormatter.string(from: currentDate)
        
        return formattedDate
        
    }
    
    public static func sendEmailWith(recipients: [String], subject: String, messageBody: String, isHtml: Bool, FromViewController vc: UIViewController) {
        
        let emailVC = MFMailComposeViewController()
        emailVC.mailComposeDelegate = vc as? MFMailComposeViewControllerDelegate
        
        if MFMailComposeViewController.canSendMail() {
            
            emailVC.setToRecipients(recipients)
            emailVC.setSubject(subject)
            emailVC.setMessageBody(messageBody, isHTML: isHtml)
            
            vc.present(emailVC, animated: true, completion: nil)
        }else{
            
            vc.showAlertOneButtonWith(alertTitle: "Alerta", alertMessage: "Tu dispositivo no admite este servicio", buttonTitle: "Aceptar")
        }
        
        
    }
    
    public static func sendMessageWith(recipients: [String], messageBody: String, FromViewController vc: UIViewController) {
        
        let messageVC = MFMessageComposeViewController()
        messageVC.messageComposeDelegate = vc as? MFMessageComposeViewControllerDelegate
        
        if MFMessageComposeViewController.canSendText() {
            
            messageVC.recipients = recipients
            messageVC.body = messageBody
            
            vc.present(messageVC, animated: true, completion: nil)
        }else{
            
            vc.showAlertOneButtonWith(alertTitle: "Alerta", alertMessage: "Tu dispositivo no admite este servicio", buttonTitle: "Aceptar")
        }
    }
    
    public static func convertDateToMilliseconds(date: Date) -> Double {
        
        let since1970 = date.timeIntervalSince1970 * 1000
        
        return since1970
    }
    
    public static func dateFromMilliseconds(millis: TimeInterval) -> Date {
        
        let date = Date(timeIntervalSince1970: millis / 1000)
        
        return date
    }
    
    public static func dateISO8601From(string: String) -> Date? {
        
        return self.dateFrom(string: string, withFormat: "yyyy-MM-dd'T'HH:mm:ssXXX")
    }
    
    public static func stringDateISO8601From(date: Date) -> String {
        
        //return self.stringFormatOf(date: date, withFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")
        return self.stringFormatOf(date: date, withFormat: "yyyy-MM-dd'T'HH:mm:ssXXX")
        
    }
    
    public static func dateFrom(string: String, withFormat format: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ") -> Date?
    {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale.init(identifier: "es_MX")
        formatter.calendar = Calendar.init(identifier: .gregorian)
        
        guard let date = formatter.date(from: string) else {
            return nil
        }
        
        return date
        
    }
    
    public static func showProgressHUD(in view: UIView, animated: Bool = true) {
        
        MBProgressHUD.showAdded(to: view, animated: animated)
        
    }
    
    
    public static func dismissProgressHUD(in view: UIView, animated: Bool = true) {
        
        MBProgressHUD.hide(for: view, animated: animated)
    }
    
    public static func getImage(from urlString: String) -> UIImage? {
        
        do {
            let url = URL(string: urlString)
            
            guard let picUrl = url else {
                return nil
            }
            let photoData = try Data(contentsOf: picUrl)
            
            return UIImage(data: photoData)
            
        } catch  {
            return nil
        }
    }
    
    
    
}
