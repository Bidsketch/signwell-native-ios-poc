//
// SignWell
// iOS Demo
// Andrey Butov, 2023
//


import UIKit


extension CGRect
{
    func top() -> CGFloat {
        return self.origin.y;
    }
    
    
    func bottom() -> CGFloat {
        return self.top() + self.height;
    }
    
    
    func left() -> CGFloat {
        return self.origin.x;
    }
    
    
    func right() -> CGFloat {
        return self.left() + self.width;
    }
}
