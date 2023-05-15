//
// SignWell
// iOS Demo
// Andrey Butov, 2023
//



import UIKit



extension UIView
{
    convenience init ( backgroundColor: UIColor ) {
        self.init(frame: .zero);
        self.backgroundColor = backgroundColor;
    }

    func setRoundedCorners(radius: CGFloat = 5.0) {
        self.layer.cornerRadius = radius;
        self.layer.masksToBounds = true;
        self.clipsToBounds = true;
    }

    func showBorder(color: UIColor = .black, width: CGFloat = 1.0) {
        self.layer.borderWidth = width;
        self.layer.borderColor = color.cgColor;
        self.layer.masksToBounds = true;
    }

	func setX(_ x:CGFloat) {
		self.frame = CGRect(x: x, y: self.y(), width: self.width(), height: self.height());
	}

	func setY(_ y:CGFloat) {
		self.frame = CGRect(x: self.x(), y: y, width: self.width(), height: self.height());
	}

	func setPosition(_ x:CGFloat, _ y:CGFloat) {
		self.frame = CGRect(x: x, y: y, width: self.width(), height: self.height());
	}

	func x() -> CGFloat {
		return self.frame.origin.x;
	}
	
	func y() -> CGFloat {
		return self.frame.origin.y;
	}

    func width() -> CGFloat {
        return self.bounds.size.width
	}
	
	func height() -> CGFloat {
		return self.bounds.size.height;
	}

	func setSize(_ width:CGFloat, _ height:CGFloat) {
		self.frame = CGRect(x: self.x(), y: self.y(), width: width, height: height);
	}

    func sizeToFitWithMaxWidth(_ maxWidth: CGFloat) {
        if ( self.isKind(of: UILabel.self) && (self as! UILabel).isMultiline() ) {
            (self as! UILabel).sizeMultilineLabelWithMaxWidth(maxWidth);
            return;
        }
        
        self.sizeToFit();
        self.setWidth(min(self.width(), maxWidth));
    }
	
	func setWidth(_ width: CGFloat) {
		self.frame = CGRect(x: self.x(), y: self.y(), width: width, height: self.height());
	}
 
    func setHeight(_ height: CGFloat) {
		self.frame = CGRect(x: self.x(), y: self.y(), width: self.width(), height: height);
	}

	func centerHorizontallyWithin(_ outerView: UIView) {
		self.setX(self.centerXWithin(outerView));
	}
 
    func centerHorizontallyWithinParent() {
        if let parent = superview {
            centerHorizontallyWithin(parent);
        }
    }

	func centerXWithin(_ outerView:UIView) -> CGFloat {
		return (outerView.width() - self.width()) / 2;
	}

	func bottom() -> CGFloat {
		return self.y() + self.height();
	}

    func safeArea() -> CGRect {
        let safeAreaInsets = self.safeAreaInsets;
        return CGRect(
            x: safeAreaInsets.left,
            y: safeAreaInsets.top,
            width: self.width() - (safeAreaInsets.left + safeAreaInsets.right),
            height: self.height() - (safeAreaInsets.top + safeAreaInsets.bottom));
    }

    func visible() -> Bool {
        return !self.isHidden;
    }
    
    func setVisible(_ visible: Bool) {
        self.isHidden = !visible;
    }

    func setSameSizeAs(_ anotherView: UIView) {
        self.setSize(anotherView.width(), anotherView.height());
    }

    func heightOfChildren(_ visibleOnly: Bool = true) -> CGFloat {
        var heightOfChildren: CGFloat = 0;
        self.subviews.forEach { child in
            if ( !visibleOnly || child.visible() ) {
                heightOfChildren = max(heightOfChildren, child.bottom());
            }
        }
        return heightOfChildren;
    }

    func rightAlignWithinParent(gap: CGFloat = 0) {
        if let parent = superview {
            rightAlignWithin(parent, gap);
        }
    }
    
    func rightAlignWithin(_ parentView: UIView, _ gap: CGFloat = 0) {
        self.rightAlignWithin(parentView.width(), gap);
    }
    
    func rightAlignWithin(_ width: CGFloat, _ gap: CGFloat = 0) {
        self.setX(width - (self.width() + gap));
    }

    func centerVerticallyWithinParent() {
        if let parent = superview {
            centerVerticallyWithin(parent);
        }
    }

    func centerVerticallyWithin(_ outerView: UIView)
    {
        self.setY(self.centerYWithin(outerView));
    }
    
    func centerYWithin(_ outerView: UIView) -> CGFloat {
        return (outerView.height() - self.height()) / 2;
    }
    
    func centerVerticallyWithRespectTo(_ anotherView: UIView) {
        self.center = CGPoint(x: self.center.x, y: anotherView.center.y);
    }

    func refresh() {
        setNeedsLayout();
        layoutIfNeeded();
    }
}
