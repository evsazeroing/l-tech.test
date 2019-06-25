//
//  ViewController.swift
//  l-tech.test
//
//  Created by Евгений on 19/06/2019.
//  Copyright © 2019 Евгений. All rights reserved.
//

import UIKit
import InputMask
import Alamofire
import SwiftyJSON

class AuthorizationController: UIViewController, MaskedTextFieldDelegateListener {

    @IBOutlet weak var textPhoneNumber: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    var listener: MaskedTextFieldDelegate?
    var mask: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !getAuthData(){ // Если нет данных для успешной авторизации, получить маску
            setPhoneMask()
        }
    }
    
    
    func setPhoneMask() {
        ServerRequest.standard.getPhoneMask(setPhoneMaskAfter: setPhoneMaskAfter)
    }
    
    // Вызов после получения маски с сервера
    func setPhoneMaskAfter(maskExpression: String){
        
        mask = getCodeForMask(mask: maskExpression)
        
        listener = MaskedTextFieldDelegate(format: mask)
        listener?.delegate = self
        textPhoneNumber.delegate = listener
        textPhoneNumber.isEnabled = true
        textPhoneNumber.placeholder = maskExpression
    }
    
    func getCodeForMask(mask: String) -> String! {
        
        var lastX = false
        var newMask: String! = ""
        
        for character in mask {
            if character == "Х" && lastX == false {
                newMask.append("[")
                newMask.append(character)
                lastX = true
            } else if character != "Х" && lastX == true{
                newMask.append("]")
                newMask.append(character)
                lastX = false
            } else{
                newMask.append(character)
            }
        }
        
        newMask.append("]")
        
        return newMask.replacingOccurrences(of: "Х", with: "0")
    }
 
    @IBAction func tapSignIn(_ sender: UIButton) {
        
        if let phone = textPhoneNumber.text, let password = textPassword.text{
        
            ServerRequest.standard.authorization(phone: decodeNumber(phoneNumber: phone) , password: password, authAfter: authAfter)
        }
        
    }
    
    // Вызов после успешной авторизации
    func authAfter(success: Bool, params: [String: Any]){
        if success{
            var paramsToSave: [String: Any] = params
            paramsToSave.updateValue(mask, forKey: "maskExpression")
            paramsToSave.updateValue(textPhoneNumber.placeholder ?? "", forKey: "placeholder")
            setAuthData(params: paramsToSave)
            openList()
        }else{
            presentFailAlert()
        }
    }
    
    //Сохранение параметров авторизации
    func setAuthData(params: [String: Any]){
        let defaults = UserDefaults.standard
        defaults.set(params, forKey: "userAuthData")
        
    }
    
    //Получение параметров авторизации
    func getAuthData() -> Bool{
        let defaults = UserDefaults.standard
        if let params = defaults.dictionary(forKey: "userAuthData") {
            
            let maskExpression = params["maskExpression"] as! String
            
            setPhoneMaskAfter(maskExpression: maskExpression)
            
            textPhoneNumber.text = params["phone"] as? String
            textPassword.text = params["password"] as? String
            
            return true
        }
        return false
    }
    
    //Получение числовых символов из строки
    func decodeNumber(phoneNumber: String) -> String{
        return phoneNumber.filter("01234567890.".contains)
    }
    
    func openList(){
        let nav = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NavigationController")
        self.present(nav, animated: true, completion: nil)
    }
    
    func presentFailAlert(){
        
        let alert = UIAlertController(title: "",
                                      message: "Could not authorize this phone because either your phone number or password are invalid",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK",
                                     style: .cancel,
                                     handler: nil)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}
