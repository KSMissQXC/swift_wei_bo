//
//  CQHomeTableController.swift
//  CQWB_SWIFT
//
//  Created by apple on 16/5/30.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit
import SVProgressHUD


class CQHomeTableController: CQBaseTableViewController {
//MARK: - 懒加载和属性
    private lazy var presentManager : CQPresentationManager = {
        let manager = CQPresentationManager()
        manager.presentFrame = CGRect(x: 100, y: 64, width: 200, height: 300)
        return manager
        
    }()
    
    //MARK: 导航条顶部按钮
   private lazy var titleBtn : CQHomeTitleBtn = {
        let titleBtn = CQHomeTitleBtn()
        let titleName = CQUserAccount.loadUserAccount()?.screen_name
        titleBtn.setTitle(titleName, forState: UIControlState.Normal)
        titleBtn.addTarget(self, action: #selector(CQHomeTableController.titleBtnClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        return titleBtn

    }()
    
    //MARK: 保存每个cell里面的数据,cell高度的模型数组
   private var statusViewModels : [CQStatusViewModel]?{
        didSet{
            tableView.reloadData()
        }
    }
    
    //MARK: 控制点击图片后的转场效果
    private lazy var browserPresentationManager : CQBrowserPresentationController = CQBrowserPresentationController()
    
    
    
    
    //MARK: 顶部显示提示的label
    private lazy var tipLabel : UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.whiteColor()
        lb.backgroundColor = UIColor.orangeColor()
        lb.text = "没有更多数据"
        lb.textAlignment = NSTextAlignment.Center
        lb.hidden = true
        lb.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 44)
        return lb
    }()

    


//MARK: - 初始化
    override func viewDidLoad() {
        super.viewDidLoad()
        if !isLogin {
            vistorView?.setupVisitorViewInfo(nil, title: "关注一些人，回这里看看有什么惊喜")
            return
        }
        tableView.estimatedRowHeight = 300;
        setupNav()
        loadNewData()
        
        //设置头部刷新控件
        refreshControl = CQRefreshControl()
        refreshControl?.addTarget(self, action: #selector(CQHomeTableController.loadNewData), forControlEvents: UIControlEvents.ValueChanged)
        refreshControl?.beginRefreshing()
        
        //添加提示label
        navigationController?.navigationBar.insertSubview(tipLabel, atIndex: 0)
        
        //监听弹出,消失动画
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CQHomeTableController.titleClickNoti), name: CQPResentationManagerDidDismissed, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CQHomeTableController.titleClickNoti), name: CQPResentationManagerDidPresented, object: nil)
        
        //监听图片点击
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CQHomeTableController.showBrowser(_:)), name: CQShowPhotoBrowserController, object: nil)
        
        
    }
    
    
    //MARK: 加载最新数据
    @objc private func loadNewData(){
        let since_id = statusViewModels?.first?.status.idstr ?? "0"
        CQNetWorkTools.shareInstance.loadNewStatuses(since_id) { (array, error) in
            self.handleData(array, error: error, moreData: false)
            self.refreshControl?.endRefreshing()
            
            //显示刷新视图
            self.showRefreshStatus(array!.count)
        }
    }
    
    //MARK: 加载之前数据
    private func loadMoreData() {
        let max_id = self.statusViewModels?.last?.status.idstr ?? "1"
        CQNetWorkTools.shareInstance.loadMoreStatuses(max_id) { (array, error) in
            self.handleData(array, error: error,moreData: true)
        }
    }
    
    //MARK: 处理放回来的数据
    func handleData(array : [[String : AnyObject]]?,error : NSError?,moreData : Bool) {
        if error != nil{
            SVProgressHUD.showErrorWithStatus("获取数据失败", maskType: SVProgressHUDMaskType.Black)
            return
        }
        var viewModels = [CQStatusViewModel]()
        guard let arr = array else{
            return
        }
        let count = self.statusViewModels?.count
        
        for dict in arr{
            let status = CQStatusViewModel(status: CQStatus(dict: dict))
            viewModels.append(status)
            status.cachesImages({ (vModle) in
                var index = viewModels.indexOf(vModle)
                if moreData{
                    index = index! + (count! - 1)
                }
                let indexPath = NSIndexPath(forRow: index!, inSection: 0)
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
            })
        }
        
        if let models = self.statusViewModels{
            if moreData {
                self.statusViewModels = models + viewModels ;
            }else{
                self.statusViewModels = viewModels + models;
            }
        }else{
            self.statusViewModels = viewModels
        }
    }


    //MARK: 初始化导航条
    private func setupNav(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention", target: self, action: #selector(CQHomeTableController.leftBtnClick))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop", target: self, action: #selector(CQHomeTableController.rightBtnClick))
            navigationItem.titleView = titleBtn
    }
    
//MARK: 销毁调用
    deinit{
       NSNotificationCenter.defaultCenter().removeObserver(self)
    }

//MARK: - 内部私有方法
    //MARK: 提示刷新的数据条数
    func showRefreshStatus(count : NSInteger)  {
        tipLabel.text = (count == 0) ? "没有更多数据" : "刷新了\(count)条数据"
        tipLabel.hidden = false
        //提示时先关闭交互
        self.tableView.userInteractionEnabled = false
        UIView.animateWithDuration(0.25, animations: {
            self.tipLabel.transform = CGAffineTransformMakeTranslation(0, 44)
            }) { (_) in
            UIView.animateWithDuration(1, delay: 1, options: UIViewAnimationOptions(rawValue: 0), animations: { 
                self.tipLabel.transform = CGAffineTransformIdentity
                }, completion: { (_) in
                    self.tableView.userInteractionEnabled = true
                    self.tipLabel.hidden = true
            })
     
        }

    }
    
    
    
    
//MARK: - 事件处理
    @objc private func leftBtnClick(){
        CQLog("--")
    }
    
    @objc private func rightBtnClick(){
        
        let vc = UIStoryboard.init(name: "QRCods", bundle: nil).instantiateInitialViewController()
        presentViewController(vc!, animated: true, completion: nil)

    }
    @objc private func titleBtnClick(btn : CQHomeTitleBtn){
        let popVc = CQHomePopViewController()
        popVc.transitioningDelegate = presentManager
        popVc.modalPresentationStyle = UIModalPresentationStyle.Custom
        presentViewController(popVc, animated: true, completion: nil)
    }
    
    @objc private func titleClickNoti(){
        titleBtn.selected = !titleBtn.selected
    }
    //跳转到浏览图片控制器
    @objc private func showBrowser(notice : NSNotification){
        
        // 注意: 但凡是通过网络或者通知获取到的数据, 都需要进行安全校验
        guard let pictures = notice.userInfo![CQbmiddle_pic] as? [NSURL] else
        {
            SVProgressHUD.showErrorWithStatus("没有图片", maskType: SVProgressHUDMaskType.Black)
            return
        }
        
        guard let index = notice.userInfo![CQindexPath] as? NSIndexPath else
        {
            SVProgressHUD.showErrorWithStatus("没有索引", maskType: SVProgressHUDMaskType.Black)
            return
        }
        
        
        guard let presentModel = notice.userInfo![CQbrowserModel] as? CQPresentModel else
        {
            SVProgressHUD.showErrorWithStatus("没有获得模型", maskType: SVProgressHUDMaskType.Black)
            return
        }


        // 弹出图片浏览器, 将所有图片和当前点击的索引传递给浏览器
        let vc = CQBrowserViewController(bmiddle_pic: pictures, indexPath: index)
        vc.transitioningDelegate = browserPresentationManager
        vc.presentModel = presentModel
        browserPresentationManager.presentModel = presentModel
        vc.modalPresentationStyle = UIModalPresentationStyle.Custom
        presentViewController(vc, animated: true, completion: nil)
    }
    
    
    

}

//MARK: - 代理协议
//MARK: tableView代理,数据源
extension CQHomeTableController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusViewModels?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       let statu =  statusViewModels![indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(statu.identify) as! CQHomeTableViewCell
        cell.status = statu
        if indexPath.row == (statusViewModels!.count - 1) {
            loadMoreData()
        }
        return cell
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let statusViewModel = statusViewModels![indexPath.item]
        return statusViewModel.cellHeight
    }
}

















