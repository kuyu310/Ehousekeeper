

import UIKit

class MainAD: NSObject, DictModelProtocol {
    var code: Int = -1
    var msg: String?
    var data: AD?
 
    
    class func loadADData(completion:(_ data: MainAD?, _ error: NSError?) -> Void) {
        let path = Bundle.main.path(forResource: "AD", ofType: nil)
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!))
        if data != nil {
            let dict: NSDictionary = (try! JSONSerialization.jsonObject(with: data!, options: .allowFragments)) as! NSDictionary
            let modelTool = DictModelManager.sharedManager
            let data = modelTool.objectWithDictionary(dict, cls: MainAD.self) as? MainAD
            completion(data, nil)
        }
    }
    
    static func customClassMapping() -> [String : String]? {
        return ["data" : "\(AD.self)"]
    }
}

class MjMainAD: NSObject {
    var code: Int = -1
    var msg: String?
    var data: AD?
    
    
    class func loadADData(completion:(_ data: AD?, _ error: NSError?) -> Void) {
        let path = Bundle.main.path(forResource: "AD", ofType: nil)
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!))
        if data != nil {
            
//        使用了mj的数模转换模型，还挺好用的，如果遇到目标与源头的结构不一致，可以用下面的函数做标签映射
            AD.mj_setupReplacedKey(fromPropertyName: { () -> [AnyHashable : Any]? in
                return ["img_name":"data.img_name",
                        "starttime":"data.starttime",
                        "endtime":"data.endtime",
                        "title":"data.title"]
            })
            let data_temp = AD.mj_object(withKeyValues: data!)
            completion(data_temp, nil)
        }
    }
    
//    static func customClassMapping() -> [String : String]? {
//        return ["data" : "\(AD.self)"]
//    }
}


class AD: NSObject {
    var title: String?
    var img_name: String?
    var starttime: String?
    var endtime: String?
}
