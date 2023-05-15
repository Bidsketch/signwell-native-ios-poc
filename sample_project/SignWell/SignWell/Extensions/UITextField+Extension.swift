//
// SignWell
// iOS Demo
// Andrey Butov, 2023
//


import UIKit


extension UITextField
{
    func addNicerPadding(horizontal: Int = 5, vertical: Int = 20) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: horizontal, height: vertical));
        self.leftView = paddingView;
        self.leftViewMode = .always;
        self.rightView = paddingView;
        self.rightViewMode = .always;
    }
    
    func trimmedSafeText() -> String {
        return self.text?.trim() ?? "";
    }
    
    
    func hasText() -> Bool {
        return !trimmedSafeText().isEmpty;
    }

    func configureForURLInput() {
        self.keyboardType = .URL;
        self.autocapitalizationType = .none;
        self.autocorrectionType = .no;
    }
}
