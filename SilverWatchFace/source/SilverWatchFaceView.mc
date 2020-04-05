using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Time.Gregorian;
using Toybox.ActivityMonitor;
using Toybox.Sensor;
using Toybox.Activity;

class SilverWatchFaceView extends WatchUi.WatchFace {

	var customFont = null; 
	var customIcons = null;
	var i = 0;
	var batteryInt = 0; 
	var hrIterator = null;
	var sample = null;

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        customFont = WatchUi.loadResource(Rez.Fonts.customFont);
        customIcons = WatchUi.loadResource(Rez.Fonts.typicons22);
        setLayout(Rez.Layouts.WatchFace(dc));        
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
    	
    	//dc.draw(batteryIcon);
		//batteryIcon.draw( dc );
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
		dc.clear();
        setClockDisplay();
        setDateDisplay();
        setBatteryDisplay();
        setStepCountDisplay(); 
        setHeartrateDisplay();
        setRHRDisplay();
        setCaloriesDisplay();
        setPressureDisplay();
        setAlititudeDisplay();
        View.onUpdate(dc);
        /*
        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_DK_RED);
        dc.drawCircle(120, 120, 119);
        for(i=0; i<=240;i=i+20){
        	dc.drawLine(0, i, 240,   i);
        	dc.drawLine(i, 0,   i, 240);
        }
        */
        
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }
	private function setDateDisplay() {        
	    var now = Time.now();
		var date = Gregorian.info(Time.now(), Time.FORMAT_LONG); 
		var dateString = Lang.format("$1$, $2$ $3$", [date.day_of_week, date.month, date.day]);
		var dateDisplay = View.findDrawableById("DateDisplay");      
		dateDisplay.setText(dateString);	    	
	}
	private function setClockDisplay() {
    	var clockTime = System.getClockTime();
        var timeString = Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%02d")]);
	// This	will break if it doesn't match your drawable's id!
        var view = View.findDrawableById("TimeDisplay");
        view.setText(timeString);
    }
    private function setBatteryDisplay() {
    	var battery = System.getSystemStats().battery;				
		var batteryDisplay = View.findDrawableById("BatteryDisplay");      
		batteryDisplay.setText(battery.format("%d")+"%");	
		
		batteryInt = battery;
		//System.println(batteryInt);
		var batteryIcon = View.findDrawableById("BatteryIcon");
		if (battery >75) {
			batteryIcon.setText("d");}
		if (battery <=75) {
			batteryIcon.setText("c");}
		if (battery <=50) {
			batteryIcon.setText("b");}
		if (battery <=25) {
			batteryIcon.setText("a");}
    }
    
    private function setStepCountDisplay() {
    	var stepCountDisplay = View.findDrawableById("StepCountDisplay");   
		var stepCount = ActivityMonitor.getInfo().steps;		
		if (stepCount!=null) {   
		stepCountDisplay.setText(stepCount.format("%d")); }
    }
	
    private function setHeartrateDisplay() {  	
		var heartrateDisplay = View.findDrawableById("HeartrateDisplay");    
		var hr = Activity.getActivityInfo().currentHeartRate;
		if (hr!=null) {
		heartrateDisplay.setText(hr.format("%d")); }
    }
    private function setRHRDisplay() {  	
		var RHRDisplay = View.findDrawableById("RHRDisplay");    
		var rhr = UserProfile.getProfile().restingHeartRate;
		if (rhr!=null) {
		RHRDisplay.setText(rhr.format("%d")); }
    }

    private function setCaloriesDisplay() {  	
		var caloriesDisplay = View.findDrawableById("CaloriesDisplay");    
		var calories = ActivityMonitor.getInfo().calories;
		if (calories!=null) { 
		caloriesDisplay.setText(calories.format("%d"));}
    }
    
    private function setPressureDisplay() {
    	var pressureDisplay = View.findDrawableById("PressureDisplay");   
		var pressure = Activity.getActivityInfo().ambientPressure / 100; // ambientPressure or rawAmbientPressure
    	//System.println(pressure);	
		if (pressure!=null) {    
		pressureDisplay.setText(pressure.format("%.1f") + " hpa");}
    }
    
    private function setAlititudeDisplay() {
    	var altitudeDisplay = View.findDrawableById("AltitudeDisplay");  
		var altitude = Activity.getActivityInfo().altitude;
    	//System.println(pressure);	
		if (altitude!=null) {     
		altitudeDisplay.setText(altitude.format("%d") + " npm"); }
    }
	
}

