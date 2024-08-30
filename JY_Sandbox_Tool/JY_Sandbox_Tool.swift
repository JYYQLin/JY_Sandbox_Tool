//
//  JY_Sandbox_Tool.swift
//  JY_Sandbox_Tool
//
//  Created by JYYQLin on 2024/8/29.
//

import UIKit

public let yq_sandboxTool = JY_Sandbox_Tool.yq_shared
open class JY_Sandbox_Tool: NSObject {
    
    //  MARK:- 单例
    /// 提供单例
    static let yq_shared: JY_Sandbox_Tool = JY_Sandbox_Tool()
}

extension JY_Sandbox_Tool {
    /** 获取沙盒Documents文件夹路径 */
    open func yq_documents_path() -> String? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths.first
        return documentsDirectory?.path
    }
    
    /** 根据传入文件名，拼接Documents文件夹全路径 */
    open func yq_appendPath_with_documents(fileName : String) -> String? {
        
        guard let path = yq_documents_path() else {
            return nil
        }
        
        /// 如果fileName是一个完整的URL，我们只需要URL最后的文件名和沙盒路径拼接
        /// pathComponents方法, 会按照字符串的『/』来切割字符串, 如果给定的字符串中没有『/』那么就直接返回给定的字符串
        guard let temp = (fileName as NSString).pathComponents.last else {
            return nil
        }
        
        let filePath = (path as NSString).appendingPathComponent(temp)
        return filePath
    }
}

extension JY_Sandbox_Tool {
    /** 获取沙盒Library文件夹路径 */
    open func yq_library_path() -> String? {
        let paths = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)
        let libraryDirectory = paths.first
        return libraryDirectory?.path
    }
    
    /** 根据传入文件名，拼接Library文件夹全路径 */
    open func yq_appendPath_with_library(fileName : String) -> String? {
        
        guard let path = yq_library_path() else {
            return nil
        }
        
        guard let temp = (fileName as NSString).pathComponents.last else {
            return nil
        }
    
        let filePath = (path as NSString).appendingPathComponent(temp)
        return filePath
    }
}

extension JY_Sandbox_Tool {
    /** 获取沙盒Cache文件夹路径 */
    open func yq_caches_path() -> String? {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let cachesDirectory = paths.first
        return cachesDirectory?.path
    }
    
    /** 根据传入文件名，拼接Caches文件夹全路径 */
    open func yq_appendPath_with_caches(fileName : String) -> String? {
        
        guard let path = yq_caches_path() else {
            return nil
        }
        
        guard let temp = (fileName as NSString).pathComponents.last else {
            return nil
        }
    
        let filePath = (path as NSString).appendingPathComponent(temp)
        return filePath
    }
}

extension JY_Sandbox_Tool {
    /** 获取沙盒Temp文件夹路径 */
    open func yq_temp_path() -> String {
        //  Temp文件夹直接通过调用NSTemporaryDirectory获取
        return NSTemporaryDirectory()
    }
}

extension JY_Sandbox_Tool {
    /**
     传入沙盒文件路径 计算文件大小
     */
    
    /**
            示例:
     if let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first,
        let filePath = NSURL(fileURLWithPath: documentsPath).appendingPathComponent("yourFile.txt")?.path {
         if let size = fileSize(atPath: filePath) {
             print("File size: \(size) bytes")
         }
     }
     */
    open func yq_calue_fileSize(atPath path: String) -> Int? {
        let fileManager = FileManager.default
        
        // 检查文件是否存在
        if fileManager.fileExists(atPath: path) {
            // 尝试获取文件的大小
            do {
                let attributes = try fileManager.attributesOfItem(atPath: path)
                if let size = attributes[.size] as? Int {
                    return size
                }
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        } else {
            print("File does not exist at path: \(path)")
        }
        
        return nil
    }
}

extension JY_Sandbox_Tool {
    /**
     传入沙盒文件夹路径 计算文件夹大小
     */
    
    /**
            示例:
     if let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
         if let size = folderSize(atPath: documentsPath) {
             print("Folder size: \(size) bytes")
         }
     }
     */
    open func yq_calue_folderSize(atPath path: String) -> Int? {
        let fileManager = FileManager.default
        
        // 检查文件夹是否存在
        var isDir: ObjCBool = false
        if fileManager.fileExists(atPath: path, isDirectory: &isDir) && isDir.boolValue {
            // 遍历文件夹
            do {
                let contents = try fileManager.subpathsOfDirectory(atPath: path)
                var folderSize: Int = 0
                
                for content in contents {
                    let fullPath = path.appending("/\(content)")
                    do {
                        let attributes = try fileManager.attributesOfItem(atPath: fullPath)
                        if let size = attributes[.size] as? Int {
                            folderSize += size
                        }
                    } catch {
                        print("Error: \(error.localizedDescription)")
                    }
                }
                
                return folderSize
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        } else {
            print("Folder does not exist at path: \(path)")
        }
        
        return nil
    }
}


//  MARK: 旧方法
extension JY_Sandbox_Tool {

    /// 计算单个文件大小
    ///
    /// - Parameter filePath: 文件全路径
    open func yq_calculate_file_size(filePath : String) -> Float {
        
        //  获取文件管理者
        let fileManager = FileManager.default
        
        //  为了安全，应该判断filePath是否是真的文件全路径
//        assert(fileManager.fileExists(atPath: filePath) != false, "filePath不是完整的全路径")
        
        do {
            /// attributesOfItem只适用于计算单个文件大小
            let fileSize = try fileManager.attributesOfItem(atPath: filePath)[FileAttributeKey.size]
            
            return (fileSize as? Float) ?? 0
            
        } catch {
            print(error)
            return 0
        }
        
    }
    
    /// 计算文件夹大小
    ///
    /// - Parameter filePath: 文件夹全路径
    open func yq_calculate_folder_size(folderPath : String, completion : @escaping (_ fileSize : Float)->()) {
        
        let operation = BlockOperation{ [weak self] in
            
            //            print(Thread.current)
            
            var fileSize : Float = 0.0
            
            //  获取文件管理者
            let fileManager = FileManager.default
            
            //  为了安全，应该判断filePath是否是真的文件夹全路径
            //        assert(fileManager.fileExists(atPath: filePath) != false, "filePath不是完整的全路径")
            
            //  获取文件夹内文件数组
            guard let fileArray = fileManager.subpaths(atPath: folderPath) else {
                return completion(fileSize)
            }
            
            //  遍历文件夹
            for filePath in fileArray {
                
                //  排除.DS文件
                if filePath.hasPrefix(".DS") {
                    continue
                }
                
                //  还应该排除是否为文件夹
                /*
                 // 判断是否文件夹
                 BOOL isDirectory;
                 // 判断文件是否存在,并且判断是否是文件夹
                 BOOL isExist = [mgr fileExistsAtPath:filePath isDirectory:&isDirectory];
                 if (!isExist || isDirectory) continue;
                 */
                
                //  拼接完整路径
                let fileAllPath = (folderPath as NSString).appendingPathComponent(filePath)
                
                //  计算文件大小
                fileSize = fileSize + (self?.yq_calculate_file_size(filePath: fileAllPath) ?? 0)
            }
            
            return completion(fileSize)
        }
        
        let queue = OperationQueue.init()
        queue.addOperation(operation)
    }
    
}

//  MARK: 获取缓存大小
extension JY_Sandbox_Tool{
    /**  获取cache文件夹大小 */
    open func yq_calculate_caches_size(completion : @escaping (_ fileSize : Float)->()) {
        guard let path = yq_caches_path() else {
            completion(0)
            return
        }
        yq_calculate_folder_size(folderPath: path) { (size) in
            completion(size)
        }
    }
    
    /** 获取temp文件夹大小 */
    func yq_calculate_temp_size(completion : @escaping (_ fileSize : Float)->()) {
        yq_calculate_folder_size(folderPath: yq_temp_path()) { (size) in
            completion(size)
        }
    }
    
    /**
     快速删除沙盒缓存
     因为沙盒缓存都是放在cache文件夹下的，所以我们就cache文件夹下的文件即可 */
    open func yq_delete_cache(finishCallBack: (() -> Void)? = nil) {
        guard let path = yq_caches_path() else {
            return
        }
        yq_delete_file_of_folder(folderPath: path, finishCallBack: finishCallBack)
    }
    
    /**
     快速删除temp文件夹沙盒缓存 */
    open func yq_delete_temp(finishCallBack: (() -> Void)? = nil) {
        yq_delete_file_of_folder(folderPath: yq_temp_path(), finishCallBack: finishCallBack)
    }
}

//  MARK: 删除文件
extension JY_Sandbox_Tool {

    /** 删除单个文件 */
    open func yq_delete_file(filePath : String) -> Bool {
        //  获取文件管理者
        let fileManager = FileManager.default
        
        do {
            try fileManager.removeItem(atPath: filePath)
            return true
        } catch  {
            return false
        }
        
    }
    
    /** 删除文件夹下的所有文件 */
    open func yq_delete_file_of_folder(folderPath : String, finishCallBack: (() -> Void)? = nil) {
        //  获取文件管理者
        let fileManager = FileManager.default
        
        //  获取文件夹内文件数组
        guard let fileArray = fileManager.subpaths(atPath: folderPath) else {
            if finishCallBack != nil {
                finishCallBack!()
            }
            return
        }
        
        if fileArray.count <= 0 {
            if finishCallBack != nil {
                finishCallBack!()
            }
        }
        
        DispatchQueue(label: "deleteFile").async { [weak self] in
            //  遍历文件夹
            for (index, filePath) in fileArray.enumerated() {
                //  拼接完整路径
                let fileAllPath = (folderPath as NSString).appendingPathComponent(filePath)
                
                if (self?.yq_delete_file(filePath: fileAllPath) ?? false) {
                    if index == fileArray.count - 1 {
                        if finishCallBack != nil {
                            finishCallBack!()
                        }
                    }
                    continue
                }else{
                    if finishCallBack != nil {
                        finishCallBack!()
                    }
                }
            }
        }
    }
}
