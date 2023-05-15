//
// SignWell
// iOS Demo
// Andrey Butov, 2023
//


import Foundation


class APIResponse
{
    var _successful:Bool = false;
    var _originalRequest: APIRequest?;
    var _errorMessageFromServer = "";
    var _statusCode = 0;
    
    
    init(_ originalRequest : APIRequest?) {
        _originalRequest = originalRequest;
        _originalRequest?._response = self;
        _successful = false;
    }
    
    
    func processResponse ( _ responseData : NSDictionary?, statusCode: Int ) {
        _statusCode = statusCode;
    
        if ( responseData == nil ) {
            _successful = false;
            return;
        }

        processSpecificResponse ( responseData ?? NSDictionary() );
    }
    
    
    func processSpecificResponse ( _ responseData : NSDictionary ) {
        // override and implement
    }
}
