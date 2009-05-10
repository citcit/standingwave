package com.noteflight.standingwave2.output
{
    import com.noteflight.standingwave2.elements.IAudioSource;
    
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.SampleDataEvent;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    
    public class AudioPlayer extends EventDispatcher
    {

        // The sound being output
        private var _sound:Sound;
        
        // The SoundChannel that the output is playing through
        private var _channel:SoundChannel;
 
        private var _sampleHandler:AudioSampleHandler;
 
        public function AudioPlayer(framesPerCallback:Number = 4096)
        {
            _sampleHandler = new AudioSampleHandler(framesPerCallback); 
        }
        
        /**
         * Begin continuous sample block generation. 
         */
        public function startSound():void
        {
            if (_sound != null)
            {
                return;
            }
            _sound = new Sound();
            _sound.addEventListener(SampleDataEvent.SAMPLE_DATA, handleSampleData);
            _channel = _sound.play();
            _sampleHandler.channel = _channel;
        }
        
        
        
        /**
         * Play an audio source through this output.  Only one source may be played at a time.
         *  
         * @param source an IAudioSource instance
         */
        public function play(source:IAudioSource):void
        {
            stop();
            _sampleHandler.source = source;
            _sampleHandler.sourceStarted = false;
            startSound();
        }
        
        /**
         * Stop a given source (if supplied), or stop any source that is playing (if no source
         * parameter is supplied). 
         * 
         * @param source an optional IAudioSource instance
         */
        public function stop(source:IAudioSource = null):void
        {
            if (source == null || source == _sampleHandler.source)
            {
                _sampleHandler.source = null;
                if (_channel)
                {
                    _channel.stop();
                    _channel = null;
                }
                _sound = null;
            }
        }
        
        /**
         * The source currently being played by this object, or null if there is none.
         */
        public function get source():IAudioSource
        {
            return _sampleHandler.source;
        }

        private function handleSampleData(e:SampleDataEvent):void
        {
            _sampleHandler.handleSampleData(e);
            dispatchEvent(new Event("positionChange"));
        }
 
        /**
         * The position in seconds relative to the start of the current source, else zero 
         */
        [Bindable("positionChange")]
        public function get position():Number
        {
            return _sampleHandler.position;
        }

        /**
         * The position in seconds relative to the start of the current source, else zero 
         */
        [Bindable("positionChange")]
        public function get cpuPercentage():Number
        {
            return _sampleHandler.cpuPercentage;
        }

        /**
         * The latency in seconds, if known. 
         */
        [Bindable("positionChange")]
        public function get latency():Number
        {
            return _sampleHandler.latency;
        }
    }
}