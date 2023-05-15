//
// SignWell
// iOS Demo
// Andrey Butov, 2023
//


import Foundation


class CreateDocumentResponse: APIResponse {

    var _signingURL = "";

    override func processSpecificResponse(_ responseData: NSDictionary) {
        _successful = (_statusCode == 200 || _statusCode == 201);
        if ( _successful ) {
            guard let recipients = responseData.arrayValue("recipients") else {
                _successful = false;
                return;
            }
            guard let firstRecipient = recipients.first else {
                _successful = false;
                return;
            }
            guard let signingURL = (firstRecipient as? NSDictionary)?.stringValueForKey("embedded_signing_url") else {
                _successful = false;
                return;
            }
            _signingURL = signingURL;
            _successful = !_signingURL.isEmpty;
            Debug.log("signing URL: \(_signingURL)")
        }
    }
}
