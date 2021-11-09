//
//  AddViewController.swift
//  RankingApp
//
//  Created by 小野翼 on 2020/03/13.
//  Copyright © 2020 TsubasaOno. All rights reserved.
//

import UIKit
import NCMB

class AddViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet var questionTextView: UITextView!
    @IBOutlet var question1TextField: UITextField!
    @IBOutlet var question2TextField: UITextField!
    @IBOutlet var question3TextField: UITextField!
    @IBOutlet var question4TextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        questionTextView.delegate = self
        question1TextField.delegate = self
        question2TextField.delegate = self
        question3TextField.delegate = self
        question4TextField.delegate = self
    }
    
    
    @IBAction func save() {
        if question1TextField.text!.count <= 15 && question2TextField.text!.count <= 15 && question3TextField.text!.count <= 15 && question4TextField.text!.count <= 15 && questionTextView.text.count <= 100 {
            
            if question1TextField.text?.count != 0 && question2TextField.text?.count != 0 && question3TextField.text?.count != 0 && question4TextField.text?.count != 0 && questionTextView.text.count != 0 {
                
                let userObjectId = NCMBUser.current()?.objectId
                let user = NCMBUser.current()
                
                let object = NCMBObject(className: "Question")
                object?.setObject(questionTextView.text, forKey: "question")
                object?.setObject(question1TextField.text, forKey: "question1")
                object?.setObject(question2TextField.text, forKey: "question2")
                object?.setObject(question3TextField.text, forKey: "question3")
                object?.setObject(question4TextField.text, forKey: "question4")
                object?.setObject(NCMBUser.current(), forKey: "userObjectId")
                object?.setObject(user?.userName, forKey: "authorUser")
                object?.setObject(0, forKey: "number1")
                object?.setObject(0, forKey: "number2")
                object?.setObject(0, forKey: "number3")
                object?.setObject(0, forKey: "number4")
                object?.saveInBackground({ (error) in
                    if error != nil {
                        print(error)
                    } else {
                        let alertController = UIAlertController(title: "作成完了", message:"質問を作成しました。タイムラインに戻ります。" , preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .default) { (action) in
                            self.navigationController?.popViewController(animated: true)
                        }
                        alertController.addAction(action)
                        self.present(alertController, animated: true, completion: nil)
                        
                    }
                })
            } else {
                let alert = UIAlertController(title: "注意", message: "入力されていない項目があります。", preferredStyle: .alert)
                let action2 = UIAlertAction(title: "OK", style: .default) { (action2) in
                    print("入力されていない項目があります。")
                    alert.dismiss(animated: true, completion: nil)
                }
                alert.addAction(action2)
                self.present(alert, animated: true, completion: nil)
                
            }

        } else {
            let alert3 = UIAlertController(title: "注意", message: "文字数が多いです。", preferredStyle: .alert)
            let action3 = UIAlertAction(title: "OK", style: .default) { (action3) in
                print("文字数が多いです")
                alert3.dismiss(animated: true, completion: nil)
            }
            alert3.addAction(action3)
            self.present(alert3, animated: true, completion: nil)
        }


    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
}
