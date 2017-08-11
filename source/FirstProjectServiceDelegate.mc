using Toybox.Background;
using Toybox.Communications as Comm;
using Toybox.System;

(:background)
class FirstProjectServiceDelegate extends System.ServiceDelegate {
	function initialize() {
		System.println("****initializing service delegate****");
		makeWebRequest();
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
		
		
		Communications.makeWebRequest(
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
        Background.exit(data);
    }
}