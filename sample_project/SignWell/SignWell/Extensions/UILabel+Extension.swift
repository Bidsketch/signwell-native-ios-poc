//
// SignWell
// iOS Demo
// Andrey Butov, 2023
//


import UIKit


extension UILabel
{
    convenience init(text: String = "", textColor: UIColor = .black, font: UIFont = .systemFont(ofSize: UIFont.systemFontSize)) {
        self.init(frame: .zero);
        self.text = text;
        self.textColor = textColor;
        self.font = font;
    }

    func sizeMultilineLabelWithMaxWidth(_ maxWidth: CGFloat) {
        self.setSize(0, 0);
        self.sizeToFit();
        if ( isMultiline() ) {
            if ( self.width() > maxWidth ) {
                self.setWidth(maxWidth);
                self.sizeToFit();
            }
        } else {
            self.sizeToFitWithMaxWidth(maxWidth);
        }
    }

    func isMultiline() -> Bool {
        return self.numberOfLines == 0;
    }
}
