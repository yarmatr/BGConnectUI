using Toybox.Background;
using Toybox.Communications as Comm;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;

(:background)
class BGConnectUIServiceDelegate extends System.ServiceDelegate {
	function initialize() {
        ServiceDelegate.initialize();
    }

    // When a scheduled background event triggers, make a request to
    // a service and handle the response with a callback function
    // within this delegate.
    function onTemporalEvent() {
        makeWebRequest();
    }

	function makeWebRequest() {		
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
        var parsedData = null;
        
        // divide mg/dL by 18 to get mmol/L
        if (responseCode == 200) {
        	var mmol = data[0].get("sgv").toFloat() / 18;
        	var date = data[0].get("date") / 1000;
        	var moment = new Time.Moment(date);
        	var gregorian = Gregorian.info(moment, Time.FORMAT_MEDIUM);
        	var timeString = gregorian.hour.format("%02d") + ":" + gregorian.min.format("%02d");
        	parsedData = {        		
        		"mmol" => mmol.format("%02.2f"), 
        	 	"timeString" => timeString
        	};
        }
        
        Background.exit(parsedData);
    }
}