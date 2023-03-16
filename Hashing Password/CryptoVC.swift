//
//  CryptoVC.swift
//  Hashing Password
//
//  Created by Rustem Manafov on 16.03.23.
//

import UIKit
import CommonCrypto
import CryptoKit

class CryptoVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var hashedPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordTextField.delegate = self
        hashedPasswordTextField.delegate = self
        
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc func textFieldDidChange() {
        if passwordTextField.text == "" {
            hashedPasswordTextField.text = ""
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if passwordTextField.text == nil {
            hashedPasswordTextField.text = ""
        }
    }
    
    func hash(password: String, salt: String) -> String? {
        guard let data = (password + salt).data(using: .utf8) else {
            return nil
        }

        let hashed = SHA256.hash(data: data)
        let hashedString = hashed.compactMap { String(format: "%02x", $0) }.joined()

        let index = hashedString.index(hashedString.startIndex, offsetBy: 12)
        let truncatedHash = hashedString[..<index]

        return String(truncatedHash)
    }
    
    func generateSalt() -> String {
        let length = 16
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let randomCharacters = (0..<length).map { _ in characters.randomElement()! }
        let randomString = String(randomCharacters)
        return randomString
    }
    
    @IBAction func hashPassword(_ sender: Any) {
        
        let password = passwordTextField.text ?? ""
        let salt = generateSalt()
        
        let hashedPassword = hash(password: password, salt: salt)
        
        hashedPasswordTextField.text = hashedPassword
        
        if passwordTextField.text == "" && hashedPasswordTextField.text != nil {
            let alert = UIAlertController(title: "Alert", message: "Write password in the Password TextField", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
            present(alert, animated: true)
            hashedPasswordTextField.text = ""
        }
    }
}


