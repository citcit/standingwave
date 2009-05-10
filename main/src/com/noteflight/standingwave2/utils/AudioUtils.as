////////////////////////////////////////////////////////////////////////////////
//
//  NOTEFLIGHT LLC
//  Copyright 2007-2008 Noteflight LLC
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

package com.noteflight.standingwave2.utils
{
    public class AudioUtils
    {
        /** The base 10 exponent multiplier for decibels. */
        public static const DECIBELS_PER_DECADE:Number = 20.0;
        
        /** The smallest audible signal strength. */
        public static const MINIMUM_SIGNAL:Number = 1.0 / 65536.0;
        
        /** The smallest parametric control signal. */
        public static const MINIMUM_CONTROL:Number = 1.0 / 128.0;
        
        /** The decibel gain at which a sound becomes inaudible at 16 bit sample size. */
        public static const ZERO_GAIN_DECIBELS:Number = factorToDecibels(MINIMUM_SIGNAL);
        
        /** The natural log of the gain of an inaudible sound. */
        public static const MINIMUM_CONTROL_LN:Number = Math.log(MINIMUM_CONTROL);
        
        /**
         * Convert a gain in decibels to a pure proportional factor. 
         */
        public static function decibelsToFactor(dB:Number):Number
        {
            return Math.exp(dB * Math.LN10 / DECIBELS_PER_DECADE);
        }
        
        /**
         * Convert a pure proportional factor to a gain in decibels. 
         */
        public static function factorToDecibels(gain:Number):Number
        {
            return Math.log(gain) * Math.LOG10E * DECIBELS_PER_DECADE;
        }
        
        /**
         * Compute a normalized concave unipolar control signal going from +1 to 0
         * as the input goes from 0 to +1; 
         */
        public static function concaveUnipolar(parameter:Number):Number
        {
            return Math.log(Math.max(MINIMUM_CONTROL, parameter)) / MINIMUM_CONTROL_LN;
        }
    }
}