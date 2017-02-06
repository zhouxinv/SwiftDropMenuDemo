//
//  AHDropMenuViewCell.swift
//  SwiftDropMenuDemo
//
//  Created by GeWei on 2017/1/29.
//  Copyright © 2017年 GeWei. All rights reserved.
//

import UIKit
import SnapKit


class AHDropMenuViewCell: UITableViewCell {
    
    var labTitle: UILabel = UILabel()
    var imgView: UIImageView = UIImageView()
    var checkImg: UIImageView = UIImageView()
    var lineView:UIView = UIView()
    
    override  init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.createSubViewsAndConstrains()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 为cell赋值
    ///
    /// - Parameters:
    ///   - mItem: model
    ///   - indexPath: indexPath
    public func makeCellWithModel(mItem: AHDropMenuItem, indexPath: IndexPath) {
        labTitle.text = mItem.title
        //状态被选中时
        if mItem.selected {
            imgView.image = mItem.iconHighlighted;
            self.backgroundColor = mItem.backgroundColorHighlighted;
            checkImg.image = mItem.checkImageSelected;
            labTitle.font = mItem.titleFontHighlighted;
            labTitle.textColor = mItem.titleColorHighlighted;
        }
        else {
            imgView.image = mItem.icon;
            self.backgroundColor = mItem.backgroundColor;
            checkImg.image = mItem.checkImage;
            labTitle.font = mItem.titleFont;
            labTitle.textColor = mItem.titleColor;
        }
        
    }
    
     func createSubViewsAndConstrains() {
        
        labTitle.textAlignment = .center
        self.contentView.addSubview(labTitle)
        
        imgView.layer.cornerRadius = 15
        imgView.clipsToBounds = true
        self.contentView.addSubview(imgView)
        
        self.contentView.addSubview(checkImg)
        
        lineView.backgroundColor = UIColor.gray
        self.contentView.addSubview(lineView)
        
        labTitle.snp.makeConstraints { (make) in
            make.center.equalTo(self.contentView)
            make.width.lessThanOrEqualTo(120)
        }
        
        imgView.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.width.height.equalTo(30)
            make.centerY.equalTo(labTitle)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(0)
            make.height.equalTo(0.5)
            make.bottom.equalTo(self.contentView)
        }
        
        checkImg.snp.makeConstraints { (make) in
            make.trailing.equalTo(-30)
            make.width.height.equalTo(20)
            make.centerY.equalTo(labTitle)
        }
    }
    
    
    
   

}
