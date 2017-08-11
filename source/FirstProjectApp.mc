using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys; 

class FirstProjectApp extends App.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
     	//register for temporal events if they are supported
    	if(Toybox.System has :ServiceDelegate) {
    		Sys.println("****registering for temperal event****");
    		getServiceDelegate();
    		Background.registerForTemporalEvent(new Time.Duration(5 * 60));
    	} else {
    		Sys.println("****background not available on this device****");
    	}
    	
    	Sys.println("****existing data****");
    	Sys.println(Background.getBackgroundData());
        return [ new FirstProjectView(), new FirstProjectDelegate() ];
    }
    
    function getServiceDelegate() {
    	Sys.println("****setting service delegate****");
    	return [new FirstProjectServiceDelegate()];
    }
    
    function onBackgroundData(data) {
	    if(data instanceof Number) {
	        //indicates there was an error, and “data” is the error code
	    } else {
	        //got good “data”
	    }
	    Sys.println("*****data received*****");
	    Sys.println(data);
	    
        App.getApp().setProperty("BGDATA", data);
        Ui.requestUpdate();  
	}

}
