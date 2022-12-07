//  FileUpload.swift

//  TestingApp

//

//  Created by Sofia Dimotsi on 11/27/22.

//


import Foundation


class FileUpload: ViewController{

  func uploadIfNotAlreadyEnqued(fileName: String) {

    let myUrl = NSURL(string: "https://still.richmond.edu/upload_sassema_ios.php");

    print("Creating request for file:")

    print(fileName)

    let request = createRequest(path: fileName)

    let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in

    if error != nil {

            // handle error here

            print(error)

            return

    }

    do {

      if let responseDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {

                print("success == \(responseDictionary)")

                }

    } catch {

                print(error)


                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)

                print("responseString = \(responseString)")

            }

        }

        task.resume()


}


func createRequest(path: String) -> NSURLRequest{


    let param: [String: String]? = [:

    ]


        let boundary = generateBoundaryString()


        let url = NSURL(string: "https://still.richmond.edu/fred_ios3.php")!

        let request = NSMutableURLRequest(url: url as URL)

        request.httpMethod = "POST"

        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        request.setValue("userValue", forHTTPHeaderField: "X-Client-user")

        request.setValue("passValue", forHTTPHeaderField: "X-Access-pass")


         request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "voice", paths: [path], boundary: boundary)


        return request

    }


func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, paths: [String]?, boundary: String) -> Data? {

        let body = NSMutableData()


        if parameters != nil {

            for (key, value) in parameters! {

                body.appendString(string: "--\(boundary)\r\n")

                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")

                body.appendString(string: "\(value)\r\n")

            }

        }


        if paths != nil {

            for path in paths! {

                let newpath = path.replacingOccurrences(of: "file:///", with: "")

                let url = NSURL(fileURLWithPath: newpath)

                let filename = url.lastPathComponent

                let data = NSData(contentsOf: url as URL)!

                let mimetype = mimeTypeForPath(path: path)


                body.appendString(string: "--\(boundary)\r\n")

                body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename!)\"\r\n")

                body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")

                body.append(data as Data)

                body.appendString(string: "\r\n")

            }

        }


    body.appendString(string: "--\(boundary)--\r\n")

    return body as Data

    }


    func generateBoundaryString() -> String {

        return "Boundary-\(NSUUID().uuidString)"

    }



    func mimeTypeForPath(path: String) -> String {

        let url = NSURL(fileURLWithPath:  path)

        let pathExtension = url.pathExtension


       

        return "application/octet-stream";

    }

                                                    

                                            

}



extension NSMutableData {

func appendString(string: String) {

    let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)

    append(data!)

}

}
