////////////////////////////////////////////////////////////////////////////////
//
//  NOTEFLIGHT LLC
//  Copyright 2007-2008 Noteflight LLC
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

package com.noteflight.standingwave2.elements
{
    import __AS3__.vec.Vector;
    
    /**
     * Sample is the fundamental audio source implementation, being a set of buffers
     * containing actual numeric samples of an audio signal.  The <code>channelData</code>
     * property is an Array of channel buffers, whose length is the number of channels
     * specified by the descriptor.  Each channel buffer is also an Array, whose elements
     * are arrays of sample frame.  Each frame, in turn, is an integer representing
     * the signal's amplitude in the format specified by the sample's AudioDescriptor.
     */
    public class Sample implements IAudioSource
    {
        /** Array of Vectors of data samples as Numbers, one per channel. */
        public var channelData:Array;
        
        /** Audio descriptor for this sample. */
        private var _descriptor:AudioDescriptor;
        
        private var _position:Number;

        /**
         * Construct a new, empty Sample with some specified audio format. 
         * @param descriptor an AudioDescriptor specifying the audio format of this sample.
         * @param frames the number of frames in this Sample
         */
        public function Sample(descriptor:AudioDescriptor, frames:Number = -1)
        {
            _descriptor = descriptor;
            channelData = [];
            if (frames >= 0)
            {
                for (var c:Number = 0; c < channels; c++)
                {
                    channelData[c] = new Vector.<Number>(frames, frames > 0);
                }
            }
            _position = 0;
        }
        
        /**
         * The number of channels in this sample
         */
        public function get channels():Number
        {
            return _descriptor.channels;
        }
        
        /**
         * Return a sample for the given channel and frame index
         * @param channel the channel index of the sample
         * @param index the frame index of the sample within that channel
         */
        public function getChannelSample(channel:Number, index:Number):Number
        {
            return Vector.<Number>(channelData[channel])[index];
        }
        
        /**
         * Return an interpolated sample for a non-integral sample position.
         * Interpolation is always done within the same channel.
         */
        public function getInterpolatedSample(channel:Number, pos:Number):Number
        {
            var intPos:Number = int(pos);
            var fracPos:Number = pos - intPos;
            var data:Vector.<Number> = channelData[channel];
            var s1:Number = data[intPos];
            var s2:Number = data[intPos+1];
            return s1 + (fracPos * (s2 - s1));
        }
        
        /**
         * Return duration in seconds
         */
        public function get duration():Number
        {
            return Number(frameCount) / _descriptor.rate;
        }
        
        /**
         * Clear this sample. 
         */
        public function clear():void
        {
            var n:Number = frameCount;
            for (var c:Number = 0; c < channels; c++)
            {
                var data:Vector.<Number> = channelData[c];
                for (var i:Number = 0; i < n; i++)
                {
                    data[i] = 0;
                }
            }
        }
        

        ////////////////////////////////////////////        
        // IAudioSource interface implementation
        ////////////////////////////////////////////        
        
        /**
         * Get the AudioDescriptor for this Sample.
         */
        public function get descriptor():AudioDescriptor
        {
            return _descriptor;
        }
        
        public function get frameCount():Number
        {
            return channelData[0].length;
        }

        public function get position():Number
        {
            return _position;
        }
        
        public function resetPosition():void
        {
            _position = 0;
        }
        
        public function getSample(numFrames:Number):Sample
        {
            var sample:Sample = new Sample(descriptor);
            for (var c:Number = 0; c < channels; c++)
            {
                sample.channelData[c] = Vector.<Number>(channelData[c]).slice(_position, _position + numFrames);
            }
            _position += numFrames;
            
            return sample;
        }
        
        public function clone():IAudioSource
        {
            var sample:Sample = new Sample(descriptor);
            for (var c:Number = 0; c < channels; c++)
            {
                sample.channelData[c] = channelData[c];
            }
            return sample;
        }
    }
}
