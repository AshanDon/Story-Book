//
//  LoginViewController.swift
//  Story Book
//
//  Created by Ashan Anuruddika on 6/4/20.
//  Copyright © 2020 Ashan. All rights reserved.
//

import UIKit

import FirebaseAuth

class LoginViewController: UIViewController {
    

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var languageSegment: UISegmentedControl!
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var socialMediaTitleLabel: UILabel!
    @IBOutlet weak var orLabel: UILabel!
    
    
    private var activeTextField : UITextField?
    private var languageResouce : String = Constant.LanguageResouce.english
    private let validationController = Validation()
    
    // Creating to the TouchView
    lazy var touchView : UIView = {
        
        let _touchView = UIView()
        
        _touchView.backgroundColor = UIColor(displayP3Red: 0.1, green: 0.1, blue: 0.1, alpha: 0)
        
        _touchView.isUserInteractionEnabled = true
        
        _touchView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        _touchView.addGestureRecognizer(tapGestureRecognizer)
        
        return _touchView
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //make editing for languageSegment
        languageSegment.layer.cornerRadius = 15
        languageSegment.layer.borderColor = UIColor(named: "Segment_Border_Color")!.cgColor
        languageSegment.layer.borderWidth = 1
        languageSegment.layer.masksToBounds = false
        
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "Segment_Font_Color")!]
        let selectedTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "Segment_SelectedFont_Color")!]
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributes, for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes(selectedTextAttributes, for: .selected)
        
        //make editing for TextField
        userNameTextField.layer.cornerRadius = 15
        userNameTextField.layer.borderWidth = 2
        userNameTextField.layer.borderColor = UIColor(named: "LoginView_TextFieldBorder_Color")!.cgColor
        
        
        passwordTextField.layer.cornerRadius = 15
        passwordTextField.layer.borderWidth = 2
        passwordTextField.layer.borderColor = UIColor(named: "LoginView_TextFieldBorder_Color")!.cgColor
        
        //make editing for UIButton
        signInButton.layer.cornerRadius = 15
        signInButton.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        signInButton.layer.borderWidth = 2
        
        signUpButton.layer.cornerRadius = 15
        signUpButton.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        signUpButton.layer.borderWidth = 2
       
        activeTextField?.delegate = self
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        
        setLanguageLocalization()
        
    }
    //Mark :- Maintaining TextField when keyboard show and hidden
    
    //Adding to that Observing keyboard event
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        registerFromKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        disappearRegisterFromKeybordNotification()
    }
    
    
    private func registerFromKeyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShow(notification:)), name: UIWindow.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasHidden(notification:)), name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    
    private func disappearRegisterFromKeybordNotification(){
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWasShow(notification : NSNotification){
        view.addSubview(touchView)
        
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInset : UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize!.height, right: 0)
        self.scrollView.contentInset = contentInset
        self.scrollView.scrollIndicatorInsets = contentInset

        var aRec : CGRect = UIScreen.main.bounds
        aRec.size.height -= keyboardSize!.height

        if activeTextField != nil {
            if !aRec.contains(activeTextField!.frame.origin) {
                self.scrollView.scrollRectToVisible(activeTextField!.frame, animated: true)
            }
        }
    }
    
    
    @objc private func keyboardWasHidden(notification : NSNotification){
        touchView.removeFromSuperview()
        
        let contentInsetr : UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInsetr
        self.scrollView.scrollIndicatorInsets = contentInsetr
        self.view.endEditing(true)
    }
    
    @objc private func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    
    @IBAction func loginDetailPressed(_ sender: UIButton) {
        
        if sender.currentTitle! == "SignIn" || sender.currentTitle! == "පිවිසී​ම"{
            
            guard let email = userNameTextField.text else { return }
            
            guard let password = passwordTextField.text else { return }
            
            if email.isEmpty {
                
                addErrorAlert(errorMessage: "EMPTY_USERNAME_TEXT_FIELD")
                
            } else if password.isEmpty {
                
                addErrorAlert(errorMessage: "EMPTY_PASSWORD_TEXT_FIELD")
                
            } else {
                
                signInFromFirebaseAuth(email, password)
                
            }
            
            
            
        } else {
            performSegue(withIdentifier: Constant.Segue.signInToSignUp, sender: self.languageResouce)
        }
    }
    
    private func setLanguageLocalization(){
        
        socialMediaTitleLabel.text = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: self.languageResouce, identification: "SOCIAL_MEDIA_TITLE")
        
        orLabel.text = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: self.languageResouce, identification: "ORLABEL")
        
        userNameTextField.attributedPlaceholder = NSAttributedString(string: LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: self.languageResouce, identification: "USER_NAME_OR_EMAIL"),attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "Main_Font_Color")!])
        
        passwordTextField.attributedPlaceholder = NSAttributedString(string: LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: self.languageResouce, identification: "PASSWORD"),attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "Main_Font_Color")!])
        
        signInButton.setTitle(LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: self.languageResouce, identification: "SIGNINBUTTON"), for: .normal)
        
        signUpButton.setTitle(LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: self.languageResouce, identification: "SIGNUPBUTTON"), for: .normal)
        
    }
    
    @IBAction func didChangeLanguage(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            languageResouce = Constant.LanguageResouce.english
            setLanguageLocalization()
            
        } else {
            languageResouce = Constant.LanguageResouce.sinhala
            setLanguageLocalization()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
            
        case Constant.Segue.signInToSignUp:
            
            guard let destinationSignUp = segue.destination as? SignUpViewController else { return }
            
            guard let senderValues = sender as? String else { return }
            
            destinationSignUp.languageResouce = senderValues
            
            break
            
        case Constant.Segue.loginToHome:
            
            guard let homeDestination = segue.destination as? HomeViewController else {return }
            
            guard let sendValue = sender as? String else {return }
            
            homeDestination.localizeResouce = sendValue
            
            break
            
        default:
            break
        }
        
    }
    
    private func addErrorAlert(errorMessage : String){
        
        let alert = UIAlertController(title: LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "WARNING"), message: LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: errorMessage), preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "OK_ALERT"), style: .default) { (action) in
            
            alert.dismiss(animated: true, completion: nil)
            
        }
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func signInFromFirebaseAuth(_ email : String, _ password : String) {
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error) in
            
            guard let strongeSelf = self else { return }
            
            if error == nil {
                
                DispatchQueue.main.async {
                    
                    strongeSelf.performSegue(withIdentifier: Constant.Segue.loginToHome, sender: strongeSelf.languageResouce)
                    
                }
                
            } else if let error = error {
                
                var errorTitle : String = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: strongeSelf.languageResouce, identification: "SIGNIN_ERROR_TITLE")
                
                var errorMessage : String = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: strongeSelf.languageResouce, identification: "SIGNIN_ERROR_MESSAGE")
                
                if let errorCode = AuthErrorCode(rawValue: error._code){
                    
                    switch errorCode {
                        
                    case .invalidEmail :
                        
                        errorTitle = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: strongeSelf.languageResouce, identification: "SIGNIN_INVALID_EMAIL")
                        
                        errorMessage = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: strongeSelf.languageResouce, identification: "SIGNIN_INVALIDEMAIL_MESSAGE")
                        
                    case .wrongPassword :
                    
                        errorTitle = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: strongeSelf.languageResouce, identification: "SIGNIN_WRONG_PASSWORD")
                    
                        errorMessage = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: strongeSelf.languageResouce, identification: "SIGNIN_WRONGPASSWORD_MESSAGE")
                        
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
        }
    }
}

//Mark :- UITextFieldDelegate
extension LoginViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeTextField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}

