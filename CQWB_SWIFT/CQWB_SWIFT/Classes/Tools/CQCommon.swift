//
//  CQCommon.swift
//  CQWB_SWIFT
//
//  Created by 耳动人王 on 16/6/12.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

//MARK: - 配置常量
/// OAuth授权需要的key
let WB_App_Key = "229678906"
/// OAuth授权需要的Secret
let WB_App_Secret = "aa864d3fe58855cbfbc4f9636ac742be"
/// OAuth授权需要的重定向地址
let WB_Redirect_uri = "http://www.baidu.com"
/// cell的标识
let CQforwardCell = "forwardCell"
let CQstatusCell = "statusCell"

//MARK: - 通知常量
//自定义转场展现
let CQPResentationManagerDidPresented = "CQPResentationManagerDidPresented"
let CQPResentationManagerDidDismissed = "CQPResentationManagerDidDismissed"
let CQSwitchRootViewController = "CQSwitchRootViewController"

/// 显示图片浏览器通知
let CQShowPhotoBrowserController = "CQShowPhotoBrowserController"
/// 需要带过去的模型
let CQbrowserModel = "CQbrowserModel"
/// 图片数组
let CQbmiddle_pic = "CQbmiddle_pic"
/// 索引
let CQindexPath = "CQindexPath"
/// 修改模型中的值
let ChangePresentModel = "ChangePresentModel"
/// 穿过去的图片
let CQImage = "CQImage"






//MARK: - 常用的常量数据
///屏幕宽度
let CQwidth = UIScreen.mainScreen().bounds.width
///屏幕高度
let CQheight = UIScreen.mainScreen().bounds.height