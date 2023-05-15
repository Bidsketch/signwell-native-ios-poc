//
// SignWell
// iOS Demo
// Andrey Butov, 2023
//


import UIKit
import TPKeyboardAvoidingSwift


class HomeScreen: BaseScreen, UIDocumentPickerDelegate
{
    let _scrollView = TPKeyboardAvoidingScrollView();
    
    let _logo = UIImageView(image: UIImage(named: "logo"));
    
    let _apiFieldTitle = UILabel(text: "SignWell API Key", textColor: .darkGray, font: FONT_BOLD);
    let _apiField = UITextField(backgroundColor: COLOR_LIGHT_GRAY_1);
    
    let _localDocumentTitle = UILabel(text: "Use a Local Document", textColor: .darkGray, font: FONT_BOLD);
    let _localSourceFileSwitch = UISwitch();
    let _selectFileBtn = UIButton(type: .custom);
    let _sourceURLField = UITextField(backgroundColor: COLOR_LIGHT_GRAY_1);
    
    let _selectedLocalFileName = UILabel(text: "", textColor: .darkGray, font: FONT_BOLD);
    var _fileBase64 = "";

    let _continueBtn = UIButton(type: .custom);

    
    override func viewDidLoad()
    {
        super.viewDidLoad();

        _scrollView.allowForPlacementOfChildrenOutsideSafeArea();
        _scrollView.showsVerticalScrollIndicator = false;
        self.view.addSubview(_scrollView);
        
        _logo.contentMode = .scaleAspectFit;
        _scrollView.addSubview(_logo);

        _apiField.adjustsFontSizeToFitWidth = true;
        _scrollView.addSubview(_apiFieldTitle);

        _apiField.text = SIGNWELL_API_KEY;
        _apiField.placeholder = "Your SignWell API key";
        _apiField.setRoundedCorners(radius: 4);
        _apiField.addNicerPadding(horizontal: 5, vertical: 5);
        _apiField.font = FONT_REGULAR;
        _scrollView.addSubview(_apiField);

        _scrollView.addSubview(_localDocumentTitle);

        _localSourceFileSwitch.setOn(true, animated: false);
        _localSourceFileSwitch.addTarget(self, action: #selector(onLocalFileSwitchToggled), for: .valueChanged);
        _localSourceFileSwitch.onTintColor = COLOR_SIGNWELL_BLUE;
        _scrollView.addSubview(_localSourceFileSwitch);
        
        _sourceURLField.placeholder = "Document URL";
        _sourceURLField.configureForURLInput();
        _sourceURLField.setRoundedCorners(radius: 4);
        _sourceURLField.addNicerPadding(horizontal: 5, vertical: 5);
        _sourceURLField.font = FONT_REGULAR;
        _scrollView.addSubview(_sourceURLField);
        
        _selectFileBtn.setTitle("Select a File ...", for: .normal);
        _selectFileBtn.titleLabel?.font = FONT_BOLD;
        _selectFileBtn.backgroundColor = COLOR_SIGNWELL_BLUE;
        _selectFileBtn.setRoundedCorners(radius: 4)
        _selectFileBtn.showBorder(color: .lightGray)
        _selectFileBtn.setTitleColor(.white, for: .normal);
        _selectFileBtn.addTarget(self, action: #selector(onSelectFileBtnClicked), for: .touchUpInside);
        _scrollView.addSubview(_selectFileBtn);

        _selectedLocalFileName.adjustsFontSizeToFitWidth = true;
        _selectedLocalFileName.text = "No local file selected.";
        _scrollView.addSubview(_selectedLocalFileName);
        
        _continueBtn.setTitle("Continue", for: .normal);
        _continueBtn.titleLabel?.font = FONT_BOLD;
        _continueBtn.backgroundColor = COLOR_SIGNWELL_BLUE;
        _continueBtn.setRoundedCorners(radius: 4);
        _continueBtn.showBorder(color: .lightGray);
        _continueBtn.setTitleColor(.white, for: .normal);
        _continueBtn.addTarget(self, action: #selector(onContinueBtnClicked), for: .touchUpInside);
        _scrollView.addSubview(_continueBtn);
    }
    
    
    override func viewWillLayoutSubviews()
    {
        super.viewWillLayoutSubviews();
        
        _scrollView.setSameSizeAs(self.view);
        
        let padding: CGFloat = 20;
        let controlWidth = safeArea().width - (padding * 2);
        let verticalSpacing: CGFloat = 40;

        _logo.setSize(80, 80);
        _logo.centerHorizontallyWithinParent();
        _logo.setY(safeArea().top() + padding);

        _apiFieldTitle.font = FONT_BOLD;
        _apiFieldTitle.sizeToFitWithMaxWidth(controlWidth);
        _apiFieldTitle.setPosition(padding, _logo.bottom() + verticalSpacing);

        _apiField.setSize(controlWidth, 50);
        _apiField.centerHorizontallyWithinParent();
        _apiField.setY(_apiFieldTitle.bottom() + 5);
        
        _localDocumentTitle.sizeToFit();
        _localDocumentTitle.setPosition(padding, _apiField.bottom() + verticalSpacing);
        
        _localSourceFileSwitch.sizeToFit();
        _localSourceFileSwitch.rightAlignWithinParent(gap: padding);
        _localSourceFileSwitch.centerVerticallyWithRespectTo(_localDocumentTitle);

        if ( _selectFileBtn.visible() ) {
            _selectFileBtn.setSize(controlWidth, 50);
            _selectFileBtn.centerHorizontallyWithinParent();
            _selectFileBtn.setY(_localSourceFileSwitch.bottom() + 10);
            _selectedLocalFileName.sizeToFitWithMaxWidth(controlWidth);
            _selectedLocalFileName.centerHorizontallyWithinParent();
            _selectedLocalFileName.setPosition(padding, _selectFileBtn.bottom() + 5);
        } else if ( _sourceURLField.visible() ) {
            _sourceURLField.setSize(controlWidth, 50);
            _sourceURLField.centerHorizontallyWithinParent();
            _sourceURLField.setY(_localSourceFileSwitch.bottom() + 10);
        }
        
        _selectFileBtn.setSize(controlWidth, 50);
        _selectFileBtn.centerHorizontallyWithinParent();
        _selectFileBtn.setY(_localSourceFileSwitch.bottom() + 10);
        
        _continueBtn.setSize(controlWidth, 50);
        _continueBtn.centerHorizontallyWithinParent();
        _continueBtn.setY(safeArea().bottom() - (_continueBtn.height() + 10));

        _scrollView.adjustToFitChildren();
    }
    
    
    
    @objc private func onSelectFileBtnClicked() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.item"], in: .import)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
    }


    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if ( urls.isEmpty ) {
            return;
        }
        let selectedFileURL = urls[0]
        Debug.log("selected file: \(selectedFileURL)");
        
        do {
            let fileData = try Data(contentsOf: selectedFileURL)
            _fileBase64 = fileData.base64EncodedString();
            _selectedLocalFileName.text = selectedFileURL.lastPathComponent;
        } catch {
            showAlertDialog("Could not get base64 data from selected file: \(error.localizedDescription)")
        }
        self.view.refresh();
    }

    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        // Handle the user's cancellation
    }
    
    
    @objc private func onContinueBtnClicked() {
        if ( _apiField.trimmedSafeText().isEmpty ) {
            showAlertDialog("Please enter your SignWell API Key");
            return;
        }
        if ( _localSourceFileSwitch.isOn && _fileBase64.isEmpty ) {
            showAlertDialog("Please select a file.");
            return;
        }
        else if ( !_localSourceFileSwitch.isOn && _sourceURLField.trimmedSafeText().isEmpty ) {
            showAlertDialog("Please enter the document URL.");
            return;
        }
        let req = _localSourceFileSwitch.isOn ?
            CreateDocumentRequest.withLocalFile(apiKey: _apiField.text!.trim(), fileBase64: _fileBase64) :
            CreateDocumentRequest.withRemoteFile(apiKey: _apiField.text!.trim(), fileURL: _sourceURLField.trimmedSafeText());
            
        showProgressOverlay();
        
        req.execute { response in
            self.dismissProgressOverlay(onComplete: {
                let response = response as! CreateDocumentResponse;
                if ( !response._successful ) {
                    self.showAlertDialog("Unable to create SignWell document from source file.");
                } else {
                    self.show(WebViewScreen(signingURL: response._signingURL) , sender: self);
                }
            });
        }
    }
    
    
    
    @objc private func onLocalFileSwitchToggled() {
        _selectFileBtn.setVisible(_localSourceFileSwitch.isOn);
        _selectedLocalFileName.setVisible(_selectFileBtn.visible());
        _sourceURLField.setVisible(!_selectFileBtn.visible());
        self.view.refresh()
    }
}
