//
// SignWell
// iOS Demo
// Andrey Butov, 2023
//


import UIKit
import JGProgressHUD


class BaseScreen: UIViewController
{
    private let _progressOverlay = JGProgressHUD(style: .dark);
    var _showTabBar = true;


    required init?(coder: NSCoder)
    {
        super.init(coder: coder);
        commonInit();
    }
    
    
    init()
    {
        super.init(nibName: nil, bundle: nil);
        self.commonInit();
    }

    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
        self.commonInit();
    }


    func commonInit()
    {
        // when show() is called on a BaseScreen, show it as full-screen,
        // instead of the dismissable card-view introduced in iOS 13.
        modalPresentationStyle = .fullScreen;
    }


    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white;

        self.navigationController?.setNavigationBarHidden(true, animated: false);
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
    }
    
    
    
    func contentArea() -> CGRect
    {
        return self.safeArea();
    }



    func safeArea() -> CGRect
    {
        // WARNING: this might return zero rect when called from viewDidLoad.
        // It should be called from viewDidLayoutSubviews or layoutSubviews.
        return self.view.safeArea();
    }
    
    
    
    func showProgressOverlay ( _ msg: String? = nil )
    {
        _progressOverlay.textLabel.text = msg != nil ? msg : "";
        _progressOverlay.indicatorView = JGProgressHUDIndeterminateIndicatorView();
        _progressOverlay.show(in: self.view, animated: true);
    }
    
    
    
    func dismissProgressOverlay()
    {
        _progressOverlay.dismiss(animated: true);
    }



    func dismissProgressOverlay ( onComplete: (() -> Void)? = nil )
    {
        if ( _progressOverlay.isVisible ) {
            _progressOverlay.dismiss(afterDelay: 0, animated: true, completion: onComplete);
        } else {
            onComplete?();
        }
    }

    
    func changeProgressOverlayToSuccessMessageAndDismiss(_ msg: String)
    {
        _progressOverlay.textLabel.text = msg;
        _progressOverlay.indicatorView = JGProgressHUDSuccessIndicatorView();
        _progressOverlay.dismiss(afterDelay: 1.0, animated: true);
    }
    
    
    
    func changeProgressOverlayToErrorMessageAndDismiss(_ msg: String)
    {
        _progressOverlay.textLabel.text = msg;
        _progressOverlay.indicatorView = JGProgressHUDErrorIndicatorView();
        let delay = msg.count > 30 ? 3.0 : 1.0;
        _progressOverlay.dismiss(afterDelay: delay, animated: true);
    }
}
