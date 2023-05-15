//
// SignWell
// iOS Demo
// Andrey Butov, 2023
//



import UIKit



extension NSDictionary
{
    static func fromJSONString ( _ jsonStr:String? ) -> NSDictionary?
    {
        if ( !String.hasValue(jsonStr) ) {
            return nil;
        }
        
        guard let data = jsonStr?.data(using: .utf8) else {
            return nil;
        }
        
        do {
            return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary;
        } catch {
            Debug.log(error);
        }
        
        return nil;
    }
    
    
    func hasValueFor(key: String) -> Bool {
        return self[key] != nil;
    }
    
    
    func toJSONString() -> String
    {
        do
        {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .withoutEscapingSlashes);
            return String.safe(String(data: jsonData, encoding: .utf8));
        }
        catch
        {
            Debug.log(error);
        }
        
        return "";
    }


    func boolValueForKey ( _ key : String? ) -> Bool
    {
        if ( key == nil ) {
            return false;
        }
        
        let num = self.numberValueForKey(key);
        
        if ( num != nil ) {
            return num!.boolValue;
        }
        
        return self.stringValueForKey(key).isEqualToStringIgnoringCase("true");
    }


    
    func numberValueForKey ( _ key : String?, _ defaultVal : NSNumber ) -> NSNumber
    {
        let n = self.numberValueForKey(key);
        
        return n != nil ? n! : defaultVal;
    }
    
    
    
    func numberValueForKey ( _ key : String? ) -> NSNumber?
    {
        if ( key == nil ) {
            return nil;
        }
    
        let obj : Any? = object(forKey: key!);
        if ( obj == nil ) {
            return nil;
        }
        
        if obj is NSNumber {
            return obj as? NSNumber;
        }
        
        if ( obj is String ) {
            let formatter = NumberFormatter();
            // Important. Otherwise, the number formatter will fail in countries where
            // the decimal separator is a comma.
            formatter.locale = Locale(identifier: "en_US");
            formatter.numberStyle = .decimal;
            return formatter.number(from: obj as! String);
        }
        
        return nil;
    }
    
    
    
    func stringValueForKey ( _ key : String? ) -> String? {
        return stringValueForKey(key, convertNumbersToString:true);
    }
    
    
    
    func stringValueForKey ( _ key : String?, convertNumbersToString : Bool = true ) -> String {
        if ( key == nil ) {
            return "";
        }
        
        let obj : Any? = object(forKey: key!);
        if ( obj == nil ) {
            return "";
        }
        
        if ( obj is String ) {
            return obj as! String;
        }
        
        if ( obj is NSNumber ) {
            return (obj as! NSNumber).stringValue;
        }
        
        return "";
    }
    
    
    
    func arrayValue ( _ key: String? ) -> [Any]?
    {
        if ( !String.hasValue(key) ) {
            return nil;
        }
        
        guard let obj = object(forKey: key!) else {
            return nil;
        }
        
        if ( obj is NSArray ) {
            return (obj as? NSArray) as? [Any];
        }
        
        if ( obj is NSDictionary ) {
            return [ obj ];
        }
        
        if ( obj is String ) {
            let dictionaryObj = NSDictionary.fromJSONString(obj as? String) ?? NSDictionary();
            return [ dictionaryObj ];
        }
        
        return nil;
    }
    
    
    
    func arrayOfNSDictionaryValues ( _ key: String? ) -> [NSDictionary]? {
        guard let arrayOfAnyValues = self.arrayValue(key) else {
            return [];
        }
        return (arrayOfAnyValues.filter { ($0 as? NSDictionary) != nil } as! [NSDictionary]);
    }
    
    
    
    func stringArray ( _ key : String? ) -> [String] {
        guard let arrayValue = self.arrayValue(key) else {
            return [String]();
        }
        
        var strings = [String]();

        arrayValue.forEach { obj in
            if ( obj is String ) {
                strings.append(obj as! String);
            } else if ( obj is NSNumber ) {
                strings.append((obj as! NSNumber).stringValue);
            }
        }
        
        return strings;
    }
    
    
    
    func dictionaryValue ( _ key : String? ) -> NSDictionary? {
        if ( !String.hasValue(key) ) {
            return nil;
        }
        guard let obj = object(forKey: key!) else {
            return nil;
        }
        if ( obj is NSDictionary ) {
            return obj as? NSDictionary;
        }
        if ( obj is String ) {
            return NSDictionary.fromJSONString(obj as? String);
        }
        else if let arr = obj as? NSArray, arr.count > 0 {
            return arr.firstObject as? NSDictionary;
        }
        return nil;
    }
}
