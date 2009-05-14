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
     * An IAudioFilter is an IAudioSource whose signal is derived from
     * some transformation of another IAudioSource.
     */
    public interface IAudioFilter extends IAudioSource
    {
        /**
         * The source of the signal for this audio filter.
         */
        function get source():IAudioSource;
        function set source(s:IAudioSource):void;
    }
}