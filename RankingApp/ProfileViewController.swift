//
//  ProfileViewController.swift
//  RankingApp
//
//  Created by 小野翼 on 2020/04/28.
//  Copyright © 2020 TsubasaOno. All rights reserved.
//

import UIKit
import NCMB

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UITabBarDelegate {
    
    
    var addArray = [NCMBObject]()
    var voteArray = [NCMBObject]()
    var vArray = [String]()
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userNameLabel:UILabel!
    @IBOutlet var addCollectionView: UICollectionView!
    @IBOutlet var voteCollectionView: UICollectionView!
    @IBOutlet var tabBar: UITabBar!
    var tag:Int!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        self.navigationController?.navigationBar.barTintColor = UIColor.yellow
        
        addCollectionView.isHidden = false
        voteCollectionView.isHidden = true
        
        addCollectionView.dataSource = self
        addCollectionView.delegate = self
        voteCollectionView.dataSource = self
        voteCollectionView.delegate = self
        tabBar.delegate = self
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        addCollectionView.collectionViewLayout = layout
        
        let layout2 = UICollectionViewFlowLayout()
        layout2.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        voteCollectionView.collectionViewLayout = layout2
        
        loadData()
        //refresh
        
        userImageView.layer.cornerRadius = userImageView.bounds.width / 2.0
        userImageView.layer.masksToBounds = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let user = NCMBUser.current() {
            
            userNameLabel.text = user.userName
            
            let file = NCMBFile.file(withName: user.objectId, data: nil) as! NCMBFile
            file.getDataInBackground { (data, error) in
                if error != nil {
                    print(error)
                } else {
                    if data != nil {
                        let image = UIImage(data: data!)
                        self.userImageView.image = image
                    }
                    
                }
            }
        } else {
            //NCMBUser.current()がnilだった時
            let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
            let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
            UIApplication.shared.keyWindow?.rootViewController = rootViewController
            
            //ログイン状態の保持
            let ud = UserDefaults.standard
            ud.set(false, forKey: "isLogin")
            ud.synchronize()
        }
        
        loadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1 {
            if addArray.count == 0 {
                return 0
            } else {
                return addArray.count
            }
            
        } else if collectionView.tag == 2 {
            if voteArray.count == 0 {
                return 0
            } else {
                return voteArray.count
            }
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 1 {
            let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell2", for: indexPath) as! UserAddCollectionViewCell
            cell2.userAddNameLabel.numberOfLines = 0
            cell2.userAddNameLabel?.text = addArray[indexPath.row].object(forKey: "question") as? String
            return cell2
        } else {
            let cell3 = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell3", for: indexPath) as! UserVoteCollectionViewCell
            cell3.userVoteNamelabel.numberOfLines = 0
            cell3.userVoteNamelabel.text = voteArray[indexPath.row].object(forKey: "question") as? String
            return cell3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        tag = collectionView.tag
        self.performSegue(withIdentifier: "toDetail2", sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = 380
        let height = 190
        return CGSize(width: width, height: height)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //次の画面の取得(Detail)
        if segue.identifier == "toDetail2" {
            let detailViewController = segue.destination as! DetailViewController

            if tag == 1 {
                 let selectedIndex = addCollectionView.indexPathsForSelectedItems?.first
                detailViewController.selectedQuestion = addArray[selectedIndex!.row]
            } else {
                let selectedIndex2 = voteCollectionView.indexPathsForSelectedItems?.first
                detailViewController.selectedQuestion = voteArray[selectedIndex2!.row]
            }
            
        }
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        switch item.tag {
        case 1:
            addCollectionView.isHidden = false
            voteCollectionView.isHidden = true
        case 2:
            addCollectionView.isHidden = true
            voteCollectionView.isHidden = false
        default:
            return
        }
    }
    
    func loadData() {
        let nib2 = UINib(nibName: "UserAddCollectionViewCell", bundle: Bundle.main)
        self.addCollectionView.register(nib2, forCellWithReuseIdentifier: "Cell2")
        
        let nib3 = UINib(nibName: "UserVoteCollectionViewCell", bundle: Bundle.main)
        self.voteCollectionView.register(nib3, forCellWithReuseIdentifier: "Cell3")
        
        let query = NCMBQuery(className: "Question")
        let objectIdOfUser = NCMBUser.current()?.objectId
        query?.whereKey("userObjectId", equalTo: objectIdOfUser)
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                print(error)
            } else {
                self.addArray = result as! [NCMBObject]
                self.addCollectionView.reloadData()
            }
        })
        
        
        let user = NCMBUser.current()
        let query2 = NCMBQuery(className: "Question")
        if user?.object(forKey: "votedObjectId") == nil {
            print("nothing")
        } else {
            vArray = user?.object(forKey: "votedObjectId") as! [String]
            query2?.whereKey("objectId", containedIn: vArray)
            query2?.findObjectsInBackground({ (result, error) in
                if error != nil {
                    print(error)
                } else {
                    self.voteArray = result as! [NCMBObject]
                    self.voteCollectionView.reloadData()
                }
            })
        }
        
    }
    
    
    
    
    
    @IBAction func showMenu() {
        let alertController = UIAlertController(title: "メニュー", message: "メニューを選択してください。", preferredStyle: .actionSheet)
        let signOutAction = UIAlertAction(title: "ログアウト", style: .default) { (action) in
            NCMBUser.logOutInBackground({ (error) in
                if error != nil {
                    print(error)
                } else {
                    //ログアウト成功
                    let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
                    let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
                    UIApplication.shared.keyWindow?.rootViewController = rootViewController
                    
                    //ログイン状態の保持
                    let ud = UserDefaults.standard
                    ud.set(false, forKey: "isLogin")
                    ud.synchronize()
                    
                }
            })
        }
        let deleteAction = UIAlertAction(title: "退会", style: .default) { (action) in
            let user = NCMBUser.current()
            user?.deleteInBackground({ (error) in
                if error != nil {
                    print(error)
                } else {
                    
                    //ログアウト成功
                    let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
                    let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
                    UIApplication.shared.keyWindow?.rootViewController = rootViewController
                    
                    //ログイン状態の保持
                    let ud = UserDefaults.standard
                    ud.set(false, forKey: "isLogin")
                    ud.synchronize()
                }
            })
        }
        
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(signOutAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }

}
