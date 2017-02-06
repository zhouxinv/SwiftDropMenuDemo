//
//  ViewController.swift
//  SwiftDropMenuDemo
//
//  Created by GeWei on 2017/1/19.
//  Copyright © 2017年 GeWei. All rights reserved.
//

import UIKit

class ViewController: UIViewController, AHDropMenuViewDelegate {
    
    var dropView: AHDropMenuView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let DropButton = UIButton(type: .custom)
        DropButton.setTitle("Drop", for: .normal)
        DropButton.setTitleColor(UIColor.blue, for: .normal)
        DropButton.addTarget(self, action: #selector(DropbuttonClicked(sender:)), for: .touchUpInside)
        self.navigationItem.titleView = DropButton
        
        
        
        dropView = AHDropMenuView.init(viewController: self, delegate: self)
//          dropView = AHDropMenuView()
        //2.多选
//        dropView?.isMultiselect = true
        //3. 设置下拉菜单的最大高度
//        dropView?.intergerTableViewMaxRowNum(maxRowNum: 4)
        
    }
    
    func DropbuttonClicked(sender: UIButton) {
        if self.dropView?.isShow == true {
            self.dropView?.hide()
        } else {
            self.dropView?.show()
        }
    }

    func dataSourceForDropMenu() -> (Array<AHDropMenuItem>){
        //1.设置model 返回数据源
        let dataSource = NSMutableArray()
        let arrTitle = ["1.CELTICS", "2.CLIPPERS", "3.WARRIORS", "4.CELTICS", "5.CLIPPERS", "6.WARRIORS", "7.CELTICS", "8.CLIPPERS", "9.WARRIORS", "10.CELTICS", "11.CLIPPERS", "12.WARRIORS", "13.CELTICS", "14.CLIPPERS", "15.WARRIORS"]
        let arrIconName = ["1", "2", "3", "4", "5", "3", "1", "2", "5", "4", "2", "3", "4", "2", "3"]
        
        for item in arrTitle.enumerated() {
            var model: AHDropMenuItem
            //肯定有图片
            if arrIconName.count > item.offset {
              var img = UIImage(named: arrIconName[item.offset]) ?? nil
                 //几个没有头像的特殊情况处理
                if item.offset == 4 || item.offset == 5{
                    img = nil
                }
                model = AHDropMenuItem.init(title: item.element, icon: img)
                //这两个被选择的时候对勾传入自定义图片
                if item.offset == 1 || item.offset == 2 {
                  model.checkImage = UIImage(named: "tick")
                }
                dataSource.add(model)
            }
        }
      let arrDataSource = dataSource as NSArray
      return arrDataSource as! (Array<AHDropMenuItem>)
    }
    
    /*
     *  single select
     */
    func dropMenuViewDidSelectAtIndex(dropMenuView: AHDropMenuView, indexPath: IndexPath) {
        print("当前选择的是第\(indexPath.row)项")
    }
    /*
     *  multi select
     */
    func dropMenuViewDidMultiSelectIndexPaths(dropMenuView: AHDropMenuView, selIndexSet: NSIndexSet) {
        for item in selIndexSet {
            print("当前选择的包含有\(item)项")
 
        }
    }
    /*
     * headerView
     */
    func dropMenuHeaderView(dropMenuView: AHDropMenuView) -> UIView {
        let headerView = UIView()
        headerView.frame = CGRect.init(x: 0, y: 0, width: 320, height: 50)
        headerView.backgroundColor = UIColor.cyan
        return headerView
    }
    /*
     * headerViewHeight
     * 设置headView 不设置headView的高度，即使view有高度，仍然不能显示，必须设置headView的高度。
     */
    func dropMenuHeaderViewHeight() -> CGFloat{
        return 50
    }
    
    

}

