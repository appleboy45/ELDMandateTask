//
//  VideoDetailsCollectionViewCell.swift
//  ELDMandateTask
//
//  Created by Vineet Singh on 10/07/20.
//  Copyright © 2020 ELDMandate. All rights reserved.
//

import UIKit
import Kingfisher

class VideoDetailsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var videoThumbnailImg: UIImageView!
    @IBOutlet weak var videoDateLbl: UILabel!
    @IBOutlet weak var videoTimeLbl: UILabel!
    @IBOutlet weak var videoStatusImg: UIImageView!
    @IBOutlet weak var videoSizeLbl: UILabel!
    //@IBOutlet weak var contentViewWidthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        videoThumbnailImg.layer.cornerRadius = 10
    }
    
    func setupCell(videoData: VideoFilesData){
        
        if let imageUrl = videoData.thumbnail{
            
            let url = URL(string: imageUrl)
            let processor = DownsamplingImageProcessor(size: videoThumbnailImg.frame.size)
                |> RoundCornerImageProcessor(cornerRadius: 10)
            videoThumbnailImg.kf.indicatorType = .activity
            videoThumbnailImg.kf.setImage(
                with: url,
                placeholder: nil,
                options: [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ])
            {
                result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                }
            }
        }
        
        if let size = videoData.fileSize{
            videoSizeLbl.text = size
        }
        
        if let videoState = videoData.status{
            
            switch videoState {
            case VideoState.STATUS_NONE.rawValue:
                videoStatusImg.image = UIImage(named: "STATUS_NONE")
            case VideoState.STATUS_DOWNLOADED.rawValue:
                videoStatusImg.image = UIImage(named: "STATUS_DOWNLOADED")
            case VideoState.STATUS_UPLOADED.rawValue:
                videoStatusImg.image = UIImage(named: "STATUS_UPLOADED")
                
            default:
                videoStatusImg.image = UIImage(named: "STATUS_NONE")
            }
            
        }
        
        if let dateString = videoData.dateTime{

            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

            if let dateObj = dateFormatter.date(from: dateString){

                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                dateFormatter.dateFormat = "yyyy-MM-dd"

                let date = dateFormatter.string(from: dateObj)

                videoDateLbl.text = date

            }
            else{
                videoDateLbl.text = "N/A"
            }


        }
        
        if let timeString = videoData.dateTime{
            
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

            if let dateObj = dateFormatter.date(from: timeString){

                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                dateFormatter.dateFormat = "HH:mm:ss"

                let date = dateFormatter.string(from: dateObj)

                videoTimeLbl.text = "@ " + date

            }
            else{
                videoTimeLbl.text = "N/A"
            }
            
            
            
        }
        
    }

}

enum VideoState: String {
    case STATUS_NONE
    case STATUS_DOWNLOADED
    case STATUS_UPLOADED
}
