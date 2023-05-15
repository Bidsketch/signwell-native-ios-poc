//
// SignWell
// iOS Demo
// Andrey Butov, 2023
//


import UIKit


class CreateDocumentRequest: APIRequest
{
    private var _apiKey = "";
    private var _fileBase64 = "";
    private var _remoteFileURL = "";
    
    
    static func withLocalFile(apiKey: String, fileBase64: String) -> CreateDocumentRequest {
        let req = CreateDocumentRequest();
        req._apiKey = apiKey;
        req._fileBase64 = fileBase64;
        return req;
    }
    
    
    static func withRemoteFile(apiKey: String, fileURL: String) -> CreateDocumentRequest {
        let req = CreateDocumentRequest();
        req._apiKey = apiKey;
        req._remoteFileURL = fileURL;
        return req;
    }
    
    
    override func execute()
    {
        var fileSpec = [
            "name": "file_1.pdf"
        ];
        
        if ( !_remoteFileURL.isEmpty ) {
            fileSpec["file_url"] = _remoteFileURL;
        } else if ( !_fileBase64.isEmpty ) {
            fileSpec["file_base64"] = _fileBase64;
        } else {
            fatalError("CreateDocumentRequest does not contain either a file_url or a file_base64");
        }
    
        post(
            endpoint: "documents",
            data: [
                "name" : "Sample Document",
                "embedded_signing": true,
                "draft": false,
                "test_mode": true,
                "reminders": false,
                "files": [ fileSpec ],
                "recipients": [
                    [
                        "id" : "1",
                        "name": "John Doe",
                        "email": "user@host.com"
                    ],
                ],
                "fields": [[
                    [
                        "x": 200,
                        "y": 550,
                        "page": 1,
                        "recipient_id": "1",
                        "required": true,
                        "type": "signature",
                    ],
                    [
                        "x": 110,
                        "y": 550,
                        "page": 1,
                        "recipient_id": "1",
                        "required": true,
                        "type": "date",
                        "date_format": "Month DD, YYYY",
                        "lock_sign_date": false
                    ],
                ]],
            ],
            apiKey: _apiKey
        );
    }
    
    
    override func onRequestComplete(_ responseData: NSDictionary?, statusCode: Int = 0, haveInternetAccess: Bool = true) {
        _response = CreateDocumentResponse(self);
        _response?.processResponse(responseData, statusCode: statusCode);
        callCompletionHandlerWithResponse();
    }
}
