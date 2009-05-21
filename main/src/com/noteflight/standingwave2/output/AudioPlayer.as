package com.noteflight.standingwave2.output
{
    import com.noteflight.standingwave2.elements.IAudioSource;
    
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.SampleDataEvent;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    
    /** Dispatched when the currently playing sound has completed. */
    [Event(type="flash.events.Event",name="complete")]
    
    /**
     * An AudioPlayer streams samples from an IAudioSource to a Sound object using a
     * SampleDataEvent listener.  It does so using a preset number of frames per callback,
     * and continues streaming the output until it is stopped, or until there is no more
     * audio output obtainable from the IAudioSource.
     */
    public class AudioPlayer extends EventDispatcher
    {

        // The sound being output
        private var _sound:Sound;
        
        // The SoundChannel that the output is playing through
        private var _channel:SoundChannel;
 
        // The delegate that handles the actual provision of the samples
        private var _sampleHandler:AudioSampleHandler;
 
        /**
         * Construct a new AudioPlayer instance. 
         * @param framesPerCallback the number of frames that this AudioPlayer will
         * obtain for playback on each SampleDataEvent emitted by the playback Sound object.
         */
        public function AudioPlayer(framesPerCallback:Number = 4096)
        {
            _sampleHandler = new AudioSampleHandler(framesPerCallback); 
            _sampleHandler.addEventListener(Event.COMPLETE, handleComplete);
        }
        
        /**
         * Play an audio source through this output.  Only one source may be played at a time.
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
                _sampleHandler.channel = null;
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
        
        /**
         * The SoundChannel currently employed for playback, or null if there is none.
         */
        public function get channel():SoundChannel
        {
            return _channel;
        }

        /**
         * Begin continuous sample block generation. 
         */
        private function startSound():void
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
         * Handle a SampleDataEvent by passing it to the AudioSampleHandler delegate.
         */
        private function handleSampleData(e:SampleDataEvent):void
        {
            _sampleHandler.handleSampleData(e);
            dispatchEvent(new Event("positionChange"));
        }
        
        /**
         * Handle completion of our sample handler by forwarding the event to anyone listening to us.
         */
        private function handleComplete(e:Event):void
        {
            dispatchEvent(e);
        }
 
        /**
         * The actual playback position in seconds, relative to the start of the current source. 
         */
        [Bindable("positionChange")]
        public function get position():Number
        {
            return _sampleHandler.position;
        }

        /**
         * The estimated percentage of CPU resources being consumed by sound synthesis. 
         */
        [Bindable("positionChange")]
        public function get cpuPercentage():Number
        {
            return _sampleHandler.cpuPercentage;
        }

        /**
         * The estimated time between a SampleDataEvent and the actual production of the
         * sound provided to that event, if known.  The time is expressed in seconds.
         */
        [Bindable("positionChange")]
        public function get latency():Number
        {
            return _sampleHandler.latency;
        }
    }
}