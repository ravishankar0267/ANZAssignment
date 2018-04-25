//
//  Utility.swift
//  ANZAssignment
//
//  Created by Ravi Mishra on 24/04/18.
//  Copyright © 2018 Capgemini. All rights reserved.
//

import UIKit

class Utility: NSObject {

}
extension FileManager {
    class func documentsDir() -> String {
        var paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as [String]
       // print(paths[0])
        return paths[0]
    }
    
    class func cachesDir() -> String {
        var paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true) as [String]
        return paths[0]
    }
}

extension ListViewController{
    
    func downloadImageIfNotExist(indexPath:IndexPath)  {
        let  model =  collectionDatasource[indexPath.row]
        let docUmentDirectoryPath = FileManager.documentsDir()
        if(model.imageUrlRefrence != nil){
            let getImagePath = (docUmentDirectoryPath as String)+"/"+model.title!
            let checkValidation = FileManager.default
            if (checkValidation.fileExists(atPath: "\(getImagePath)")) {
                _ =  UIImage(contentsOfFile: getImagePath)! as UIImage
                
            }
            else {
                imageForImageURLString(imageURLString: model.imageUrlRefrence!) { (image, success) -> Void in
                    if success {
                        guard let image = image
                            
                            else {
                                return
                        } // Error handling here
                        self.saveImageLocally(imageName: model.title!, image: image)
                        DispatchQueue.main.async {
                            self.collectionView.reloadItems(at: [indexPath])
                        }
                        
                    }
                }
            }
        }
        
    }
    
    func imageForImageURLString(imageURLString: String, completion: @escaping (_ image: UIImage?, _ success: Bool) -> Void) {
        DispatchQueue.global(qos: .default).async {
          //  print(imageURLString)
            guard let url = NSURL(string: imageURLString),
                let data = NSData(contentsOf: url as URL),
                let image = UIImage(data: data as Data)
                else {
                    completion(nil, false);
                    return
            }
            
            completion(image, true)
        }
    }
    
    func saveImageLocally(imageName:String, image:UIImage?)
    {
        let fileManager = FileManager.default
        let docUmentDirectoryPath = FileManager.documentsDir()
        let finalPaths =  (docUmentDirectoryPath as NSString).appendingPathComponent("\(imageName)")
        let imageData = UIImageJPEGRepresentation(image!, 0.5)
        fileManager.createFile(atPath: finalPaths as String, contents: imageData, attributes: nil)
    }

}
