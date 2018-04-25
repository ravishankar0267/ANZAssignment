//
//  RequestResponseManager.swift
//  ANZAssignment
//
//  Created by Ravi Mishra on 24/04/18.
//  Copyright © 2018 Capgemini. All rights reserved.
//

import Foundation
protocol RequestResponseProtocol{
    func getResponse(result:[ListDetails])
    func getErrorResponse(error:NSString)
}

class RequestResponseManager: NSObject {
    var delegate:RequestResponseProtocol?
    
    func getSereverResponse(url:String){
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response
            , error) in
            guard let data = data else { return }
            let responseStrInISOLatin = String(data: data, encoding: String.Encoding.isoLatin1)
            guard let modifiedDataInUTF8Format = responseStrInISOLatin?.data(using: String.Encoding.utf8) else {
                return
            }
            do {
                let decoder = JSONDecoder()
                let data = try decoder.decode(CollectionModel.self, from: modifiedDataInUTF8Format)
                self.delegate?.getResponse(result: data.rows)
            } catch let err {
               self.delegate?.getErrorResponse(error: err.localizedDescription as NSString)
            }
            }.resume()
    }

}



