import './style.css'
import dashjs from "dashjs";
import Hls from "hls.js";

function initializeDash(codec, bitrate) {
    var video,
        player,
        url = `${codec}_mpd/bbb_${codec}.mpd`;

    player = dashjs.MediaPlayer().create();
    video = document.querySelector("video");
    player.initialize(); /* initialize the MediaPlayer instance */

    player.updateSettings({
        'streaming': {
            'scheduling': {
                'scheduleWhilePaused': false,   /* stops the player from loading segments while paused */
            },
            'abr': {
                'maxBitrate': {
                    video: bitrate + 500
                },
                'minBitrate': {
                    video: bitrate - 500
                }
            }
        }
    });
    player.setAutoPlay(false); /* remove this line if you want the player to start automatically on load */
    player.attachView(video); /* tell the player which videoElement it should use */
    player.attachSource(url); /* provide the manifest source */
}

function initializeHls(codec, bitrate) {
    let bitrates = [750, 2500, 6000]
    let video = document.querySelector("video");
    var videoSrc = `${codec}_hls/master.m3u8`;
    if (Hls.isSupported()) {
        var hls = new Hls({autoStartLoad : false});
        hls.attachMedia(video);
        hls.on(Hls.Events.MEDIA_ATTACHED,function() {
            hls.loadSource(videoSrc);
            hls.on(Hls.Events.MANIFEST_PARSED, function(event,data) {
                switch (bitrates.indexOf(bitrate)) {
                    case 2:
                        hls.removeLevel(0);
                        hls.removeLevel(0);
                        hls.startLevel = 0;
                        break;
                    case 1:
                        hls.removeLevel(2);
                        hls.removeLevel(0);
                        hls.startLevel = 0;
                        break;
                    case 0:
                        hls.removeLevel(1);
                        hls.removeLevel(1);
                        hls.startLevel = 0;
                        break;
                    default:
                        console.warn('adaptive level')
                }
                hls.startLoad()
                video.play();
            })
        });
    }
}

window.onload = function() {
    document.getElementById("dash_750").addEventListener("click", () => initializeDash("h264", 750))
    document.getElementById("dash_2500").addEventListener("click", () => initializeDash("h264", 2500))
    document.getElementById("dash_6000").addEventListener("click", () => initializeDash("h264", 6000))
    document.getElementById("hls_750").addEventListener("click", () => initializeHls("h264", 750))
    document.getElementById("hls_2500").addEventListener("click", () => initializeHls("h264", 2500))
    document.getElementById("hls_6000").addEventListener("click", () => initializeHls("h264", 6000))
}
// initializeDash('h264', 2500);
// initializeHls('h264', 750);