using Toybox.WatchUi as Ui;
using Toybox.Application as App;
using Toybox.System;

class BGConnectUIView extends Ui.View {

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    
       	var data = App.getApp().getProperty("BGDATA");
        var mmol = "undefined";
        var dateString = "undefined";
        if (data != null && data.hasKey("mmol") && data.hasKey("dateString")) {
        	mmol = data.get("mmol").toString();
        	dateString = data.get("dateString");
        }
        
        System.println(mmol);
        System.println(dateString);
    
    	var latestSugarLabelField = View.findDrawableById("LatestSugarLabel");
        latestSugarLabelField.setText("Latest Sugar:");
        
        var latestSugarField = View.findDrawableById("LatestSugar");
        latestSugarField.setText(mmol);
        
        var latestSugarTimeLabelField = View.findDrawableById("LatestSugarTimeLabel");
        latestSugarTimeLabelField.setText("Sugar Time:");
    	
    	var latestSugarTimeField = View.findDrawableById("LatestSugarTime");
        latestSugarTimeField.setText(dateString);
    
    }

    // Update the view
    function onUpdate(dc) {
       
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        
        /*
 		var data = App.getApp().getProperty("BGDATA");
        var mmol = "undefined";
        var dateString = "undefined";
        if (data != null && data.hasKey("mmol") && data.hasKey("dateString")) {
        	mmol = data.get("mmol").toString();
        	dateString = data.get("dateString");
        }
        
        System.println(mmol);
        System.println(dateString);
    
    	var latestSugarLabelField = View.findDrawableById("LatestSugarLabel");
        latestSugarLabelField.setText("Latest Sugar:");
        
        var latestSugarField = View.findDrawableById("LatestSugar");
        latestSugarField.setText(mmol);
        
        var latestSugarTimeLabelField = View.findDrawableById("LatestSugarTimeLabel");
        latestSugarTimeLabelField.setText("Sugar Time:");
    	
    	var latestSugarTimeField = View.findDrawableById("LatestSugarTime");
        latestSugarTimeField.setText(dateString);
        
        */
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

}
