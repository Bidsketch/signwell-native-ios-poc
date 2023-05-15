//
// SignWell
// iOS Demo
// Andrey Butov, 2023
//


import UIKit



extension UIScrollView
{
    func allowForPlacementOfChildrenOutsideSafeArea() {
        self.contentInsetAdjustmentBehavior = .never;
    }

    func adjustToFitChildren(additionalBottomSpacing: CGFloat = 0) {
        self.contentSize = CGSize(width: self.width(), height: heightOfChildren() + additionalBottomSpacing);
    }
}
