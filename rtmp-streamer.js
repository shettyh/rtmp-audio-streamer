var isReady = false;

// Global method for ActionScript
function setSWFIsReady() {
    if (!isReady) {
        console.log('swf is ready!');
        isReady = true;
    }
}

define('rtmp-streamer', function () {
    return function RtmpStreamer(elem) {

        /**
         * Embed swf element, eg. <embed src="*.swf"></embed>.
         */
        var _elem = elem;

        if (!isReady) {
            setTimeout(function () {
                return RtmpStreamer(elem);
            }, 1000);
        }

        /**
         * Push video to RTMP stream from local camera.
         *
         * @param url  - The RTMP stream URL
         * @param name - The RTMP stream name
         */
        this.publish = function (url, name) {
            _elem.publish(url, name);
        };

        /**
         * Disconnect from RTMP stream
         */
        this.disconnect = function () {
            _elem.disconnect();
        };

        /**
         * Set the screen width and height.
         *
         * @param width  - The screen width (pixels). The default value is 320.
         * @param height - The screen height (pixels). The default value is 240.
         */
        this.setScreenSize = function (width, height) {
            _elem.setScreenSize(width, height);
        };

        /**
         * Set the screen position.
         *
         * @param x - The screen horizontal position (pixels). The default value is 0.
         * @param y - The screen vertical position (pixels). The default value is 0.
         */
        this.setScreenPosition = function (x, y) {
            _elem.setScreenPosition(x, y);
        };

        /**
         * Set the microphone quality.
         *
         * @param quality - The encoded speech quality when using the Speex codec. Possible values are from 0 to 10.
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
         * The default value is 9.
         */
        this.setMicQuality = function (quality) {
            _elem.setMicQuality(quality);

        };

        /**
         * Set the microphone rate.
         *
         * @param rate - The rate at which the microphone is capturing sound, in kHz. Acceptable values are 5, 8, 11, 22, and 44.
         * The default value is 44.
         */
        this.setMicRate = function (rate) {
            _elem.setMicRate(rate);
        }

    };


});