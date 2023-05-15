//
// SignWell
// iOS Demo
// Andrey Butov, 2023
//


import UIKit


extension UIViewController
{
    func showAlertDialog ( _ message: String, buttonLabel: String = "OK", onComplete: (() -> Void)? = nil ) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert);
        
        alert.addAction(UIAlertAction(title: buttonLabel, style: .cancel, handler: { action in
            onComplete?();
        }));
        
        self.present(alert, animated: true, completion: nil);
    }
}
