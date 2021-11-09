//
//  DetailViewController.swift
//  RankingApp
//
//  Created by 小野翼 on 2020/03/13.
//  Copyright © 2020 TsubasaOno. All rights reserved.
//

import UIKit
import NCMB

class DetailViewController: UIViewController {
    
    var voteArray: [String] = []
    
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var authorImageView: UIImageView!
    
    var selectedQuestion: NCMBObject!
    var questionArray: String!
    var number1: Int!
    var number2: Int!
    var number3: Int!
    var number4: Int!
    
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var question1Label: UILabel!
    @IBOutlet var question2Label: UILabel!
    @IBOutlet var question3Label: UILabel!
    @IBOutlet var question4Label: UILabel!
    
    @IBOutlet var number1Label: UILabel!
    @IBOutlet var number2Label: UILabel!
    @IBOutlet var number3Label: UILabel!
    @IBOutlet var number4Label: UILabel!
    
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    @IBOutlet var button4: UIButton!
    
//    @IBOutlet var RankingNumber1: String!
//    @IBOutlet var RankingNumber2: String!
//    @IBOutlet var RankingNumber3: String!
//    @IBOutlet var RankingNumber4: String!
    
    
    let userName = NCMBUser.current()?.userName
    

//    @IBOutlet var detailTableView: UITableView!
    
    let ud = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        questionLabel.text = selectedQuestion.object(forKey: "question") as? String
        let flag = ud.bool(forKey: questionLabel.text!)
        print(flag)
        
        if flag == false{
            button1.isHidden = false
            button2.isHidden = false
            button3.isHidden = false
            button4.isHidden = false
            self.number1Label.isHidden = true
            self.number2Label.isHidden = true
            self.number3Label.isHidden = true
            self.number4Label.isHidden = true
        }else{
            //                    そうじゃなかったら有効化
            button1.isHidden = true
            button2.isHidden = true
            button3.isHidden = true
            button4.isHidden = true
            self.number1Label.isHidden = false
            self.number2Label.isHidden = false
            self.number3Label.isHidden = false
            self.number4Label.isHidden = false
        }
        
        //表示可能最大行数を指定
        questionLabel.numberOfLines = 10
        //contentsのサイズに合わせてobujectのサイズを変える
        questionLabel.sizeToFit()
        //単語の途中で改行されないようにする
        questionLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        
      
        shadow(button: button1)
        shadow(button: button2)
        shadow(button: button3)
        shadow(button: button4)
    
        
        question1Label.text = selectedQuestion.object(forKey: "question1") as? String
        question2Label.text = selectedQuestion.object(forKey: "question2") as? String
        question3Label.text = selectedQuestion.object(forKey: "question3") as? String
        question4Label.text = selectedQuestion.object(forKey: "question4") as? String
        number1 = selectedQuestion.object(forKey: "number1") as? Int
        number2 = selectedQuestion.object(forKey: "number2") as? Int
        number3 = selectedQuestion.object(forKey: "number3") as? Int
        number4 = selectedQuestion.object(forKey: "number4") as? Int
        number1Label.text = String(number1)
        number2Label.text = String(number2)
        number3Label.text = String(number3)
        number4Label.text = String(number4)
        
        loadData()

    }
    
    @IBAction func report() {
        let alertController = UIAlertController(title: "メニュー", message: "メニューを選択してください。", preferredStyle: .actionSheet)
        let blockAction = UIAlertAction(title: "投稿者をブロックする", style: .default) { (action) in
            //投稿者をブロックリストに入れる
            //ブロックしましたのアラートを出す
            
        }
        let reportAction = UIAlertAction(title: "この投稿を報告する", style: .default) { (action) in
            //この投稿をNCMBのreportに入れる
            let object = NCMBObject(className: "Report")
            object?.setObject(self.selectedQuestion, forKey: "report")
            object?.saveInBackground({ (error) in
                if error != nil {
                    print(error)
                } else {
                    let alertController = UIAlertController(title: "報告", message:"この投稿を報告しました。" , preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default) { (action) in
                        self.navigationController?.popViewController(animated: true)
                    }
                    alertController.addAction(action)
                    self.present(alertController, animated: true, completion: nil)
                }
            })
        }
        
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(blockAction)
        alertController.addAction(reportAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    

    
    //touchupInsideで関連づけ
    @IBAction func touchUp() {
    }
    
    @IBAction func touchDown() {
        button1.layer.shadowOpacity = 0.4
        button1.layer.shadowRadius = 5
        button1.layer.shadowColor = UIColor.black.cgColor
        button1.layer.shadowOffset = CGSize(width: 8, height: 8)
        button1.layer.masksToBounds = false
    }
    
    @IBAction func vote1() {
        //投票したobjectIdを会員管理に保存する
        let votedObjectId1 = selectedQuestion.object(forKey: "objectId") as? String
        let user = NCMBUser.current()
        user?.addObjects(from: [votedObjectId1!], forKey: "votedObjectId")
        user?.saveInBackground({ (error) in
            if error != nil {
                print(error)
            } else {
                print("success")
            }
        })
        //投票数を一増やす
        number1 = number1 + 1
        selectedQuestion.setObject(number1, forKey: "number1")
        selectedQuestion.saveInBackground { (error) in
            if error != nil {
                print(error)
            } else {
                self.number1Label.text = self.selectedQuestion.object(forKey: "number1") as? String
                self.ud.set(true, forKey: self.questionLabel.text!)
                self.viewDidLoad()
            }
        }
    }
    
    @IBAction func vote2() {
        //押された時に押された質問のobjectIdを投票した質問を集めた配列に代入できるようにする。
        let votedObjectId2 = selectedQuestion.object(forKey: "objectId") as? String
        let user = NCMBUser.current()
        user?.addObjects(from: [votedObjectId2!], forKey: "votedObjectId")
        user?.saveInBackground({ (error) in
            if error != nil {
                print(error)
            } else {
                print("success")
            }
        })
            
        number2 = number2 + 1
        selectedQuestion.setObject(number2, forKey: "number2")
        selectedQuestion.saveInBackground { (error) in
            if error != nil {
                print(error)
            } else {
                self.number2Label.text = self.selectedQuestion.object(forKey: "number2") as? String
                self.ud.set(true, forKey: self.questionLabel.text!)
                self.viewDidLoad()
            }
        }
    }
    
    @IBAction func vote3() {
        //押された時に押された質問のobjectIdを投票した質問を集めた配列に代入できるようにする。
        let votedObjectId3 = selectedQuestion.object(forKey: "objectId") as? String
        let user = NCMBUser.current()
        user?.addObjects(from: [votedObjectId3!], forKey: "votedObjectId")
        user?.saveInBackground({ (error) in
            if error != nil {
                print(error)
            } else {
                print("success")
            }
        })
            
        number3 = number3 + 1
        selectedQuestion.setObject(number3, forKey: "number3")
        selectedQuestion.saveInBackground { (error) in
            if error != nil {
                print(error)
            } else {
                self.number3Label.text = self.selectedQuestion.object(forKey: "number3") as? String
                self.ud.set(true, forKey: self.questionLabel.text!)
                self.viewDidLoad()
            }
        }
    }
    
    @IBAction func vote4() {
        //押された時に押された質問のobjectIdを投票した質問を集めた配列に代入できるようにする。
    let votedObjectId4 = selectedQuestion.object(forKey: "objectId") as? String
    let user = NCMBUser.current()
    user?.addObjects(from: [votedObjectId4!], forKey: "votedObjectId")
    user?.saveInBackground({ (error) in
        if error != nil {
            print(error)
        } else {
            print("success")
        }
    })
        
        number4 = number4 + 1
        selectedQuestion.setObject(number4, forKey: "number4")
        selectedQuestion.saveInBackground { (error) in
            if error != nil {
                print(error)
            } else {
                self.number4Label.text = self.selectedQuestion.object(forKey: "number4") as? String
                self.ud.set(true, forKey: self.questionLabel.text!)
                self.viewDidLoad()
            }
        }
    }
    
    
    @IBAction func ranking() {
//        var rankingNumber: Int!
//        var numberArray:[Int]!
        let rankingDict: Dictionary<String, Int> = ["number1":number1, "number2":number2, "number3":number3, "number4":number4]
        let rankingTupleArray = rankingDict.sorted{ $0.value > $1.value }
        print(rankingTupleArray)
//        numberArray.append(number1)
//        numberArray.append(number2)
//        numberArray.append(number3)
//        numberArray.append(number4)
//        for i in numberArray {
//            var num1: Int = 0
//            var num2: Int = 0
//            var num3: Int = 0
//            var num4: Int = 0
//
//            if numberArray[0] <= numberArray[i] {
//                num1 = num1 + 1
//            }
//            if numberArray[1] <= numberArray[i] {
//                num2 = num2 + 1
//            }
//            if numberArray[2] <= numberArray[i] {
//                num3 = num3 + 1
//            }
//            if numberArray[3] <= numberArray[i] {
//                num4 = num4 + 1
//            }
//
//        }
    }
    
    func loadData() {
            userNameLabel.text = selectedQuestion.object(forKey: "authorUser") as! String
            
            let file = NCMBFile.file(withName: userNameLabel.text, data: nil) as! NCMBFile
            file.getDataInBackground { (data, error) in
                if error != nil {
                    print(error)
                } else {
                    if data != nil {
                        let image = UIImage(data: data!)
                        self.authorImageView.image = image
                    }
                    
                }
            }
    }
    
    func shadow(button: UIButton) {
        button.layer.shadowOpacity = 0.4
        button.layer.shadowRadius = 5
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 8, height: 8)
        button.layer.masksToBounds = false
        
    }

}
