//
//  AHDropMenuItem.swift
//  SwiftDropMenuDemo
//
//  Created by GeWei on 2017/1/28.
//  Copyright © 2017年 GeWei. All rights reserved.
//

import UIKit

class AHDropMenuItem: NSObject {
    /** 可选项标题 */
    var title: String?
    /** 可选项头像图片 */
    var icon: UIImage?
    /** 高亮可选项头像图片 */
    var iconHighlighted: UIImage?
    /** 当前选项选中状态 */
    var selected: Bool = false;
    
    //MARK: - 背景样式
    /** 背景 */
    var backgroundColor: UIColor = UIColor.white {
        didSet {
            if backgroundColor != oldValue {
//                self.backgroundColor = backgroundColor
            }
        }
    }
    /** 高亮背景 */
    var backgroundColorHighlighted: UIColor = UIColor.white
    /** 选中打勾-默认 */
    var checkImage: UIImage?
    ///选中打勾-已选中
    var checkImageSelected: UIImage = UIImage(named: "check")!;
    /** 标题字号 */
    var titleFont: UIFont = UIFont.systemFont(ofSize: 14);
    /** 标题高亮字号 */
    var titleFontHighlighted: UIFont = UIFont.systemFont(ofSize: 14)
    /** 标题文字默认颜色 */
    var titleColor: UIColor = UIColor.black
    /** 标题文字高亮颜色 */
    var titleColorHighlighted: UIColor = UIColor.black
    
    convenience init(title: String, icon: UIImage?) {
        /// 只设置默认icon的时候, 高亮icon和默认icon 相同
        self.init(title: title, icon: icon, iconHighlighted: icon)
    }
    
    init(title: String, icon: UIImage?, iconHighlighted: UIImage?) {
        self.title = title
        self.icon = icon
        self.iconHighlighted = iconHighlighted
        super.init()
    }
    
     override convenience init() {
       self.init(title: "", icon: nil)
        assert(false, "使用 - (instancetype)initWithTitle:(NSString *)title iconImage:(UIImage *)iconImage")
    }
    
    func setItemStyle(backgroundColor: UIColor,
                      backgroundColorHighlighted: UIColor,
                      checkImage: UIImage,
                      checkImageSelected: UIImage,
                      titleColor: UIColor,
                      titleColorHighlighted: UIColor,
                      titleFont: UIFont,
                      titleFontHighlighted: UIFont) {
        self.backgroundColor = backgroundColor
        self.backgroundColorHighlighted = backgroundColorHighlighted
        self.checkImage = checkImage
        self.checkImageSelected = checkImageSelected
        self.titleColor = titleColor
        self.titleColorHighlighted = titleColorHighlighted
        self.titleFont = titleFont
        self.titleFontHighlighted = titleFontHighlighted
    }
    
    
    
}
