//
// SignWell
// iOS Demo
// Andrey Butov, 2023
//


import UIKit


extension String
{
    static func safe(_ str: String?) -> String {
        return str != nil ? str! : "";
    }

    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines);
	}

    static func hasValue(_ str:String?) -> Bool {
        return str != nil && !(str!.isEmpty);
    }

    func isEqualToStringIgnoringCase ( _ str : String? ) -> Bool {
        return str != nil && self.caseInsensitiveCompare(str!) == .orderedSame;
    }
}
