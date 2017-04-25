package {

import flash.display.MovieClip;
import flash.external.ExternalInterface;
import flash.net.NetConnection;
import flash.events.NetStatusEvent;
import flash.net.NetStream;
import flash.media.Video;
import flash.media.Camera;
import flash.media.Microphone;

//import flash.media.H264Profile;
//import flash.media.H264VideoStreamSettings;

public class RtmpStreamer extends MovieClip {

    internal var nc:NetConnection;
    internal var ns:NetStream;
    internal var nsPlayer:NetStream;
    internal var mic:Microphone;

    internal var _micQuality:int = 9;
    internal var _micRate:int = 44;

    internal var _screenWidth:int = 320;
    internal var _screenHeight:int = 240;
    internal var _screenX:int = 0;
    internal var _screenY:int = 0;


    public function RtmpStreamer() {
        ExternalInterface.addCallback("setScreenSize", setScreenSize);
        ExternalInterface.addCallback("setScreenPosition", setScreenPosition);
        ExternalInterface.addCallback("setMicQuality", setMicQuality);
        ExternalInterface.addCallback("setMicRate", setMicRate);
        ExternalInterface.addCallback("publish", publish);
        ExternalInterface.addCallback("disconnect", disconnect);

        ExternalInterface.call("setSWFIsReady");
    }

    public function setScreenSize(width:int, height:int):void {
        _screenWidth = width;
        _screenHeight = height;
    }

    public function setScreenPosition(x:int, y:int):void {
        _screenX = x;
        _screenY = y;
    }

    public function setMicQuality(quality:int):void {
        _micQuality = quality;
    }

    public function setMicRate(rate:int):void {
        _micRate = rate;
    }

    public function publish(url:String, name:String):void {
        this.connect(url, name, function (name:String):void {
            publishStream(name);
        });
    }

    public function disconnect():void {
        nc.close();
    }

    private function connect(url:String, name:String, callback:Function):void {
        nc = new NetConnection();
        nc.addEventListener(NetStatusEvent.NET_STATUS, function (event:NetStatusEvent):void {
            ExternalInterface.call("console.log", "try to connect to " + url);
            ExternalInterface.call("console.log", event.info.code);
            if (event.info.code == "NetConnection.Connect.Success") {
                callback(name);
            }
        });
        nc.connect(url);
    }

    private function publishStream(name:String):void {
//      Mic

		mic = Microphone.getMicrophone();

		/*
		 * The encoded speech quality when using the Speex codec. Possible values are from 0 to 10. The default value is 6.
		 * Higher numbers represent higher quality but require more bandwidth, as shown in the following table.
		 * The bit rate values that are listed represent net bit rates and do not include packetization overhead.
		 * ------------------------------------------
		 * Quality value | Required bit rate (kbps)
		 *-------------------------------------------
		 *      0        |       3.95
		 *      1        |       5.75
		 *      2        |       7.75
		 *      3        |       9.80
		 *      4        |       12.8
		 *      5        |       16.8
		 *      6        |       20.6
		 *      7        |       23.8
		 *      8        |       27.8
		 *      9        |       34.2
		 *      10       |       42.2
		 *-------------------------------------------
		 */
		mic.encodeQuality = _micQuality;

		/* The rate at which the microphone is capturing sound, in kHz. Acceptable values are 5, 8, 11, 22, and 44. The default value is 8 kHz
		 * if your sound capture device supports this value. Otherwise, the default value is the next available capture level above 8 kHz that
		 * your sound capture device supports, usually 11 kHz.
		 *
		 */
		mic.rate = _micRate;


		ns = new NetStream(nc);
	//        H.264 Setting
	//        ns.videoStreamSettings = h264setting;
		ns.attachAudio(mic);
		ns.publish(name, "live");
	}
}

}
