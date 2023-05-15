//
// SignWell
// iOS Demo
// Andrey Butov, 2023
//


import Foundation
import Alamofire



class APIRequest
{
    var _response: APIResponse? = nil;
    var _completionHandler: ((APIResponse) -> Void)? = nil;
    var _alamofireRequest: DataRequest?;

    
    
    init()
    {
    }
    
    
    
    func cancel()
    {
        if let req = _alamofireRequest {
            Debug.log("Cancelling request.");
            req.cancel();
        }
    }
    
    
    
    func cancelled() -> Bool
    {
        return _alamofireRequest?.isCancelled ?? false;
    }


    
    func resubmit()
    {
        execute();
    }
    
    
    
    func execute ( completionHandler: @escaping (APIResponse) -> Void )
    {
        _completionHandler = completionHandler;
        execute();
    }
    
    
    
    func callCompletionHandlerWithResponse()
    {
        _completionHandler?(_response!);
    }
    
    
    
    func get ( server: String = SERVER_BASE_URL, endpoint: String, apiKey: String = "" )
    {
        sendRequest(method: .get, endpoint: endpoint, apiKey: apiKey);
    }


    
    func post ( server: String = SERVER_BASE_URL, endpoint: String, data: [String: Any]? = nil, apiKey: String = "" )
    {
        sendRequest(server: server, method: .post, endpoint: endpoint, data: data, apiKey: apiKey);
    }
    
    
    func put ( server: String = SERVER_BASE_URL, endpoint: String, data: [String: Any]? = nil, apiKey: String = "" )
    {
        sendRequest(server: server, method: .put, endpoint: endpoint, data: data, apiKey: apiKey);
    }
    
    
    private func sendRequest ( server: String = SERVER_BASE_URL, method: HTTPMethod, endpoint: String, data: [String: Any]? = nil, apiKey: String = "" )
    {
        AF.request("\(server)/\(endpoint)", method: method, parameters: data, encoding: JSONEncoding.default, headers: commonHeaders(apiKey: apiKey))
            .responseJSON { response in
                let statusCode = response.response?.statusCode ?? 0;
                
                // Debug.log("ENDPOINT \(endpoint) RETURNED STATUS CODE \(statusCode)");
                
                switch ( response.result )
                {
                    case .success(let json):
                        self.onRequestComplete(json as? NSDictionary, statusCode: statusCode)

                    case .failure(let error):
                        Debug.log(error);
                        self.onRequestComplete(nil, statusCode: statusCode);
                }
        }
    }



    func commonHeaders(apiKey: String = "") -> HTTPHeaders
    {
        var headers : HTTPHeaders = [
            .accept("application/json"),
            .contentType("application/json")
        ];

        if ( !apiKey.isEmpty ) {
            headers.add(name: "X-Api-Key", value: apiKey);
        }

        return headers;
    }
    
    
    
    func execute()
    {
        // override and implement
    }


    
    func onRequestComplete(_ responseData : NSDictionary?, statusCode: Int = 0, haveInternetAccess: Bool = true)
    {
        // override and implement
    }
}
