# SignWell iOS Demo

## Introduction

This project demonstrates how to integrate the [SignWell](https://signwell.com) document signing functionality into your native iOS app.

You will find a fully-functional sample iOS app, written in Swift, in the **sample_project** directory.

This document describes the implementation of the sample project, and provides a comprehensive overview of what's available to you while integrating SignWell into your own iOS apps.  

## The Sample iOS project

The sample project included in **sample_project** is an example integration of SignWell functionality in a native iOS app.

The project implements the [SignWell embedding API](https://developers.signwell.com/reference/embedded-signing), and demonstrates how to embed the SignWell JavaScript widget into a native iOS app, allowing the user to electronically sign a document.

The app does this in two steps:

1. Creates a SignWell document from either a local file, or from a specified URL.
2. Presents that document for the user to sign.

### Your SignWell API key

Prior to building and running the app, you can specify your SignWell API key in **Common.swift**

`let SIGNWELL_API_KEY = "<Your SignWell API Key>";`

You can find your SignWell API key in the [settings section of your SignWell account](https://www.signwell.com/app/settings/api).

In the app, this API key appears in an editable `UITextField`, so you can change it at runtime as needed. You can find this code in the **HomeScreen** class.

![Home Screen](./github_resources/screenshot_home_screen_1.png)

### Selecting a document source

After specifying the API key, the next step is to decide whether to use a local file or a URL for the source document. 

This depends on the needs of your application. If you're allowing your users to select and sign a document from their device, or if you're bundling a document with your application, you can choose to use a local document for signing. If you're providing documents from a server, you can choose to use a document URL as the source.

The SignWell API supports both options, and the sample project allow you to either select a local file, or to enter a URL of a remote file.

If you need a sample PDF document to use for testing, you can grab one [here](./github_resources/sample_document.pdf).

[![Sample PDF document](./github_resources/sample_pdf_document.png)](./github_resources/sample_document.pdf)

You can either download this onto your iOS device, for testing the local file upload functionality, or upload it to a server to test the remote URL functionality.

### Creating the SignWell document

To create a document, we use the [documents](https://developers.signwell.com/reference/post_api-v1-documents) endpoint of the SignWell embedding API.

#### The request

For API authentication, our API key is passed in as the value for the `X-Api-Key` header, in every request sent to the SignWell API. In the sample project, you can find this in the `commonHeaders` method of the **APIRequest** class.

The sample project uses the popular [Alamofire](https://github.com/Alamofire/Alamofire) networking library to make API calls. Of course, you are free to use whatever method works best for you.

The **CreateDocumentRequest** class populates all of the required and some of the optional fields of the **documents** endpoint. While you can refer to the specifics in the source code and the [SignWell API documentation](https://developers.signwell.com/reference/post_api-v1-documents), we will cover some of the notable ones here.

	{
		"test_mode": true
	}	


Setting `test_mode` to true allows us to test the app without the calls counting against our API billing.

	{
		"files": [
			{
				"name": "file_1.pdf"
				"file_base64": _fileBase64
			},
		],
	}

or ...

	{
		"files": [
			{
				"name": "file_1.pdf"
				"file_url": "https://someserver.com/somefile.pdf"
			},
		],
	}
	
The `files` parameter allows us to pass in multiple source documents from which to create a SignWell document. 

In the sample project, we only provide one source file. If we chose to use a locally-selected file, we pass in the base64-encoded file data as the `file_base64` parameter to the API. If we chose to use a remote URL for the source document, we pass that URL into the `file_url` parameter instead.

	
	{
		"recipients": [
	        {
	            "id" : "1",
	            "name": "John Doe",
	            "email": "user@host.com"
	        },
	    ],
	}

The `recipients` array specifies a list of people that must complete and/or sign the document. The SignWell API provides a multitude of options on how to specify these recipients. In the sample project, we just provide an identifier, a name, and an email address of a single placeholder recipient.

	{
		"fields": [[
		    {
		        "x": 200,
		        "y": 550,
		        "page": 1,
		        "recipient_id": "1",
		        "required": true,
		        "type": "signature",
		    },
		    {
		        "x": 110,
		        "y": 550,
		        "page": 1,
		        "recipient_id": "1",
		        "required": true,
		        "type": "date",
		        "date_format": "Month DD, YYYY",
		        "lock_sign_date": false
		    },
		]], 
	}
	
The `fields` parameter defines the fields to be placed in the document, for collecting data or signatures from the recipient. 	

In the sample project, we request that two fields be placed in the document; a **signature** field, and a **date** field. Both fields are marked as **required**, and the recipient we defined earlier is specified here as the target recipient from whom we will collect the data. We also specify the placement position, in the resulting document, for each field. 

Once again, the [SignWell API](https://developers.signwell.com/reference/post_api-v1-documents) provides a multitude of options when defining the presentation and behavior of the data fields.

### The response

Once **CreateDocumentRequest** makes a POST API call to the [documents](https://developers.signwell.com/reference/post_api-v1-documents) endpoint, the SignWell API returns some data. In the sample project, the response is handled in the **CreateDocumentResponse** class. 

In the API response, the data we're looking for is in the `embedding_signing_url` field. In the response data, the `embedding_signing_url` field is contained within each of the items of the `recipients` array. The **CreateDocumentResponse** class contains example code that parses out the data we need.

Once we have the `embedding_signing_url` (the **signing URL**), we are ready to present the document for signing.

### Presenting the Document

To present the document to the user, we will be using a standard `WKWebView`. We provide the `WKWebView` with the **signing URL** (`embedding_signing_url`), which we obtained from the response to the SignWell API call.

In the sample project, all of this is done in the **WebViewScreen** class.

#### Rendering the document

We're not actually going to tell the `WKWebView` to render the **signing URL** directly. 

Instead, we're going to load a pre-made HTML page, containing some boilerplate HTML code, and a JavaScript snippet that makes another call to the SignWell API, asking it to render the document for us.

In the project, this HTML page is included in the application bundle. You can find it in **assets/page.html**.

We will go over the contents of the HTML page here.


	<!DOCTYPE html>
	<html>
		<head>
			<title>SignWell iOS Demo</title>
			<script type="text/javascript" src="https://static.signwell.com/assets/embedded.js"></script>
	   	</head>
		  
	    <body>
	    	<script>
	    	var signWellEmbed = new SignWellEmbed({
				url: '$SIGNING_URL$',
				events: {
					completed: e => {
						webkit.messageHandlers.jsMessageHandler.postMessage("signing_completed");
          			}
      			}
			})
	    	signWellEmbed.open()
	    	</script>	    
		</body>
	</html>


First, the `<script>` tag in the `<head>` section, at the top of the HTML page, loads the SignWell JavaScript snippet, which is responsible for all the heavy-lifting of rendering the document and providing the user with the controls needed to sign and fill-out the various data fields.

The `<body>` section of the document contains the main JavaScript snippet, which tells the SignWell snippet what to do. Let's quickly look at this ...


	url: '$SIGNING_URL$',

The url param tells the SignWell widget which document to render. The `'$SIGNING_URL$'` token is a placeholder which we will replace with the **signing URL** we got back earier from the SignWell API.

	events: {
   		completed: e => {
      		webkit.messageHandlers.jsMessageHandler.postMessage("Signing Completed");
		}
	}


The events object contains various callbacks that may be useful to you. The only one used in the sample project right now is the `completed` callback, which is called when the user finished signing the document and filling out all the required data fields. The callback uses a message handler to send the 'completed' notification from JavaScript land back to our iOS Swift code in **WebViewScreen**, so we can deal with that event as needed.


#### WKWebView

Before we load the HTML page into the WKWebView, we need to set things up properly. Again, in the sample project, this is all done in **WebViewScreen**.

`_webView.configuration.preferences.javaScriptEnabled = true`

First, because our HTML page makes use of the SignWell JavaScript widget, we configure the WKWebView to allow JavaScript.

`_webView.configuration.userContentController.add(self, name: "jsMessageHandler")`

Then, because we want to receive that notification when the user has completed signing the document, we set up a message handler that will be responsible for passing messages from JavaScript land to our iOS Swift code.

    guard let url = Bundle.main.url(forResource: "page", withExtension: "html") else { return }
    let htmlData = try! Data(contentsOf: url)
    var htmlString = String(decoding: htmlData, as: UTF8.self);
         
Next, we get the bundled HTML page that we're going to be using.

`htmlString = htmlString.replacingOccurrences(of: "$SIGNING_URL$", with: _signingURL);`

And, as mentioned above, we replace the `$SIGNING_URL$` token in that HTML page with the **signing URL** that we got back from our earlier SignWell API call. The JavaScript snippet in the HTML page will tell SignWell that this is the URL of the document we want rendered for signing.

 `_webView.loadHTMLString(htmlString, baseURL: url);`
 
 And finally, we load the HTML page into the `WKWebView`.
 
     func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "jsMessageHandler", let messageBody = message.body as? String {
            if ( messageBody == "signing_completed" ) {
                self.showAlertDialog("Your document has been signed.") {
                    self.dismiss(animated: true);
                }
            }
        }
    }
    
![Signing Screen](./github_resources/screenshot_signing_screen_1.png)
    
    
Because **WebViewScreen** implements `WKScriptMessageHandler`, and we configured our `WKWebView` to receive messages from JavaScript, the `userContentController` method gets notified whenever a message from JavaScript is sent. In our case, the only message we want to know about is "signing_completed", which occurs when the user has finished signing the document. In the sample project, when this message is received, we just show an alert dialog to the user, confirming that the document has been signed, and we close the screen that displayed the document.

