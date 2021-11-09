//
//  TimelineViewController.swift
//  RankingApp
//
//  Created by 小野翼 on 2020/03/13.
//  Copyright © 2020 TsubasaOno. All rights reserved.
//

import UIKit
import NCMB


class TimelineViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var rankingArray = [NCMBObject]()
    @IBOutlet var timelineCollectionView: UICollectionView!
    @IBOutlet var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timelineCollectionView.dataSource = self
        timelineCollectionView.delegate = self
        
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        self.navigationController?.navigationBar.barTintColor = UIColor.yellow
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        timelineCollectionView.collectionViewLayout = layout
        
        self.timelineCollectionView.backgroundView = imageView
        
        loadData()
        setRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
        setRefreshControl()
    }
    
    func setRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadTimeline(refreshControl:)), for: .valueChanged)
        timelineCollectionView.addSubview(refreshControl)
    }
    @objc func reloadTimeline(refreshControl: UIRefreshControl) {
        loadData()
        // 更新が早すぎるので2秒遅延させる
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            refreshControl.endRefreshing()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if rankingArray == nil{
            return 0
        } else {
            return rankingArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! TimelineCollectionViewCell
        cell.questionLabel.numberOfLines = 0
        cell.questionLabel?.text = rankingArray[indexPath.row].object(forKey: "question") as? String
        
        cell.layer.shadowOpacity = 0.4
        cell.layer.shadowRadius = 5
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 8, height: 8)
        cell.layer.masksToBounds = false
        
        return cell 
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toDetail", sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = 380
        let height = 190
        return CGSize(width: width, height: height)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //次の画面の取得(Detail)
        if segue.identifier == "toDetail" {
            let detailViewController = segue.destination as! DetailViewController
            let selectedIndex = timelineCollectionView.indexPathsForSelectedItems?.first
            detailViewController.selectedQuestion = rankingArray[selectedIndex!.row]
        }
    }
    
    func loadData() {
        let query = NCMBQuery(className: "Question")
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                print(error)
            } else {
                self.rankingArray = result as! [NCMBObject]
                self.timelineCollectionView.reloadData()
            }
        })
        //カスタムセルの登録
        let nib = UINib(nibName: "TimelineCollectionViewCell", bundle: Bundle.main)
        self.timelineCollectionView.register(nib, forCellWithReuseIdentifier: "Cell")
        self.timelineCollectionView.reloadData()
    }
}


