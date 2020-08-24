//
//  SignUpViewController.swift
//  Story Book
//
//  Created by Ashan Anuruddika on 6/15/20.
//  Copyright © 2020 Ashan. All rights reserved.
//

import UIKit

import FirebaseAuth

import FirebaseDatabase

class SignUpViewController: UIViewController {

    @IBOutlet weak var signUPDetailView: UIView!
    
    @IBOutlet weak var MainSignUpDetailView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var dobTextField: UITextField!
    
    @IBOutlet weak var countryTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var retypePasswordTextField: UITextField!

    public var languageResouce = String()
    
    private let languageLocalization = LanguageLocalization()
    
    private let datePicker = UIDatePicker()
    
    private let toolBar = UIToolbar()
    
    lazy var touchView : UIView = {
        
        let _touchView = UIView()
        
        _touchView.backgroundColor = UIColor(displayP3Red: 0.1, green: 0.1, blue: 0.1, alpha: 0)
        
        _touchView.isUserInteractionEnabled = true
        
        _touchView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        _touchView.addGestureRecognizer(gestureRecognizer)
        
        return _touchView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Edited on SignUp Detail View
        signUPDetailView.layer.cornerRadius = 18
        
        signUPDetailView.layer.borderColor = UIColor(named: "SignUp_Border_Color")!.cgColor
        
        signUPDetailView.layer.borderWidth = 1
        
        signUPDetailView.layer.shadowColor = UIColor(named: "SignUp_Shadow_Color")!.cgColor
        
        signUPDetailView.layer.shadowPath = UIBezierPath(rect: signUPDetailView.bounds).cgPath
        
        signUPDetailView.layer.shadowRadius = 10
        
        signUPDetailView.layer.shadowOffset = .init(width: 5, height: 10)
        
        signUPDetailView.layer.shadowOpacity = 1
        
        //Edited on First Name Text Field
        firstNameTextField.layer.cornerRadius = 18
        
        firstNameTextField.layer.borderColor = UIColor(named: "SignUp_TextFieldBorder_Color")!.cgColor
        
        firstNameTextField.layer.borderWidth = 1
        
        //Edited on Last Name Text Field
        lastNameTextField.layer.cornerRadius = 18
        
        lastNameTextField.layer.borderColor = UIColor(named: "SignUp_TextFieldBorder_Color")!.cgColor
        
        lastNameTextField.layer.borderWidth = 1
        
        //Edited on Email Text Field
        emailTextField.layer.cornerRadius = 18
        
        emailTextField.layer.borderColor = UIColor(named: "SignUp_TextFieldBorder_Color")!.cgColor
        
        emailTextField.layer.borderWidth = 1
        
        //Edited on Date of Birth Text Field
        dobTextField.layer.cornerRadius = 18
        
        dobTextField.layer.borderColor = UIColor(named: "SignUp_TextFieldBorder_Color")!.cgColor
        
        dobTextField.layer.borderWidth = 1
        
        //Edited on Country Text Field
        countryTextField.layer.cornerRadius = 18
        
        countryTextField.layer.borderColor = UIColor(named: "SignUp_TextFieldBorder_Color")!.cgColor
        
        countryTextField.layer.borderWidth = 1
        
        //Edited on Password Text Field
        passwordTextField.layer.cornerRadius = 18
        
        passwordTextField.layer.borderColor = UIColor(named: "SignUp_TextFieldBorder_Color")!.cgColor
        
        passwordTextField.layer.borderWidth = 1
        
        //Edited on Retype Password Text Field
        retypePasswordTextField.layer.cornerRadius = 18
        
        retypePasswordTextField.layer.borderColor = UIColor(named: "SignUp_TextFieldBorder_Color")!.cgColor
        
        retypePasswordTextField.layer.borderWidth = 1
        
        addLcalizationOnView()
        
        showDatePickerInTextFileld()
        
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return UIStatusBarStyle.default
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        registerFromKeyboardNotification()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        disappearRegisterFromKeyboardNotification()
        
    }
    
    private func registerFromKeyboardNotification(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShow(notification:)), name: UIView.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasHidden(notification:)), name: UIView.keyboardWillHideNotification, object: nil)
        
        
    }
    
    private func disappearRegisterFromKeyboardNotification(){
        
        NotificationCenter.default.removeObserver(self, name: UIView.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIView.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc private func keyboardWasShow(notification : NSNotification){
        
        view.addSubview(touchView)
        
    }
    
    @objc private func keyboardWasHidden(notification : NSNotification){
        
        touchView.removeFromSuperview()
        
    }
    
    @objc private func dismissKeyboard(){
        
        view.endEditing(true)
        
    }
    
    private func addLcalizationOnView(){
        
        titleLabel.text = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "TITLE_OF_SIGNUP_PAGE")
        
        let firstName = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "FIRST_NAME")
        firstNameTextField.attributedPlaceholder = NSAttributedString(string:firstName ,attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "SignUp_TextFieldFont_Color")!])
        
        let lastName = languageLocalization.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "LAST_NAME")
        lastNameTextField.attributedPlaceholder = NSAttributedString(string:lastName ,attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "SignUp_TextFieldFont_Color")!])
        
        let email = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "EMAIL")
        emailTextField.attributedPlaceholder = NSAttributedString(string:email ,attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "SignUp_TextFieldFont_Color")!])
        
        let dob = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "DATE_OF_BIRTH")
        dobTextField.attributedPlaceholder = NSAttributedString(string: dob,attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "SignUp_TextFieldFont_Color")!])
        
        let country = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "COUNTRY")
        countryTextField.attributedPlaceholder = NSAttributedString(string: country,attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "SignUp_TextFieldFont_Color")!])
        
        let password = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "PASSWORD")
        passwordTextField.attributedPlaceholder = NSAttributedString(string: password,attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "SignUp_TextFieldFont_Color")!])
        
        let retypePassword = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "RETYPE_PASSWORD")
        retypePasswordTextField.attributedPlaceholder = NSAttributedString(string: retypePassword,attributes: [NSAttributedString.Key.foregroundColor: UIColor(named:"SignUp_TextFieldFont_Color")!])
        
        signUpButton.setTitle(LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "SIGNUP_BUTTON"), for: .normal)
    }
    
    @IBAction func backButtonDidTouch(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func signUpButtonDidTouch(_ sender: Any) {
        
        guard let firstName = firstNameTextField.text else { return }
        
        guard let lastName = lastNameTextField.text else { return }
        
        guard let email = emailTextField.text else { return }
        
        guard let doBirth = dobTextField.text else { return }
        
        guard let country = countryTextField.text else { return }
        
        guard let password = passwordTextField.text else { return  }
        
        guard let reTypePassword = retypePasswordTextField.text else { return }
        
        if firstName.isEmpty{
            
            let errorMessage = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "EMPTY_FIRSTNAME_FIELD")
            
            addErrorMessage(errorMessage)
            
        } else if lastName.isEmpty {
            
            let errorMessage = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "EMPTY_LASTNAME_FIELD")
            
            addErrorMessage(errorMessage)
            
        } else if email.isEmpty {
            
            let errorMessage = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "EMPTY_EMAIL_FIELD")
            
            addErrorMessage(errorMessage)
            
        } else if doBirth.isEmpty {
            
            let errorMessage = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "EMPTY_BIRTHDAY_FIELD")
            
            addErrorMessage(errorMessage)
            
        } else if country.isEmpty {
            
            let errorMessage = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "EMPTY_COUNTRY_FIELD")
            
            addErrorMessage(errorMessage)
            
        } else if password.isEmpty {
            
            let errorMessage = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "EMPTY_PASSWORD_FIELD")
            
            addErrorMessage(errorMessage)
            
        } else if reTypePassword.isEmpty {
            
            let errorMessage = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "EMPTY_RETYPEPASSWORD_FIELD")
            
            addErrorMessage(errorMessage)
            
        } else if password.elementsEqual(reTypePassword) {
            
            Auth.auth().createUser(withEmail: email, password: reTypePassword) { [weak self] (result, error) in
                
                guard let strongSelf = self else { return }
                
                if error == nil {
                    
                    guard let userId = result?.user.uid else { return }
                    
                    Auth.auth().signIn(withEmail: email, password: reTypePassword) { (signInResult, error) in
                        
                        if error == nil{
                            
                            let userReference = Database.database().reference().child("Profile").child(userId)
                            
                            userReference.updateChildValues([
                                "first_Name" : firstName,
                                "last_Name" : lastName,
                                "dateOfBirth" : doBirth,
                                "Country" : country
                            ])
                            
                            DispatchQueue.main.async {
                                
                                let homeStoryboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "HomePage") as! HomeViewController
                                
                                homeStoryboard.localizeResouce = strongSelf.languageResouce
                                
                                strongSelf.present(homeStoryboard, animated: true, completion: nil)
                            }
                            
                            
                        } else if let signInError = error{
                            
                            strongSelf.firebaseErrorCode(signInError, strongSelf)
                            
                        }
                    }
                    
                } else if let createUserError = error {
                    
                    strongSelf.firebaseErrorCode(createUserError, strongSelf)
                    
                }
                
            }
            
        } else {
            
            let errorMessage = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "PASSWORD_NOT_MATCH")
            
            addErrorMessage(errorMessage)
            
        }
    }
    
    private func firebaseErrorCode(_ error : Error,_ strongeSelf : SignUpViewController ){
        
        var errorTitle : String = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: strongeSelf.languageResouce, identification: "SIGNUP_ERROR_TITLE")
        
        var errorMessage : String = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: strongeSelf.languageResouce, identification: "SIGNUP_ERROR_MESSAGE")
        
        if let errorCode = AuthErrorCode(rawValue: error._code) {
            
            switch errorCode {
                
            case .invalidEmail:
                
                errorTitle = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: strongeSelf.languageResouce, identification: "SIGNIN_INVALID_EMAIL")
                
                errorMessage = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: strongeSelf.languageResouce, identification: "SIGNIN_INVALIDEMAIL_MESSAGE")
                
            case .wrongPassword:
            
                errorTitle = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: strongeSelf.languageResouce, identification: "SIGNIN_WRONG_PASSWORD")
            
                errorMessage = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: strongeSelf.languageResouce, identification: "SIGNIN_WRONGPASSWORD_MESSAGE")
                
            case .emailAlreadyInUse:
                
                errorTitle = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: strongeSelf.languageResouce, identification: "SIGNUP_ALREADY_EMAIL")
                
                errorMessage = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: strongeSelf.languageResouce, identification: "SIGNUP_ALREADYEMAIL_MESSAGE")
                
            case .weakPassword:
                
                errorTitle = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: strongeSelf.languageResouce, identification: "SIGNUP_WEAK_PASSWORD")
                
                errorMessage = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: strongeSelf.languageResouce, identification: "SIGNUP_WEAKPASSWORD_MESSAGE")
            
            default:
                
                break
            }
            
        }
        
        let actionType : String = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: strongeSelf.languageResouce, identification: "OK_ALERT")
        
        let alert = Validation.errorAlert(errorTitle, errorMessage, actionType)
        
        DispatchQueue.main.async {
            
            strongeSelf.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    
    private func addErrorMessage(_ errorMessage : String ){
        
        let errorTitle = languageLocalization.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "WARNING")
        
        let actionName = languageLocalization.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "OK_ALERT")
        
        let errorAlert = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: actionName, style: .default) { (action) in
            
            errorAlert.dismiss(animated: true, completion: nil)
            
        }
        
        errorAlert.addAction(okAction)
        
        present(errorAlert, animated: true, completion: nil)
    }
    
    private func showDatePickerInTextFileld(){
        
        toolBar.sizeToFit()
        
        //create a Bar Button Item and adding to the tool bar.
        
        let doneBarButtonTitle = languageLocalization.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "DONE_BARBUTTON_ITEM")
        
        let cancelBarButtonTitle = languageLocalization.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "CANCEL_BARBUTTON_ITEM")
        
        let cancelBarButton = UIBarButtonItem(title: cancelBarButtonTitle, style: .plain, target: nil, action: #selector(dismissPickerView))
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneBarButton = UIBarButtonItem(title: doneBarButtonTitle, style: .done, target: nil, action: #selector(donePressed))
        
        toolBar.setItems([cancelBarButton,flexibleSpace,doneBarButton], animated: true)
        
        //Tool bar adding to the dobTextField
        
        dobTextField.inputAccessoryView = toolBar
        
        //Date picker adding to the dobTextField
        
        datePicker.datePickerMode = .date
        
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        
        dobTextField.inputView = datePicker
        
    }
    
    @objc private func dismissPickerView(){
        
        datePicker.removeFromSuperview()
        
        toolBar.removeFromSuperview()
        
    }
    
    @objc private func donePressed(){
        
        let formatter = DateFormatter()
        
        formatter.dateStyle = .medium
        
        formatter.timeStyle = .none
        
        dobTextField.text = formatter.string(from: datePicker.date)
        
        datePicker.removeFromSuperview()
        
        toolBar.removeFromSuperview()
    }
}
