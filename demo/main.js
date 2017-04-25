
require.config({
    paths: {
        "rtmp-streamer": "../rtmp-streamer"
    }
});

require(["rtmp-streamer"], function (RtmpStreamer) {

    var getUrl = function () {
        return document.getElementById('url').value;
    };

    var getName = function () {
        return document.getElementById('stream-name').value;
    };

    var streamer = new RtmpStreamer(document.getElementById('rtmp-streamer'));

    document.getElementById("publish").addEventListener("click", function () {
        streamer.publish(getUrl(), getName());
    });

    document.getElementById("streamer-disconnect").addEventListener("click", function () {
        streamer.disconnect();
    });

});
