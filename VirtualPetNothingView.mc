import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;
import Toybox.Weather;
import Toybox.Activity;
import Toybox.ActivityMonitor;
import Toybox.Time.Gregorian;
import Toybox.UserProfile;
class VirtualPetNothingView extends WatchUi.WatchFace {
  
function initialize() {  WatchFace.initialize(); }

function onLayout(dc as Dc) as Void { }

function onShow() as Void { }

function onUpdate(dc as Dc) as Void {
/*                 _       _     _           
  __   ____ _ _ __(_) __ _| |__ | | ___  ___ 
  \ \ / / _` | '__| |/ _` | '_ \| |/ _ \/ __|
   \ V / (_| | |  | | (_| | |_) | |  __/\__ \
    \_/ \__,_|_|  |_|\__,_|_.__/|_|\___||___/
                                           */

    /*----------System Variables------------------------------*/
    var mySettings = System.getDeviceSettings();
    var screenHeightY = (System.getDeviceSettings().screenHeight)/360;
    var screenWidthX = (System.getDeviceSettings().screenWidth)/360;
    //Size Variations Pixel Circle
//Text Movement
    if (System.getDeviceSettings().screenHeight ==390){
        screenHeightY=screenHeightY*1.1;
        screenWidthX=screenWidthX *1.06;
    }
    if (System.getDeviceSettings().screenHeight ==416){
        screenHeightY=screenHeightY*1.15;
        screenWidthX=screenWidthX *1.12;
    }
    if (System.getDeviceSettings().screenHeight ==454){
        screenHeightY=screenHeightY*1.3;
        screenWidthX=screenWidthX *1.2;
    }
    //Battery Movement
 var venus2XL=0;

    if (System.getDeviceSettings().screenHeight  == 416){
      venus2XL = 4;
      
    }
        if (System.getDeviceSettings().screenHeight == 454){
        venus2XL = 7;
    } 


    var myStats = System.getSystemStats();
    var info = ActivityMonitor.getInfo();
    
    /*----------Clock and Calendar Variables------------------------------*/
    var timeFormat = "$1$:$2$";
    var clockTime = System.getClockTime();
    var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
    var hours = clockTime.hour;
    if (!System.getDeviceSettings().is24Hour) {
        if (hours == 0) {
            hours = 12; // Display midnight as 12:00
        } else if (hours > 12) {
            hours = hours - 12;
        }
    } else {
        timeFormat = "$1$:$2$";
        hours = hours.format("%02d");
    }
    var timeString = Lang.format(timeFormat, [hours, clockTime.min.format("%02d")]);
    //var timeStamp= new Time.Moment(Time.today().value());
    var weekdayArray = ["Day", "SUNDAY", "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY"] as Array<String>;
    var monthArray = ["Month", "JANUARY", "FEBRUARY", "MARCH", "APRIL", "MAY", "JUNE", "JULY", "AUGUST", "SEPTEMBER", "OCTOBER", "NOVEMBER", "DECEMBER"] as Array<String>;
   

    /*----------Battery------------------------------*/
    var userBattery = "0";
    var batteryMeter = 1;

    if (myStats.battery != null) {
        userBattery = myStats.battery.toNumber().toString(); // Convert to string without zero padding
    } else {
        userBattery = "0";
    }

    if (myStats.battery != null) {
        batteryMeter = myStats.battery.toNumber();
    } else {
        batteryMeter = 1;
    }
        
    /*----------Steps------------------------------*/
    var userSTEPS = 0;
 if (info.steps != null){userSTEPS = info.steps.toNumber();}else{userSTEPS=0;} 
   
   /*----------Weather------------------------------*/
  
   var getCC = Toybox.Weather.getCurrentConditions();
    var TEMP = "000";
    var FC = "0";
    if (getCC != null && getCC.temperature != null) {
        if (System.getDeviceSettings().temperatureUnits == 0) {
            FC = "C";
            TEMP = getCC.temperature.format("%d");
        } else {
            TEMP = (((getCC.temperature * 9) / 5) + 32).format("%d");
            FC = "F";
        }
    } else {
        TEMP = "000";
    }

    var cond = 0;
    if (getCC != null && getCC.condition != null) {
        cond = getCC.condition.toNumber();
    } else {
        cond = 0; // Default to sun condition if unavailable
    }
    
    var moonnumber = getMoonPhase(today.year, ((today.month)-1), today.day);  
    var moon1 = moonArrFun(moonnumber);
    var centerX = (dc.getWidth()) / 2;
    var centerY = (dc.getHeight()) / 2;
    var wordFont =  WatchUi.loadResource( Rez.Fonts.smallFont );
    var bigFont= WatchUi.loadResource( Rez.Fonts.bigFont );
    View.onUpdate(dc);

userSTEPS=4000;

 /*     _                           _            _    
     __| |_ __ __ ___      __   ___| | ___   ___| | __
    / _` | '__/ _` \ \ /\ / /  / __| |/ _ \ / __| |/ /
   | (_| | | | (_| |\ V  V /  | (__| | (_) | (__|   < 
    \__,_|_|  \__,_| \_/\_/    \___|_|\___/ \___|_|\_\
                                                   */
   dc.setColor(0x000049, Graphics.COLOR_TRANSPARENT);
   dc.fillCircle(centerX,centerX, centerX*2);
   

   //Draw graphics

    var water= waterPhase(userSTEPS, 0, 0);
    water.draw(dc);
 
    if ((centerX*2)>=227){
    var water3= waterPhase(userSTEPS,227, 1);
    water3.draw(dc);
    }
    if ((centerX*2)>433){
    var water3= waterPhase(userSTEPS,360, 2);
    water3.draw(dc);
    }

    if (userSTEPS > 3000 && userSTEPS  <11000){
    var water4= waterPhase2(userSTEPS,1, 0, 3000);
    water4.draw(dc);
    var water5= waterPhase2(userSTEPS,0, (centerX*2)-328, 3000);
    water5.draw(dc);
    }


if (today.min>20 && today.min<40){
        var dog2 = dogPhase2(today.sec, today.min);
    dog2.draw(dc);
}else if(today.min>40){
   var dog3 = spongePhase(today.sec,today.min);
    dog3.draw(dc);
}else {
    var bird1 = birdPhase(today.sec,today.min);
    bird1.draw(dc);
}
//dogPhase1(steps, seconds, minutes, x position,Y stage, animal)
 if (userSTEPS >3000 && userSTEPS <11000){
     if (userSTEPS>3000 && userSTEPS<=4000){ 
    var dog1 = dogPhase1(userSTEPS, today.sec, today.min, centerX*3/2,4900, 14);
    dog1.draw(dc);
    }
   else if (userSTEPS>4000 && userSTEPS<4500){
    var dog1 = dogPhase1(userSTEPS, today.sec, today.min, centerX*3/2,6000, 0);
    dog1.draw(dc);
    }
}



//pink F8F8B0 YELLOW F8C800
   //Draw Moon and Battery
  if (System.getDeviceSettings().screenHeight <=300){}else{
    moon1.draw(dc);}

    //Draw Top Font

   
if (System.getDeviceSettings().screenHeight <300){
    dc.setColor(0x000049, Graphics.COLOR_TRANSPARENT);  
    dc.drawText(centerX+2,centerY-40+2,wordFont,(weekdayArray[today.day_of_week]+" , "+ monthArray[today.month]+" "+ today.day +" " +today.year), Graphics.TEXT_JUSTIFY_CENTER );
    dc.drawText(centerX+2,centerY-110+2,bigFont,timeString,  Graphics.TEXT_JUSTIFY_CENTER  ); 
             dc.setColor(0xFFFFFF, Graphics.COLOR_TRANSPARENT);  
    dc.drawText(centerX,centerY-40,wordFont,(weekdayArray[today.day_of_week]+" , "+ monthArray[today.month]+" "+ today.day +" " +today.year), Graphics.TEXT_JUSTIFY_CENTER );
    dc.drawText(centerX,centerY-110,bigFont,timeString,  Graphics.TEXT_JUSTIFY_CENTER  ); 
}
    else if (System.getDeviceSettings().screenWidth == 320){
         dc.setColor(0xFFFFFF, Graphics.COLOR_TRANSPARENT);  
    dc.drawText(centerX+8,78*screenHeightY,wordFont,(weekdayArray[today.day_of_week]+" , "+ monthArray[today.month]+" "+ today.day +" " +today.year), Graphics.TEXT_JUSTIFY_CENTER );
    dc.drawText(centerX+8,73*screenHeightY,bigFont,timeString,  Graphics.TEXT_JUSTIFY_CENTER  ); 
            dc.drawText( centerX+8,0, bigFont, weather(cond), Graphics.TEXT_JUSTIFY_CENTER ); 
     dc.setColor(0x2A3088, Graphics.COLOR_TRANSPARENT);
         dc.drawText( 210,(35*screenHeightY)+venus2XL+15, wordFont, (TEMP+" " +FC), Graphics.TEXT_JUSTIFY_CENTER );
    }
    else if (System.getDeviceSettings().screenHeight >400){
   
         dc.setColor(0xFFFFFF, Graphics.COLOR_TRANSPARENT);  
    dc.drawText(centerX,78*screenHeightY,wordFont,(weekdayArray[today.day_of_week]+" , "+ monthArray[today.month]+" "+ today.day +" " +today.year), Graphics.TEXT_JUSTIFY_CENTER );
    dc.drawText(centerX,73*screenHeightY,bigFont,timeString,  Graphics.TEXT_JUSTIFY_CENTER  );  
        dc.drawText( centerX,screenHeightY+15, bigFont, weather(cond), Graphics.TEXT_JUSTIFY_CENTER );
       dc.setColor(0x2A3088, Graphics.COLOR_TRANSPARENT);
         dc.drawText( 225 *screenWidthX,(50*screenHeightY), wordFont, (TEMP+" " +FC), Graphics.TEXT_JUSTIFY_CENTER );
        dc.setColor(0x70B8F8, Graphics.COLOR_TRANSPARENT); 
     
    }else{   
     dc.setColor(0xFFFFFF, Graphics.COLOR_TRANSPARENT);  
    dc.drawText(centerX,78*screenHeightY,wordFont,(weekdayArray[today.day_of_week]+" , "+ monthArray[today.month]+" "+ today.day +" " +today.year), Graphics.TEXT_JUSTIFY_CENTER );
    dc.drawText(centerX,73*screenHeightY,bigFont,timeString,  Graphics.TEXT_JUSTIFY_CENTER  );  
        dc.drawText( centerX,0*screenHeightY, bigFont, weather(cond), Graphics.TEXT_JUSTIFY_CENTER ); 
        dc.setColor(0x2A3088, Graphics.COLOR_TRANSPARENT);
            dc.drawText( 225 *screenWidthX,(35*screenHeightY)+15, wordFont, (TEMP+" " +FC), Graphics.TEXT_JUSTIFY_CENTER );
        
    }

  /*---------------Draw Battery---------------*/
  if (System.getDeviceSettings().screenWidth < 300){}
else if (System.getDeviceSettings().screenWidth == 320){
 if (batteryMeter >= 10 && batteryMeter <= 32) {
        //Red
        dc.setColor(0xB00B1E, Graphics.COLOR_TRANSPARENT); 
        dc.fillRectangle(centerX +4, (centerY * 106 / 360)+venus2XL, 9, 15);
    } else if (batteryMeter >= 33 && batteryMeter <= 65) {
       //Yellow
       dc.setColor(0xFFFF00, Graphics.COLOR_TRANSPARENT); 
        dc.fillRectangle(centerX +4, (centerY * 106 / 360)+venus2XL, 9,15 );
    } else if (batteryMeter >= 66) {
       //Nothing
    }else{
        //Nothing
    }
}else{

    if (batteryMeter >= 10 && batteryMeter <= 32) {
        //Red
        dc.setColor(0xB00B1E, Graphics.COLOR_TRANSPARENT); 
        dc.fillRectangle(centerX * 356 / 360, (centerX * 78 / 360)+venus2XL+15, 9, 15);
    } else if (batteryMeter >= 33 && batteryMeter <= 65) {
       //Yellow
       dc.setColor(0xFFFF00, Graphics.COLOR_TRANSPARENT); 
        dc.fillRectangle(centerX * 356 / 360, (centerX * 78 / 360)+venus2XL+15, 9,15 );
    } else if (batteryMeter >= 66) {
       //Nothing
    }else{
        //Nothing
    }

}

}
/*            _     _ 
  __   _____ (_) __| |
  \ \ / / _ \| |/ _` |
   \ V / (_) | | (_| |
    \_/ \___/|_|\__,_|
                    */

function onHide() as Void { }
function onExitSleep() as Void {}
function onEnterSleep() as Void {}

/*                    _   _               
__      _____  __ _| |_| |__   ___ _ __ 
\ \ /\ / / _ \/ _` | __| '_ \ / _ \ '__|
 \ V  V /  __/ (_| | |_| | | |  __/ |   
  \_/\_/ \___|\__,_|\__|_| |_|\___|_|   
                                        */

function weather(cond) {
  if (cond == 0 || cond == 40){return "b";}//sun
  else if (cond == 50 || cond == 49 ||cond == 47||cond == 45||cond == 44||cond == 42||cond == 31||cond == 27||cond == 26||cond == 25||cond == 24||cond == 21||cond == 18||cond == 15||cond == 14||cond == 13||cond == 11||cond == 3){return "a";}//rain
  else if (cond == 52||cond == 20||cond == 2||cond == 1){return "e";}//cloud
  else if (cond == 5 || cond == 8|| cond == 9|| cond == 29|| cond == 30|| cond == 33|| cond == 35|| cond == 37|| cond == 38|| cond == 39){return "g";}//wind
  else if (cond == 51 || cond == 48|| cond == 46|| cond == 43|| cond == 10|| cond == 4){return "i";}//snow
  else if (cond == 32 || cond == 37|| cond == 41|| cond == 42){return "f";}//whirlwind 
  else {return "c";}//suncloudrain 
}

/*     _                                        
    __| |_ __ __ ___      __  _ __  _ __   __ _ 
   / _` | '__/ _` \ \ /\ / / | '_ \| '_ \ / _` |
  | (_| | | | (_| |\ V  V /  | |_) | | | | (_| |
   \__,_|_|  \__,_| \_/\_/   | .__/|_| |_|\__, |
                             |_|          |___/ */



function dogPhase1(steps, seconds, minutes, position,stage, animal) {
    var screenHeightY = System.getDeviceSettings().screenHeight;
    var screenWidthX = System.getDeviceSettings().screenWidth;
      var venus2Y = -(steps-stage % 10000) * 0.08;
  
if (screenHeightY < 300){venus2Y = venus2Y-100 ;}

    // If seconds is less than 15, move the dog based on seconds (horizontal)
   var venus2X = position;  // Keep moving horizontally based on seconds

    // Array of dog sprites from dog8 to dog43
    var dogARRAY = [
    (new WatchUi.Bitmap({ :rezId => Rez.Drawables.dog0,  :locX => venus2X, :locY => venus2Y })),
    (new WatchUi.Bitmap({ :rezId => Rez.Drawables.dog1,  :locX => venus2X, :locY => venus2Y })),
    (new WatchUi.Bitmap({ :rezId => Rez.Drawables.dog2,  :locX => venus2X, :locY => venus2Y })),
    (new WatchUi.Bitmap({ :rezId => Rez.Drawables.dog3,  :locX => venus2X, :locY => venus2Y })),
    (new WatchUi.Bitmap({ :rezId => Rez.Drawables.dog4,  :locX => venus2X, :locY => venus2Y })),
    (new WatchUi.Bitmap({ :rezId => Rez.Drawables.dog5,  :locX => venus2X, :locY => venus2Y })),
    (new WatchUi.Bitmap({ :rezId => Rez.Drawables.dog6,  :locX => venus2X, :locY => venus2Y })),
    (new WatchUi.Bitmap({ :rezId => Rez.Drawables.dog7,  :locX => venus2X, :locY => venus2Y })),
    (new WatchUi.Bitmap({ :rezId => Rez.Drawables.dog8,  :locX => venus2X, :locY => venus2Y })),
    (new WatchUi.Bitmap({ :rezId => Rez.Drawables.dog9,  :locX => venus2X, :locY => venus2Y })),
    (new WatchUi.Bitmap({ :rezId => Rez.Drawables.dog10, :locX => venus2X, :locY => venus2Y })),
    (new WatchUi.Bitmap({ :rezId => Rez.Drawables.dog11, :locX => venus2X, :locY => venus2Y })),
    (new WatchUi.Bitmap({ :rezId => Rez.Drawables.dog12, :locX => venus2X, :locY => venus2Y })),
    (new WatchUi.Bitmap({ :rezId => Rez.Drawables.dog13, :locX => venus2X, :locY => venus2Y })),
    (new WatchUi.Bitmap({ :rezId => Rez.Drawables.dog14, :locX => venus2X, :locY => venus2Y })),
    (new WatchUi.Bitmap({ :rezId => Rez.Drawables.dog15, :locX => venus2X, :locY => venus2Y })),
    (new WatchUi.Bitmap({ :rezId => Rez.Drawables.dog16, :locX => venus2X, :locY => venus2Y })),
    (new WatchUi.Bitmap({ :rezId => Rez.Drawables.dog17, :locX => venus2X, :locY => venus2Y })),
    (new WatchUi.Bitmap({ :rezId => Rez.Drawables.dog18, :locX => venus2X, :locY => venus2Y })),
    (new WatchUi.Bitmap({ :rezId => Rez.Drawables.dog19, :locX => venus2X, :locY => venus2Y })),
    (new WatchUi.Bitmap({ :rezId => Rez.Drawables.dog20, :locX => venus2X, :locY => venus2Y })),
    (new WatchUi.Bitmap({ :rezId => Rez.Drawables.dog21, :locX => venus2X, :locY => venus2Y })),
    (new WatchUi.Bitmap({ :rezId => Rez.Drawables.dog22, :locX => venus2X, :locY => venus2Y })),
    (new WatchUi.Bitmap({ :rezId => Rez.Drawables.dog23, :locX => venus2X, :locY => venus2Y })),
    (new WatchUi.Bitmap({ :rezId => Rez.Drawables.dog24, :locX => venus2X, :locY => venus2Y })),
    (new WatchUi.Bitmap({ :rezId => Rez.Drawables.dog25, :locX => venus2X, :locY => venus2Y })),
    (new WatchUi.Bitmap({ :rezId => Rez.Drawables.dog26, :locX => venus2X, :locY => venus2Y })),
    (new WatchUi.Bitmap({ :rezId => Rez.Drawables.dog27, :locX => venus2X, :locY => venus2Y })),
    (new WatchUi.Bitmap({ :rezId => Rez.Drawables.dog28, :locX => venus2X, :locY => venus2Y })),
    (new WatchUi.Bitmap({ :rezId => Rez.Drawables.dog29, :locX => venus2X, :locY => venus2Y })),
    (new WatchUi.Bitmap({ :rezId => Rez.Drawables.dog30, :locX => venus2X, :locY => venus2Y })),
    (new WatchUi.Bitmap({ :rezId => Rez.Drawables.dog31, :locX => venus2X, :locY => venus2Y })),
];


    // Logic for picking the sprite
    // Use ((minutes % 3 * 2) + 2) to find the base dog image and add seconds % 2 for dynamic cycling
    return dogARRAY[animal + seconds % 2];
}


function spongePhase(seconds, minutes) {
    var screenHeightY = System.getDeviceSettings().screenHeight;
    var screenWidthX = System.getDeviceSettings().screenWidth;
    //var spongeX = (110 * screenWidthX / 360);  // Horizontal position
    var spongeX = (80 * screenWidthX/ 360); // Vertical position

    // If seconds is less than 15, move the dog based on seconds (horizontal)

    var spongeY = screenHeightY-((seconds % 20) * 20);  // Keep moving horizontally based on seconds
    // Adjust Y position if screen height is larger than 400
    if (screenHeightY > 400) {
        spongeY += 30;  // Add 30 to Y if needed
    }

// Expanded array of sponge sprites up to sponge15
var spongeARRAY = [
    (new WatchUi.Bitmap({ :rezId => Rez.Drawables.sponge0,  :locX => spongeX, :locY => spongeY })),
    (new WatchUi.Bitmap({ :rezId => Rez.Drawables.sponge1,  :locX => spongeX, :locY => spongeY })),
    (new WatchUi.Bitmap({ :rezId => Rez.Drawables.sponge2,  :locX => spongeX, :locY => spongeY })),
    (new WatchUi.Bitmap({ :rezId => Rez.Drawables.sponge3,  :locX => spongeX, :locY => spongeY })),
    (new WatchUi.Bitmap({ :rezId => Rez.Drawables.sponge4,  :locX => spongeX, :locY => spongeY })),
    (new WatchUi.Bitmap({ :rezId => Rez.Drawables.sponge5,  :locX => spongeX, :locY => spongeY })),
    (new WatchUi.Bitmap({ :rezId => Rez.Drawables.sponge6,  :locX => spongeX, :locY => spongeY })),
    (new WatchUi.Bitmap({ :rezId => Rez.Drawables.sponge7,  :locX => spongeX, :locY => spongeY })),
    (new WatchUi.Bitmap({ :rezId => Rez.Drawables.sponge8,  :locX => spongeX, :locY => spongeY })),
    (new WatchUi.Bitmap({ :rezId => Rez.Drawables.sponge9,  :locX => spongeX, :locY => spongeY })),
    (new WatchUi.Bitmap({ :rezId => Rez.Drawables.sponge10, :locX => spongeX, :locY => spongeY })),
    (new WatchUi.Bitmap({ :rezId => Rez.Drawables.sponge11, :locX => spongeX, :locY => spongeY })),
    (new WatchUi.Bitmap({ :rezId => Rez.Drawables.sponge12, :locX => spongeX, :locY => spongeY })),
    (new WatchUi.Bitmap({ :rezId => Rez.Drawables.sponge13, :locX => spongeX, :locY => spongeY })),
    (new WatchUi.Bitmap({ :rezId => Rez.Drawables.sponge14, :locX => spongeX, :locY => spongeY })),
    (new WatchUi.Bitmap({ :rezId => Rez.Drawables.sponge15, :locX => spongeX, :locY => spongeY }))
];

return spongeARRAY[((minutes % 8 * 2)) + seconds % 2];
}

function dogPhase2(seconds, minutes){
    var screenHeightY = System.getDeviceSettings().screenHeight;
    var screenWidthX = System.getDeviceSettings().screenWidth;
    var venus2X = 0;  // Initial X position
    var venus2Y = 0; // Fixed Y position

    // If seconds is less than 15, move the dog based on seconds (horizontal)
    venus2X = screenWidthX-((seconds % 20) * 20);  // Keep moving horizontally based on seconds
    venus2Y = screenHeightY-((seconds % 20) * 20);  // Keep moving horizontally based on seconds
    // Array of dog sprites from dog44 to dog47
    var dogARRAY = [
        (new WatchUi.Bitmap({ :rezId => Rez.Drawables.echo0, :locX => venus2X, :locY => venus2Y })),
    (new WatchUi.Bitmap({ :rezId => Rez.Drawables.echo1, :locX => venus2X, :locY => venus2Y })),
    (new WatchUi.Bitmap({ :rezId => Rez.Drawables.echo2, :locX => venus2X, :locY => venus2Y })),
    (new WatchUi.Bitmap({ :rezId => Rez.Drawables.echo3, :locX => venus2X, :locY => venus2Y })),
    (new WatchUi.Bitmap({ :rezId => Rez.Drawables.echo4, :locX => venus2X, :locY => venus2Y })),
    (new WatchUi.Bitmap({ :rezId => Rez.Drawables.echo5, :locX => venus2X, :locY => venus2Y })),
    (new WatchUi.Bitmap({ :rezId => Rez.Drawables.echo6, :locX => venus2X, :locY => venus2Y }))
    ];

    // Match the minutes to the length of the smaller array (4 dog images)
    return dogARRAY[minutes % 7];
}

function birdPhase(seconds, minutes) {
    var screenHeightY = System.getDeviceSettings().screenHeight;
    var screenWidthX = System.getDeviceSettings().screenWidth;
    var birdX = (110 * screenWidthX / 360);  // Initial X position for the bird
    var birdY = (280 * screenHeightY / 360); // Fixed Y position for the bird

    // If seconds is less than 15, move the bird based on seconds (horizontal)
    birdX = screenWidthX - (seconds % 20) * 20;  // Keep moving horizontally based on seconds

    // Array of bird sprites from bird0 to bird5
    var birdARRAY = [
        (new WatchUi.Bitmap({ :rezId => Rez.Drawables.bird0, :locX => birdX, :locY => birdY })),
        (new WatchUi.Bitmap({ :rezId => Rez.Drawables.bird1, :locX => birdX, :locY => birdY })),
        (new WatchUi.Bitmap({ :rezId => Rez.Drawables.bird2, :locX => birdX, :locY => birdY })),
        (new WatchUi.Bitmap({ :rezId => Rez.Drawables.bird3, :locX => birdX, :locY => birdY })),
        (new WatchUi.Bitmap({ :rezId => Rez.Drawables.bird4, :locX => birdX, :locY => birdY })),
        (new WatchUi.Bitmap({ :rezId => Rez.Drawables.bird5, :locX => birdX, :locY => birdY }))
    ];

    // Logic for picking the sprite
    // Use ((minutes % 3 * 2) + 2) to find the base bird image and add seconds % 2 for dynamic cycling
    return birdARRAY[((minutes % 3 * 2)) + seconds % 2];
}


function waterPhase(steps, position, image){
  var screenHeightY = System.getDeviceSettings().screenHeight;
  //var screenWidthX = System.getDeviceSettings().screenWidth;
  var venus2Y = -(steps % 10000) * 0.08;
  if (steps>=8000){venus2Y = -((steps-8000) % 10000)* 0.08;}
 // var venus2Y = 15;
  var venus2X = position;
  if (screenHeightY < 300){venus2Y = venus2Y-70 ;}
  /*
  if (screenHeightY == 260){venus2Y = 90;}
  if (screenHeightY == 240){venus2Y = 90;}
   if (screenHeightY == 218){venus2Y = 75;}
  if (screenHeightY == 260){venus2Y = 100;}
     if (screenHeightY == 390){venus2Y = 225;}
      if (screenHeightY == 416){venus2Y = 250;}
      if (screenHeightY == 454){venus2Y = 270;}
*/
  var waterARRAY = [
    (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.water0,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
        (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.water1,
            :locX=> venus2X,
            :locY=>venus2Y
        })), 
            (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.water4,
            :locX=> venus2X,
            :locY=>venus2Y
        }))   
        ];
        return waterARRAY[image];
}

function waterPhase2(steps,object, position, stage){
  var screenHeightY = System.getDeviceSettings().screenHeight;
  //var screenWidthX = System.getDeviceSettings().screenWidth;
  var venus2Y = -(steps-stage % 10000) * 0.08;
 // if (steps>=8000){venus2Y = -((steps-8000) % 10000)* 0.08;}
 // var venus2Y = 15;
  var venus2X = position;
  
if (screenHeightY < 300){venus2Y = venus2Y-100 ;}
  /*
  if (screenHeightY == 260){venus2Y = 90;}
  if (screenHeightY == 240){venus2Y = 90;}
   if (screenHeightY == 218){venus2Y = 75;}
  if (screenHeightY == 260){venus2Y = 100;}
     if (screenHeightY == 390){venus2Y = 225;}
      if (screenHeightY == 416){venus2Y = 250;}
      if (screenHeightY == 454){venus2Y = 270;}
*/
  var waterARRAY = [
            (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.water2,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
            (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.water3,
            :locX=> venus2X,
            :locY=>venus2Y
        }))
        ];
        return waterARRAY[object];
}




/* _                     _       __       _       
  | |__   ___  __ _ _ __| |_    /__\ __ _| |_ ___ 
  | '_ \ / _ \/ _` | '__| __|  / \/// _` | __/ _ \
  | | | |  __/ (_| | |  | |_  / _  \ (_| | ||  __/
  |_| |_|\___|\__,_|_|   \__| \/ \_/\__,_|\__\___|
                                                */
/*
private function getHeartRate() {
    // Initialize to null
    var heartRate = null;

    // Get the activity info if possible
    var info = Activity.getActivityInfo();
    if (info != null && info.currentHeartRate != null) {
        heartRate = info.currentHeartRate;
    } else { 
        // Fallback to `getHeartRateHistory`
        var history = ActivityMonitor.getHeartRateHistory(1, true);
        if (history != null) {
            var latestHeartRateSample = history.next();
            if (latestHeartRateSample != null && latestHeartRateSample.heartRate != null) {
                heartRate = latestHeartRateSample.heartRate;
            }
        }
    }

    // Could still be null if the device doesn't support it
    return heartRate;
}
*/

/*
  ____        _ _           __  __         _   _    
 |_  /___  __| (_)__ _ __  |  \/  |___ _ _| |_| |_  
  / // _ \/ _` | / _` / _| | |\/| / _ \ ' \  _| ' \ 
 /___\___/\__,_|_\__,_\__| |_|  |_\___/_||_\__|_||_|
                                                    
*/
/*
function getHoroscope(month, day) {
    if (month == 1) { // January
        if (day <= 19) {
            return "B"; // Capricorn
        } else {
            return "v"; // Aquarius
        }
    } else if (month == 2) { // February
        if (day <= 18) {
            return "v"; // Aquarius
        } else {
            return "@"; // Pisces
        }
    } else if (month == 3) { // March
        if (day <= 20) {
            return "@"; // Pisces
        } else {
            return "w"; // Aries
        }
    } else if (month == 4) { // April
        if (day <= 19) {
            return "w"; // Aries
        } else {
            return "F"; // Taurus
        }
    } else if (month == 5) { // May
        if (day <= 20) {
            return "F"; // Taurus
        } else {
            return "x"; // Gemini
        }
    } else if (month == 6) { // June
        if (day <= 20) {
            return "x"; // Gemini
        } else {
            return "C"; // Cancer
        }
    } else if (month == 7) { // July
        if (day <= 22) {
            return "C"; // Cancer
        } else {
            return "J"; // Leo
        }
    } else if (month == 8) { // August
        if (day <= 22) {
            return "J"; // Leo
        } else {
            return "H"; // Virgo
        }
    } else if (month == 9) { // September
        if (day <= 22) {
            return "H"; // Virgo
        } else {
            return "I"; // Libra
        }
    } else if (month == 10) { // October
        if (day <= 22) {
            return "I"; // Libra
        } else {
            return "G"; // Scorpio
        }
    } else if (month == 11) { // November
        if (day <= 21) {
            return "G"; // Scorpio
        } else {
            return "E"; // Sagittarius
        }
    } else if (month == 12) { // December
        if (day <= 21) {
            return "E"; // Sagittarius
        } else {
            return "B"; // Capricorn
        }
    } else {
        return "w"; // Default to Aries if month is invalid
    }
}

     */  



/*
  __  __                 ___ _                 
 |  \/  |___  ___ _ _   | _ \ |_  __ _ ___ ___ 
 | |\/| / _ \/ _ \ ' \  |  _/ ' \/ _` (_-</ -_)
 |_|  |_\___/\___/_||_| |_| |_||_\__,_/__/\___|
 
*/
function getMoonPhase(year, month, day) {

      var c=0;
      var e=0;
      var jd=0;
      var b=0;

      if (month < 3) {
        year--;
        month += 12;
      }

      ++month; 

      c = 365.25 * year;

      e = 30.6 * month;

      jd = c + e + day - 694039.09; 

      jd /= 29.5305882; 

      b = (jd).toNumber(); 

      jd -= b; 

      b = Math.round(jd * 8); 

      if (b >= 8) {
        b = 0; 
      }
     
      return (b).toNumber();
    }

     /*
     0 => New Moon
     1 => Waxing Crescent Moon
     2 => Quarter Moon
     3 => Waxing Gibbous Moon
     4 => Full Moon
     5 => Waning Gibbous Moon
     6 => Last Quarter Moon
     7 => Waning Crescent Moon
     */
function moonArrFun(moonnumber){
    var screenHeightY = System.getDeviceSettings().screenHeight;
    var screenWidthX = System.getDeviceSettings().screenWidth;    
    var venus2Y = 35*(screenHeightY/360);
    var venus2XL = ((screenWidthX)*119/360);
    //Size Variations Pixel Circle
    //360 VenuS2 - The Model I designed it for 
    //390 Size up
    //416 Size up
    //454 Size up
    
    if (screenHeightY == 390){
        venus2XL = ((venus2XL)+4);
        venus2Y = ((screenWidthX)*130/360)-100;
    }
    if (screenHeightY == 416){
      venus2XL = ((venus2XL)+8);
        venus2Y = ((screenWidthX)*130/360)-105;
    }
        if (screenHeightY == 454){
        venus2XL = ((venus2XL)+15);
        venus2Y = ((screenWidthX)*130/360)-110;
    }
  var moonArray= [
          (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.newmoon,//0
            :locX=> venus2XL,
            :locY=> venus2Y
        })),
        (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.waxcres,//1
            :locX=> venus2XL,
            :locY=> venus2Y
        })),
        (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.firstquar,//2
            :locX=> venus2XL,
            :locY=> venus2Y
        })),
                (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.waxgib,//3
            :locX=> venus2XL,
            :locY=> venus2Y
        })),
                (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.full,//4
            :locX=> venus2XL,
            :locY=> venus2Y
        })),
                (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.wangib,//5
            :locX=> venus2XL,
            :locY=> venus2Y
        })),
            (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.thirdquar,//6
            :locX=> venus2XL,
            :locY=> venus2Y
        })),
           (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.wancres,//7
            :locX=> venus2XL,
            :locY=> venus2Y,
        })),
        ];
        return moonArray[moonnumber];
}


}

/* 
       Horoscope, Zodiac, and Weather Font:
        A FAR
        B capricorn
        C CELCIUS
        D Celcius
        E SAGIT
        F TAUR
        G SCORP
        H VIRGO
        I LIBRA
        J LEO
        K BULL
        L SHEEP
        M PM
        N AM
        0 :
        a rain
        b sun
        c rainsuncloud
        d dragon
        e cloud
        f whirl
        g wind
        h rat
        i snow
        j dog
        k tiger
        l sun up
        m rabbit
        n sun down
        o snake
        p horse
        q rooster
        r monkey
        s pig
        t male
        u female
        v aquarius
        w aries
        x gemini
        y leo
        z libra
        */

// questionmark=calorie *=heart [=battery ]=steps @=battery #=phone
// = is small battery ^ is small steps ~ is small calories + is small heart