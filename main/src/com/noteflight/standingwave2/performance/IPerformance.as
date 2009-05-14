////////////////////////////////////////////////////////////////////////////////
//
//  NOTEFLIGHT LLC
//  Copyright 2007-2008 Noteflight LLC
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

package com.noteflight.standingwave2.performance
{
    import __AS3__.vec.Vector;
    
    import com.noteflight.standingwave2.elements.AudioDescriptor;
    
    /**
     * An IPerformance is a queryable set of PerformanceElements.  Only time-range queries may be performed.
     */
    public interface IPerformance
    {
        /**
         * Obtain a list of of PerformanceElements in this performance, ordered by starting frame index,
         * whose starting frame lies in a given range.
         * 
         * @param start frame count of range start (inclusive)
         * @param end frame count of the range end (exclusive)
         */
        function getElementsInRange(start:Number, end:Number):Vector.<PerformanceElement>;
        
        /**
         * The AudioDescriptor describing the audio characteristics of this performance.
         */
        function get descriptor():AudioDescriptor;

        /**
         * The number of sample frames in this performance. 
         */        
        function get frameCount():Number;
        
        /**
         * Obtain a clone of this performance, preserving all of its timing information but
         * cloning all contained audio sources. 
         */
        function clone():IPerformance;
    }
}