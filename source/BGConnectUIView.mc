using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Application as App;
using Toybox.ActivityMonitor as AM;

class BGConnectUIView extends Ui.WatchFace {
    const MOVE_WARNING_MED_THRESHOLD = 0.5;
    const MOVE_WARNING_HIGH_THRESHOLD = 0.75;
    const HEART_RATE_SAMPLE_SIZE = 10;
    const PART_NUMBER_920XT = "006-B1765-00";

    var mIs24Hour;
    var mDistanceConversion;
    var mScreenHeight;
    var mScreenWidth;
    var mBatteryTextOffsetX;
    var mBatteryTextOffsetY;
    var mBatteryIconOffsetY;
    
    var alarmLogo;
    var messageLogo;
    var batteryLogo;
    var bluetoothLogo;
     
    var mTimeFormat;
    var mPhoneXPosition;
    var mMessageXPosition;
    var mAlarmXPosition;  
    var mPercentBatteryXPosition;  
    var mBottomRowY; 
 
    
    function initialize() {
        WatchFace.initialize();
        mIs24Hour = false;
        mDistanceConversion = 100000.0;
        messageLogo = Ui.loadResource(Rez.Drawables.mail);
        alarmLogo = Ui.loadResource(Rez.Drawables.alarm);
        bluetoothLogo = Ui.loadResource(Rez.Drawables.bluetooth);
        batteryLogo = Ui.loadResource(Rez.Drawables.battery);
     }

    //! Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
    	var info = AM.getInfo();
        var ds = Sys.getDeviceSettings();

		/*
     	var du = ds.distanceUnits;
    	var distanceLabelText = "km";
    	if(du == Sys.UNIT_STATUTE) {
    	    mDistanceConversion = 160934.0;
    	    distanceLabelText = "miles";
    	    try {
    	    	distanceLabelText = Ui.loadResource(Rez.Strings.MilesLabel);
    	    	Sys.println("Miles label loaded: " + distanceLabelText);
    	    } catch (ex) {
    	    	Sys.println("Couldn't load miles label, using default");
    	    }
    	} else {
    		mDistanceConversion = 100000.0;
    		distanceLabelText = "km";
    	}
    	*/

    	mIs24Hour = ds.is24Hour;
    	mTimeFormat = "$1$:$2$";
        if (mIs24Hour) {
            mTimeFormat = "$1$:$2$";
        }  
       
       	/*
        var caloriesLabelText = "calories";
        try {
        	caloriesLabelText = Ui.loadResource(Rez.Strings.CaloriesLabel);
        	Sys.println("Calories Label loaded: " + caloriesLabelText);
        } catch (ex) {
        	Sys.println("Couldn't load the calories label");
        }
        */
        
        //Calculate layout based on screen
        mScreenHeight = ds.screenHeight;
     	mScreenWidth = ds.screenWidth;
		var center = mScreenWidth / 2;
		
        var fieldBuffer = 4;
        var lineCount = 6;
        var fieldHeightDelta = -4;
        var doubleUpLastLine = false;
        var bottomRowBuffer = 0;
        
        if(ds.screenShape == Sys.SCREEN_SHAPE_ROUND || ds.screenShape == Sys.SCREEN_SHAPE_SEMI_ROUND) {
        	fieldHeightDelta = -5;
  			mAlarmXPosition = center - 10;
 			mMessageXPosition = mAlarmXPosition + 25;
 			mPhoneXPosition = mMessageXPosition + 25;
 			mPercentBatteryXPosition = mAlarmXPosition - 50;
 			if(ds.screenShape == Sys.SCREEN_SHAPE_ROUND) {
 				mBatteryTextOffsetX = 5;
				mBatteryTextOffsetY = -2;
				mBatteryIconOffsetY = -12;
 			} else {
 				mBatteryTextOffsetX = 8;
				mBatteryTextOffsetY = 1;
				mBatteryIconOffsetY = -12;
 			}
 		} else {
 			mPercentBatteryXPosition = 5;
        	mPhoneXPosition =  mScreenWidth - 30;     
        	mMessageXPosition = mPhoneXPosition - 30;
        	mAlarmXPosition = mMessageXPosition - 30;    
        	mBatteryTextOffsetX = 7;
			mBatteryTextOffsetY = 0;
			mBatteryIconOffsetY = -12;
			if(mScreenWidth >= mScreenHeight) {
				doubleUpLastLine = true;
				lineCount = 5;
				bottomRowBuffer = 4;
			}
 		}
 		
 		if(ds.partNumber.equals(PART_NUMBER_920XT)) {
       		mBatteryTextOffsetX = 11;
			mBatteryTextOffsetY = 4;
 		}
         
        var rowHeight = mScreenHeight / lineCount;
        
        
        var timeField = View.findDrawableById("Time");
        timeField.setLocation(center, 0);
        
        /*
        var hrField = View.findDrawableById("HeartRate");
        hrField.setLocation(center - fieldBuffer, rowHeight + fieldHeightDelta);        
        var hrLabel = View.findDrawableById("HeartRateLabel");
        hrLabel.setLocation(center, rowHeight);
        hrLabel.setText("BPM");
        
        var stepField = View.findDrawableById("Steps");
        stepField.setLocation(center - fieldBuffer, rowHeight * 2 + fieldHeightDelta);
        var stepLabel = View.findDrawableById("StepsLabel");
        stepLabel.setLocation(center, rowHeight * 2);
        var stepGoal = info.stepGoal;
        stepLabel.setText("of " + stepGoal);
        
        var distanceFieldX = center - fieldBuffer;
        var distanceFieldY = rowHeight * 3 + fieldHeightDelta;
        var distanceLabelX = center;
        var distanceLabelY = rowHeight * 3;
        var caloriesFieldX = center - fieldBuffer;
        var caloriesFieldY = rowHeight * 4 + fieldHeightDelta;
        var caloriesLabelX = center;
        var caloriesLabelY = rowHeight * 4;
        if(doubleUpLastLine) {
        	distanceFieldX = center - 40;
        	distanceFieldY = rowHeight * 3 + fieldHeightDelta;
        	distanceLabelX = distanceFieldX + 3;
        	distanceLabelY = rowHeight * 3;
        	caloriesFieldX = center + 50;
        	caloriesFieldY = rowHeight * 3 + fieldHeightDelta;
        	caloriesLabelX = caloriesFieldX + 3;
        	caloriesLabelY = rowHeight * 3;
        	if(ds.partNumber.equals(PART_NUMBER_920XT)) {
        		distanceFieldX++;
        		distanceLabelX++;
        		caloriesFieldX++;
        		caloriesLabelX++;
        	}
        }
        var distanceField = View.findDrawableById("Distance");
        distanceField.setLocation(distanceFieldX, distanceFieldY);
        var distanceLabel = View.findDrawableById("DistanceLabel");
        distanceLabel.setLocation(distanceLabelX, distanceLabelY);
        distanceLabel.setText(distanceLabelText);
         
        var caloriesField = View.findDrawableById("Calories");
        caloriesField.setLocation(caloriesFieldX, caloriesFieldY);
        var caloriesLabel = View.findDrawableById("CaloriesLabel");
        caloriesLabel.setLocation(caloriesLabelX, caloriesLabelY);
        caloriesLabel.setText(caloriesLabelText);
        */
 
        var iconSizeWithBuffer = 30;
        mBottomRowY = rowHeight * (lineCount - 1) + bottomRowBuffer;
    	
    	var data = App.getApp().getProperty("BGDATA");
        var mmol = "undefined";
        var mmolTimeString = "undefined";
        if (data != null && data.hasKey("mmol") && data.hasKey("timeString")) {
        	mmol = data.get("mmol");
        	mmolTimeString = data.get("timeString");
        }
        
        var latestSugarField = View.findDrawableById("LatestSugar");
        latestSugarField.setText(mmol + " @ " + mmolTimeString);      
      }

    //! Update the view
    function onUpdate(dc) {
		var info = AM.getInfo();
   
        // Get the current time and format it correctly
        var clockTime = Sys.getClockTime();
        var hours = clockTime.hour;
        if (!mIs24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            }
        } else {
            hours = hours.format("%02d");
        }
        var timeString = Lang.format(mTimeFormat, [hours, clockTime.min.format("%02d")]);
       
        // Update the view
        var timeField = View.findDrawableById("Time");
        timeField.setText(timeString);
        
        /*
        var hrIterator = info.getHeartRateHistory(HEART_RATE_SAMPLE_SIZE, true);
        var hrString = "--";
        var hrLatest = AM.INVALID_HR_SAMPLE;
        var sample = hrIterator.next();
        var sampleCount = 0;
        while(sample != null && sampleCount == 0) {
        	if(sample.heartRate != AM.INVALID_HR_SAMPLE) {
        		hrLatest = sample.heartRate;
         		sampleCount++;
        	}
        	sample = hrIterator.next();
        }
        
       	if(sampleCount > 0) {
       		hrString = hrLatest.toString();
       	}
        var hrField = View.findDrawableById("HeartRate");
        hrField.setText(hrString);
        
        var steps = info.steps;

        var stepString = steps.toString();
        var stepField = View.findDrawableById("Steps");
        stepField.setText(stepString);
        
        var distance = info.distance / mDistanceConversion;
        var distanceString = distance.format("%5.2f");
        var distanceField = View.findDrawableById("Distance");
        distanceField.setText(distanceString);
          
        var caloriesString = info.calories.toString();
        var caloriesField = View.findDrawableById("Calories");
        caloriesField.setText(caloriesString);
        */
         
        var stats = Sys.getSystemStats();
        var battery = stats.battery;
        var batteryString = battery.toLong().toString() + "%";
        
        if(battery == 100) {
        	batteryString = "Full";
        }
                
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        
        //Draw additional elements
        dc.drawBitmap(mPercentBatteryXPosition, mBottomRowY + mBatteryIconOffsetY, batteryLogo);
        dc.drawText(mPercentBatteryXPosition + mBatteryTextOffsetX, mBottomRowY + mBatteryTextOffsetY, Graphics.FONT_SMALL, batteryString, Graphics.TEXT_JUSTIFY_LEFT);
        
        var ds = Sys.getDeviceSettings();
        var phoneConnect = ds.phoneConnected;        
        if(phoneConnect) {
        	dc.drawBitmap(mPhoneXPosition, mBottomRowY, bluetoothLogo);
        }
        
        var msgCount = ds.notificationCount;
        if(msgCount > 0) {
       		dc.drawBitmap(mMessageXPosition, mBottomRowY, messageLogo);
        }
        
        var alarmCount = ds.alarmCount; 
        if(alarmCount > 0) {
         	dc.drawBitmap(mAlarmXPosition, mBottomRowY, alarmLogo);       
        }
        
        var standardBarWidth = 1;
        var warningBarWidth = 4;
        var moveBar = info.moveBarLevel;
        var mBarLine = mBottomRowY - 5;
        var barLineStart = 0;
        var barLineStop = mScreenWidth;
        dc.setPenWidth(standardBarWidth);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawLine(barLineStart, mBarLine, barLineStop, mBarLine);
        if(moveBar != AM.MOVE_BAR_LEVEL_MIN) {
        	dc.setPenWidth(warningBarWidth);
        	var ratio = moveBar.toDouble() / (AM.MOVE_BAR_LEVEL_MAX - AM.MOVE_BAR_LEVEL_MIN).toDouble();
        	var barLineStop = (mScreenWidth * ratio).toLong();
        	if(ratio < MOVE_WARNING_MED_THRESHOLD) {
        		dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_BLACK);
        	} else if(ratio < MOVE_WARNING_HIGH_THRESHOLD) {
        		dc.setColor(Graphics.COLOR_ORANGE, Graphics.COLOR_BLACK);
        	} else {
        		dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_BLACK);
        	}
        	dc.drawLine(barLineStart, mBarLine, barLineStop, mBarLine);
        }
        
        var data = App.getApp().getProperty("BGDATA");
        var mmol = "undefined";
        var mmolTimeString = "undefined";
        if (data != null && data.hasKey("mmol") && data.hasKey("timeString")) {
        	mmol = data.get("mmol");
        	mmolTimeString = data.get("timeString");
        }
        
        var latestSugarField = View.findDrawableById("LatestSugar");
        latestSugarField.setText(mmol + " @ " + mmolTimeString);  
    }

}
