//
//  VideoListViewController.swift
//  ELDMandateTask
//
//  Created by Vineet Singh on 10/07/20.
//  Copyright © 2020 ELDMandate. All rights reserved.
//

import UIKit

class VideoListViewController: UIViewController{

    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var calendarBtn: UIButton!
    
    @IBOutlet weak var videoListCollectionView: UICollectionView!
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    var videoFiles = [VideoFilesData]()
    
    static var totalFetchedVideos: Int = 0
    static var limit: Int = 6
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoListCollectionView.delegate = self
        videoListCollectionView.dataSource = self
        
        videoListCollectionView.register(UINib(nibName: "VideoDetailsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "VideoDetailsCollectionViewCell")
        
        callVideoData(isFirstCall: true)

        activityView.hidesWhenStopped = true
        
    }
    
    class func getMorePage(){
        totalFetchedVideos += limit
    }

    @IBAction func searchBtnTapped(_ sender: Any) {
        
    }
    
    @IBAction func calendarBtnTapped(_ sender: Any) {
        
    }
    
    func callVideoData(isFirstCall: Bool){
        
        let url = Service.baseurl.rawValue + "?offset=\(VideoListViewController.totalFetchedVideos)&limit=6"
        
        activityView.startAnimating()
        
        NetworkManager.sharedInstance.apiGetCall(api: url, method: .get, parameters: nil) { (data, error) in
            
            if let error = error{
                
                self.activityView.stopAnimating()
                
                print(error)
                return
            }
            
            if let data = data as? [[String:Any]]{
                
                self.activityView.stopAnimating()
                
                let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                
                if let files = try? JSONDecoder().decode([VideoFilesData].self, from: jsonData as! Data){
                    
                    self.videoFiles.append(contentsOf: files)
                    
                    if isFirstCall{
                        VideoListViewController.getMorePage()
                    }
                    
                    DispatchQueue.main.async {
                        self.videoListCollectionView.reloadData()
                    }
                }
                
                
            }
            
        }
        
    }
    
}

extension VideoListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return videoFiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoDetailsCollectionViewCell", for: indexPath) as! VideoDetailsCollectionViewCell
        
        cell.videoThumbnailImg.image = nil
            
        let videoDetails = videoFiles[indexPath.row]
            
        cell.setupCell(videoData: videoDetails)
        
        if indexPath.row == (VideoListViewController.totalFetchedVideos - 2){
            
            VideoListViewController.getMorePage()
            callVideoData(isFirstCall: false)
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = ((UIScreen.main.bounds.width-32) / 2)

        return CGSize(width: width, height: 200)

    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
}
