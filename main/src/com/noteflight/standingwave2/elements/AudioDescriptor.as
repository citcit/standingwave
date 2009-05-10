////////////////////////////////////////////////////////////////////////////////
//
//  NOTEFLIGHT LLC
//  Copyright 2007-2008 Noteflight LLC
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

package com.noteflight.standingwave2.elements
{
    /**
     * An AudioDescriptor describes the characteristics of an audio stream in terms of
     * number of channels, bits per sample and sample rate.  Every IAudioSource instance
     * is associated with a AudioDescriptor that indicates what kind of audio data is
     * available from it. 
     */
    public class AudioDescriptor
    {
        // Audio-related constants
        public static const CHANNELS_MONO:uint = 1;
        public static const CHANNELS_STEREO:uint = 2;
        
        public static const RATE_44100:uint = 44100;
        public static const RATE_22050:uint = 22050;
        public static const RATE_11025:uint = 11025;
        public static const RATE_5512:uint = 5512;

        /** Sampling rate in Hz */
        private var _rate:uint;
        
        /** Number of channels */
        private var _channels:uint;
        
        public function AudioDescriptor(rate:uint = RATE_44100, channels:uint = CHANNELS_STEREO)
        {
            _rate = rate;
            _channels = channels;
        }
        
        /** Sampling rate in Hz */
        public function get rate():uint
        {
            return _rate;
        }
        
        /** Number of channels */
        public function get channels():uint
        {
            return _channels;
        }
    }
}