//
// SignWell
// iOS Demo
// Andrey Butov, 2023
//


import UIKit
import WebKit


class WebViewScreen: BaseScreen, UIWebViewDelegate, WKScriptMessageHandler
{
    private var _signingURL = "";
    private let _backBtn = UIButton(type: .system);
    private let _webView = WKWebView();


    convenience init(signingURL: String) {
        self.init();
        _signingURL = signingURL;
    }

    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        
        _backBtn.setTitle("Back", for: .normal);
        _backBtn.addTarget(self, action: #selector(onBackBtnClicked), for: .touchUpInside);
        self.view.addSubview(_backBtn);

        _webView.showBorder(color: .lightGray);
        _webView.configuration.preferences.javaScriptEnabled = true

        // receive JavaScript messages
        _webView.configuration.userContentController.add(self, name: "jsMessageHandler")

        self.view.addSubview(_webView);

        // Load the template page
        guard let url = Bundle.main.url(forResource: "page", withExtension: "html") else { return }
        let htmlData = try! Data(contentsOf: url)
        var htmlString = String(decoding: htmlData, as: UTF8.self);
        
        htmlString = htmlString.replacingOccurrences(of: "$SIGNING_URL$", with: _signingURL);
        
        Debug.log(htmlString);
        
        _webView.loadHTMLString(htmlString, baseURL: url);
        // _webView.load(htmlData, mimeType: "text/html", characterEncodingName: "UTF-8", baseURL: url)
    }
    
    
    
    override func viewWillLayoutSubviews()
    {
        super.viewWillLayoutSubviews();
        
        let padding: CGFloat = 20;
        let controlWidth = safeArea().width - (padding * 2);

        _backBtn.sizeToFit();
        _backBtn.setPosition(padding, self.safeArea().top() + padding);
        
        _webView.setWidth(controlWidth);
        _webView.centerHorizontallyWithinParent();
        _webView.setY(_backBtn.bottom() + 40);
        _webView.setHeight(self.safeArea().bottom() - _webView.y());
    }
    

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "jsMessageHandler", let messageBody = message.body as? String {
            if ( messageBody == "signing_completed" ) {
                self.showAlertDialog("Your document has been signed.") {
                    self.dismiss(animated: true);
                }
            }
            Debug.log("received message from JavaScript: \(messageBody)");
        }
    }
    
    
    @objc private func onBackBtnClicked() {
        self.dismiss(animated: true);
    }
}
