//

//  Save.swift

//  Location

//

//  Created by Ethan Swift on 7/12/22.

//


import Foundation


class Save: ViewController {

    func writeData(uid: String, sensor: String, startTimeMillis: Int64, data: Dictionary<String, Any>) {

        var documentDirectoryUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)

        documentDirectoryUrl.appendPathComponent("SASSEMA")

        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String

        let url = NSURL(fileURLWithPath: path)

        if let pathComponent = url.appendingPathComponent("SASSEMA") {

            let filePath = pathComponent.path

            let fileManager =  FileManager.default

            

            do {

                let f = try fileManager.contentsOfDirectory(atPath: path)

                try FileManager.default.createDirectory(atPath: filePath, withIntermediateDirectories: true, attributes: nil)

                let files =  try fileManager.contentsOfDirectory(atPath: filePath)

                print(files)

                let JSONdata = try JSONSerialization.data(withJSONObject: data)

                for file in files {

                    print(file)

                   

                    let fileUrl = pathComponent.appendingPathComponent(file)

                    print("fileURL-----------------")

                    print(fileUrl)

                    let stringfile = try? String(contentsOf: fileUrl)

                    let resources = try fileUrl.resourceValues(forKeys:[.fileSizeKey])

                    print(stringfile)

                    let fileSize = resources.fileSize!

                    print("file size: \(fileSize)")

                    if ((file.range(of: sensor) != nil) && (fileSize < 3000)) {

                        if let fileHandle = FileHandle(forWritingAtPath: fileUrl.path) {

                            fileHandle.seekToEndOfFile()

                            fileHandle.write(JSONdata)
                            let newline = "\n" as NSString
                            let data = newline.data(using: String.Encoding.utf8.rawValue)!
                            try fileHandle.write(contentsOf: data)


                        }

                        

                        print("--------file contents-------")

                        print("-----Wrote \(sensor) data to \(file)-----")

                        let text2 = try String(contentsOf: fileUrl, encoding: .utf8)

                        print(text2)

                        FileUpload().uploadIfNotAlreadyEnqued(fileName: fileUrl.absoluteString)

                        return //comment this and uncomment marked lines below to delete files in directory

                    }

                    

                    //try fileManager.removeItem(atPath: fileUrl.path) //uncomment this and the return statement below to delete files in directory

                }

                //return //uncomment this and the try statement above to delete files in directory

                let fileUrl = pathComponent.appendingPathComponent(uid+"_"+sensor+"_"+String(startTimeMillis)).appendingPathExtension("log")

                print(fileUrl)

                fileManager.createFile(atPath: fileUrl.path, contents: JSONdata)

                print("File created")

                let files1 = try fileManager.contentsOfDirectory(atPath: pathComponent.path)

                print(files1)

            } catch {

                print(error)

            }

        }

        

    }

}
