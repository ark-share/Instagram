//
//  CommentTableViewCell.swift
//  Instagram
//
//  Created by macpc on 2016/08/09.
//  Copyright © 2016年 hiroshi.ohara. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {


    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var commentData: CommentData!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    // 表示の時呼ばれる コメントの内容表示
    override func layoutSubviews() {
        
        if commentData != nil {
            nameLabel.text = "\(commentData.name!)"
            bodyLabel.text = "\(commentData.body!)"
            
            let formatter = NSDateFormatter()
            formatter.locale = NSLocale(localeIdentifier: "ja_JP")
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            
            let dateString:String = formatter.stringFromDate(commentData.date!)
            dateLabel.text = dateString
        }
        
        super.layoutSubviews()
    }

}
