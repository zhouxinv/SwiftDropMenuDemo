//
//  AHDropMenuView.swift
//  SwiftDropMenuDemo
//
//  Created by GeWei on 2017/1/28.
//  Copyright © 2017年 GeWei. All rights reserved.
//

import UIKit

@objc protocol  AHDropMenuViewDelegate: NSObjectProtocol{
    func dataSourceForDropMenu() -> (Array<AHDropMenuItem>)
    //    在协议中使用 optional 关键字作为前缀来定义可选要求。可选要求用在你需要和 Objective-C 打交道的代码中。协议和可选要求都必须带上@objc属性。
    /*
     *  single select
     */
    @objc optional func dropMenuViewDidSelectAtIndex(dropMenuView: AHDropMenuView, indexPath: IndexPath)
    /*
     *  multi select
     */
    @objc optional func dropMenuViewDidMultiSelectIndexPaths(dropMenuView: AHDropMenuView, selIndexSet: Set<Int>)
    /*
     * headerView
     */
    @objc optional func dropMenuHeaderView(dropMenuView: AHDropMenuView) -> UIView
    /*
     * headerViewHeight
     * 设置headView 不设置headView的高度，即使view有高度，仍然不能显示，必须设置headView的高度。
     */
    @objc optional func dropMenuHeaderViewHeight() -> CGFloat
    
}


 class AHDropMenuView: UIView {
    public weak var delegate: AHDropMenuViewDelegate?
    ///展开
    public var isShow = false
    ///多选
    public var isMultiselect: Bool?
    ///tableview当前的高度 44(defaultCellRowHeight) * 8(maxRowNum)
    var currentTableViewHeight: CGFloat = 352
    /// headView 当前的高度
    var currentHeadViewHeight: CGFloat = 0
    
    /// 数据源数组
    var arrDataSource: Array<AHDropMenuItem>?
    /// 传进来的父view
    var vSuper:UIView?
    /// 下拉Menu
    let tableView: UITableView = UITableView()
    /// headerView
    lazy var headerView: UIView = UIView()
    /// 阴影遮盖View
    let blurredView: UIView = UIView()
    /// 当前被选中的index的集合
    lazy var indexSet: Set<Int> = []
    /// 上一次选择的model
    var lastModel: AHDropMenuItem?
    
    ///默认cell高度
    static let defaultCellRowHeight: CGFloat = 44.0
    //tableView 展示最多行数
    static var maxRowNum: NSInteger = 8
    ///tableView 的当前高度

    ///初始化
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    /// 在 Navigation Controller 中创建 menu
    ///
    /// - Parameters:
    ///   - navigationController: 导航控制器
    ///   - delegate: 传入代理
    convenience init(navigationController: UINavigationController, delegate:AHDropMenuViewDelegate) {
        let vcBase: UIViewController = navigationController.viewControllers.last!
        self.init(viewController: vcBase, delegate: delegate)
    }
    
    
    /// 在 View Controller 中创建 menu
    ///
    /// - Parameters:
    ///   - viewController: 控制器
    ///   - delegate: meun代理
    convenience init(viewController: UIViewController, delegate: AHDropMenuViewDelegate) {
        self.init(view: viewController.view, delegate: delegate)!
    }
    
    /// 在 View 中创建 menu
    ///
    /// - Parameters:
    ///   - view: view
    ///   - delegate: meun代理
    init?(view: UIView, delegate: AHDropMenuViewDelegate?){
        super.init(frame: CGRect.zero)
        if delegate == nil {
            return nil
        }
        self.delegate = delegate
        self.vSuper = view
        view.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.top.equalTo(64);
            make.leading.trailing.equalTo(0);
            make.height.equalTo((self.vSuper?.snp.height)!).offset(-64);
        }
        
        self.initialValue()
        self.createSubViewsAndConstraints()
        
       
        
    }
    
     convenience init() {
       self.init(frame: CGRect.zero)
        assert(false, "请使用其他 init 方法");
    }
    
    required  init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// Menu 展示出来
    func show() {
       isShow = true
        self.isHidden = false
        tableView.snp.remakeConstraints({ (make) in
            make.top.equalTo(0);
            make.leading.trailing.equalTo(0);
            make.height.equalTo(currentTableViewHeight);
        })
        
        blurredView.snp.remakeConstraints({ (make) in
            make.leading.trailing.equalTo(0);
            make.top.equalTo((tableView.snp.bottom));
            make.height.equalTo((vSuper?.snp.height)!).offset(-64);

        })
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 2, options: .curveEaseInOut, animations: {
            self.layoutIfNeeded()
        }) { (finished) in
            
        }
    }
    
    
    /// Menu 收起来
    func hide()  {
        isShow = false
        
        blurredView.snp.remakeConstraints { (make) in
            make.leading.trailing.equalTo(0);
            make.top.equalTo(tableView.snp.bottom);
            make.height.equalTo(0);
        }
        self.tableView.snp.remakeConstraints { (make) in
            make.top.equalTo(0);
            make.leading.trailing.equalTo(0);
            make.height.equalTo(0);
        }

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            self.layoutIfNeeded()
        }) { (finished) in
            self.isHidden = true
        }
    }
    
    /// 设置 Menu 最大高度
    ///
    /// - Parameter maxRowNum: 最多显示的行数
    func intergerTableViewMaxRowNum(maxRowNum: NSInteger) {
        if maxRowNum < AHDropMenuView.maxRowNum {
            AHDropMenuView.maxRowNum = maxRowNum
            currentTableViewHeight = CGFloat(maxRowNum) * AHDropMenuView.defaultCellRowHeight + currentHeadViewHeight
        }
    }
    
    
    func initialValue() {
        //初始化数据放在一起
        self.arrDataSource = self.delegate?.dataSourceForDropMenu()
        self.isHidden = true

    }
    
    func createSubViewsAndConstraints() {
        blurredView.backgroundColor = UIColor.init(white: 0.5, alpha: 0.8)
        self.addSubview(blurredView)
        let bgTap: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(bgTappedAction(recognizer:)))
        blurredView.addGestureRecognizer(bgTap)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.bounces = false
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        self.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(0);
            make.top.bottom.equalTo(0);
        }
        
        blurredView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(0);
            make.top.bottom.equalTo(0);
        }
        
        //headView的代理方法
        let vHeaderChild: UIView?
        vHeaderChild = self.delegate?.dropMenuHeaderView?(dropMenuView: self)
        var headerHeight: CGFloat = 0.0
        if vHeaderChild != nil {
            headerHeight = (self.delegate?.dropMenuHeaderViewHeight?()) ?? 0.0
            
            //tableView的headView的高度最多为60
            headerHeight = headerHeight > 60 ? 60 : headerHeight
            
            currentHeadViewHeight = headerHeight
            currentTableViewHeight += headerHeight
            
            headerView.backgroundColor = UIColor.blue
            headerView.addSubview(vHeaderChild!)
            tableView.tableHeaderView = headerView
            headerView.snp.makeConstraints({ (make) in
                make.leading.top.equalTo(0);
                make.width.equalTo(tableView.snp.width);
                make.height.equalTo(headerHeight);
            })
            
            tableView.layoutIfNeeded()
            vHeaderChild?.center = headerView.center
        }
    }
    
    
    
    
    func bgTappedAction(recognizer: UITapGestureRecognizer) {
        self.hide()
    }

}


extension AHDropMenuView: UITableViewDataSource, UITableViewDelegate {
    static let reuserIdentify: String = "AHDropMenuViewCell";
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = arrDataSource?.count ?? 0
        return count;
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var  cell = self.tableView.dequeueReusableCell(withIdentifier: AHDropMenuView.reuserIdentify) as? AHDropMenuViewCell
        
        if cell == nil {
            cell = AHDropMenuViewCell.init(style: .default, reuseIdentifier: AHDropMenuView.reuserIdentify)
        }
        cell!.makeCellWithModel(mItem: arrDataSource![indexPath.row], indexPath: indexPath)
        return cell!;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //不论是单选还是多选都需要为model赋值
        let model: AHDropMenuItem = arrDataSource![indexPath.row]
        if isMultiselect == true {
            model.selected = !model.selected
        } else {
            lastModel?.selected = false
            model.selected = true
            lastModel = model
        }
        
        if isMultiselect == true {
            if indexSet.contains(indexPath.row) == true {
                indexSet.remove(indexPath.row)
            } else {
                indexSet.insert(indexPath.row)
            }
            
            delegate?.dropMenuViewDidMultiSelectIndexPaths!(dropMenuView: self, selIndexSet: indexSet)
        } else {
            indexSet.removeAll()
            indexSet.insert(indexPath.row)
            delegate?.dropMenuViewDidSelectAtIndex!(dropMenuView: self, indexPath: indexPath)
            self.hide()
        }
        
        tableView.reloadData()
    }
    
}
