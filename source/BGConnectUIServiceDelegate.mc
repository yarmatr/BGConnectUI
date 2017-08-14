using Toybox.Background;
using Toybox.Communications as Comm;
using Toybox.System;

(:background)
class BGConnectUIServiceDelegate extends System.ServiceDelegate {
	function initialize() {
		System.println("****initializing service delegate****");
		// makeWebRequest();
        ServiceDelegate.initialize();
    }

    // When a scheduled background event triggers, make a request to
    // a service and handle the response with a callback function
    // within this delegate.
    function onTemporalEvent() {
        makeWebRequest();
    }

	function makeWebRequest() {
		System.println("****making web request****");
		
		var url = "https://floating-shore-70452.herokuapp.com/api/v1/entries.json?count=1";                          // set the url

		var options = {                                               // set the options
			:methods => Comm.HTTP_REQUEST_METHOD_GET,               // set HTTP method
			:responseType => Comm.HTTP_RESPONSE_CONTENT_TYPE_JSON        // set response type
		};
		
		
		Comm.makeWebRequest(
            url,
            null,
            options,
            method(:responseCallback)
        );
	}

    function responseCallback(responseCode, data) {
        // Do stuff with the response data here and send the data
        // payload back to the app that originated the background
        // process.
        System.println("****handling response callback****");
        System.println(responseCode);
        System.println(data);
        
        var parsedData = null;
        
        // divide mg/dL by 18 to get mmol/L
        if (responseCode == 200) {
        	System.println("****inside data check****");
        	System.println(data[0]);
        	var mmol = data[0].get("sgv") / 18;
        	System.println(mmol);
        	var dateString = data[0].get("dateString");
        	System.println(dateString);
        	parsedData = {
        		"mmol" => mmol, 
        		"dateString" => dateString
        	};
        	System.println(parsedData);
        }
        
        Background.exit(parsedData);
    }
}