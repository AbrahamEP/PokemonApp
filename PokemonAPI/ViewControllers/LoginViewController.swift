//
//  LoginViewController.swift
//  PokemonAPI
//
//  Created by Abraham Escamilla Pinelo on 23/07/18.
//  Copyright © 2018 AEP. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    
    @IBAction func loginButtonAction(_ sender: UIButton)
    {
        guard let email = self.emailTextField.text, let pass = self.passwordTextField.text, !HelpTools.areThereEmptyFields(fields: email, pass) else {
            self.showAlertOneButtonWith(alertTitle: "Campos vacíos", alertMessage: "Por favor, llena todos los campos", buttonTitle: "Aceptar")
            return
        }
        
        //Hacer login
        HelpTools.showProgressHUD(in: self.view)
        LoginAPI.login(email: email, password: pass) { (err) in
            HelpTools.dismissProgressHUD(in: self.view)
            if err == nil {
                HelpTools.setLogin()
                self.transitionToMain()
            }else {
                self.showAlertOneButtonWith(alertTitle: "Error", alertMessage: err!.message, buttonTitle: "Aceptar")
            }
        }
        
        
    }
    
    
}
