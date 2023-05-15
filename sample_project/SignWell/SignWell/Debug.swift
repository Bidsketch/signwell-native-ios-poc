//
// SignWell
// iOS Demo
// Created by Andrey Butov on 5/11/23.
//


import Foundation


class Debug
{
    static var _tag = "";

    public class func log(_ object: Any, filePath: String = #file, line: Int = #line, function: String = #function) {
        #if DEBUG
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "HH:mm:ss.SSSS"
        let tag = _tag.isEmpty ? "" : "|\(_tag)| ";
        let file = (filePath as NSString).lastPathComponent;
        Swift.print("\(tag)\(dateFormatter.string(from: Date())) | \(file):(\(line)) | \(function) | \(object)");
        #endif
    }
}
