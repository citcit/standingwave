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
     * An IRandomAccessSource is an interface implemented by IAudioSources that
     * expose the ability to extract any desired subrange at will, given its
     * starting and ending index.
     */
    public interface IRandomAccessSource
    {
        /**
         * Return a Sample representing a concrete subrange of this source.
         *  
         * @param fromOffset the starting point of the range (inclusive)
         * @param toOffset the endpoint of the range (exclusive)
         */
        function getSampleRange(fromOffset:Number, toOffset:Number):Sample;
    }
}