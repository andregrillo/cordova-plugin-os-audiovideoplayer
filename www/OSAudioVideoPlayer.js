var exec = require('cordova/exec');

exports.playAudioVideo = function (success, error, audio, video) {
    exec(success, error, 'OSAudioVideoPlayer', 'initialize', [audio,video]);
};
