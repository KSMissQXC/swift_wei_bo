//
//  CQKeyboardPackage.swift
//  text_swift表情键盘
//
//  Created by apple on 16/6/24.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit
/**
 说明：
 1. Emoticons.bundle 的根目录下存放的 emoticons.plist 保存了 packages 表情包信息
 >packages 是一个数组, 数组中存放的是字典
 >字典中的属性 id 对应的分组路径的名称
 2. 在 id 对应的目录下，各自都保存有 info.plist
 >group_name_cn   保存的是分组名称
 >emoticons       保存的是表情信息数组
 >code            UNICODE 编码字符串
 >chs             表情文字，发送给新浪微博服务器的文本内容
 >png             表情图片，在 App 中进行图文混排使用的图片
 */

class CQKeyboardPackage: NSObject {
    /// 当前组的名称
    var group_name_cn: String?
    
    /// 当前组对应的文件夹名称
    var id: String?
    
    /// 当前组所有的表情
   lazy var emoticons: [CQKeyboardEmotion] = [CQKeyboardEmotion]()
    
    static let packages =  CQKeyboardPackage.loadEmotionPackages()
    

    
    init(id : String) {
        super.init()
        self.id = id

    }
    
     /// 加载所有组数据
    class func loadEmotionPackages() -> [CQKeyboardPackage]{
        var models = [CQKeyboardPackage]()
        // 0.手动添加最近组
        let  package = CQKeyboardPackage(id: "")
        package.appendEmptyEmoticons()
        models.append(package)
  
        // 1.加载emoticons.plist文件
        let path = NSBundle.mainBundle().pathForResource("emoticons.plist", ofType: nil, inDirectory: "Emoticons.bundle")
        
        //2.利用文件路径创建字典
        let dict = NSDictionary(contentsOfFile: path!)
        
        //3.拿到字典里面对应的表情包组
        let array = dict!["packages"] as! [[String : AnyObject]]
        
        for packageDict in array {
            // 2.1创建当前组模型
            let package = CQKeyboardPackage(id: packageDict["id"] as! String)
            
            //2.这个包加载所有表情
            package.loadEmoticons()
            
            // 2.3补全一组数据, 保证当前组能被21整除
            package.appendEmptyEmoticons()
            
            models.append(package)

        }
        return models
    }
    
    
    /// 补全一组数据, 保证当前组能被21整除
    private func appendEmptyEmoticons(){
        
        // 1.取出不能被21整除剩余的个数
        let number = emoticons.count % 21
        
        // 2.补全
        for _ in number ..< 20 {
            
            let emotion = CQKeyboardEmotion(isRemoveButton: false)
            
            emoticons.append(emotion)
        }
        
        
        // 3.补全删除按钮
        let emoticon = CQKeyboardEmotion(isRemoveButton: true)
        emoticons.append(emoticon)

        
        

        
    }
    
    private func loadEmoticons()  {
        
        // 1.拼接当前组info.plist路径
        let path = NSBundle.mainBundle().pathForResource(id, ofType: nil, inDirectory: "Emoticons.bundle")
        
        let filePath = (path! as NSString).stringByAppendingPathComponent("info.plist")
        
        //2.通过路径加载字典
        let dict = NSDictionary(contentsOfFile: filePath)
        
        // 3.1取出当前组名称
        group_name_cn = dict!["group_name_cn"] as? String
        
  
        
        //获取字典模型数组
        let array = dict!["emoticons"] as! [[String : AnyObject]]
        
        var index = 0
        
        
        for emotionDict in array {
            
            //当索引为20  下个 为最后一个 添加删除按钮
            if index == 20 {
                let emoticon = CQKeyboardEmotion(isRemoveButton: true)
                emoticons.append(emoticon)
                index = 0
                continue
            }
 
            let emotion = CQKeyboardEmotion(dict: emotionDict,id: id!)
            emoticons.append(emotion)
            index = index + 1

        }

    }
    
    /// 添加最近表情
    func addFavoriteEmoticon(emoticon: CQKeyboardEmotion)
    {
        emoticons.removeLast()
        
        // 1.判断当前表情是否已经添加过了
        if !emoticons.contains(emoticon)
        {
            // 2.添加当前点击的表情到最近
            emoticons.removeLast()
            emoticons.append(emoticon)
        }
        
        // 3.对表情进行排序
        let array =  emoticons.sort({ (e1, e2) -> Bool in
            return e1.count > e2.count
        })
        emoticons = array
        
        // 4.添加一个删除按钮
        emoticons.append(CQKeyboardEmotion(isRemoveButton: true))
        
    }
    
  class func createMutableAttrString(str : String ,font : UIFont) -> NSMutableAttributedString{
        
        //创建表情的规则
        let pattern = "\\[.*?\\]"
        
        //2.利用规则创建一个正则表达式对象
        let regex = try! NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive)
        
        //3.匹配结果
        let results = regex.matchesInString(str, options: NSMatchingOptions(rawValue : 0), range: NSRange(location: 0, length: str.characters.count))
        
        //根据传进来的字符串创建一个属性字符串
        let attrMstr = NSMutableAttributedString(string: str)
        for var i = results.count - 1; i >= 0; i = i - 1{
            //取出匹配到结果的chs
            let result = results[i]
            let chs = (str as NSString).substringWithRange(result.range)
            
            //查找对应的图片路径
            let pngPath = findPngPath(chs)
            
            guard let tempPngPath = pngPath else{
                continue
            }
            
            //创建属性文字
            let attachment = NSTextAttachment()
            attachment.image = UIImage(contentsOfFile: tempPngPath)
            attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
            //创建属性文字
            let attrM = NSAttributedString(attachment: attachment)
            //创建出来的图片,替换之前的
            attrMstr.replaceCharactersInRange(result.range,withAttributedString: attrM)
        }
    
        return attrMstr

    }
    
    class func findPngPath(chs : String) -> String? {
        
        //获取所有的表情包
        for package in CQKeyboardPackage.packages {
        
            if package.emoticons.count == 0 {
                print("表情包没有值")
                continue
            }
            
            var pngPath : String?
            
            
            //遍历表情包里面的表情
            for emotion in package.emoticons {
                
                guard let emtionChs = emotion.chs else{
                    continue
                }
                
                if emtionChs == chs {
                    
                    pngPath = emotion.pngPath
                    return pngPath
 
                }

            }

        }
        
        
        return nil

    }


}


class CQKeyboardEmotion: NSObject {
    
    /// 当前组对应的文件夹名称
    var id: String?

    /// 当前表情对应的字符串
    var chs: String?
    
    /// 记录当前表情的使用次数
    var count: Int = 0
    
    /// 当前表情对应的图片
    var png: String?{
        didSet{
            let path = NSBundle.mainBundle().pathForResource(id, ofType: nil, inDirectory: "Emoticons.bundle")!
            pngPath = (path as NSString).stringByAppendingPathComponent(png ?? "")
        }
    }
    
    /// 转换之后的emoji表情字符串
    var emoticonStr: String?
    
    /// Emoji表情对应的字符串
    var code: String?{
        didSet{
            // 1.创建一个扫描器
            let scanner = NSScanner(string: code ?? "")
            // 2.从字符串中扫描出对应的16进制数
            var result : UInt32 = 0
            scanner.scanHexInt(&result)
            // 3.根据扫描出的16进制创建一个字符串
            emoticonStr = "\(Character(UnicodeScalar(result)))"

        }
      
    }
    
    //kvc初始化方法
    init(dict : [String : AnyObject],id : String) {
        self.id = id
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    /// 记录当前表情是否是删除按钮
    var isRemoveButton: Bool = false
    
    init(isRemoveButton: Bool)
    {   super.init()
        self.isRemoveButton = isRemoveButton
    }

    
    /// 当前表情图片的绝对路径
    var pngPath: String?
    
    //重写这个方法防止崩溃
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
}










