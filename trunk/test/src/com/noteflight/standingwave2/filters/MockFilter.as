////////////////////////////////////////////////////////////////////////////////
//
//  NOTEFLIGHT LLC
//  Copyright 2007-2008 Noteflight LLC
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

package com.noteflight.standingwave2.filters
{
    import com.noteflight.standingwave2.elements.IAudioSource;
    import com.noteflight.standingwave2.elements.Sample;
    
    public class MockFilter extends AbstractFilter
    {
        public var requests:Array = [];
        
        public function MockFilter(source:IAudioSource)
        {
            super(source);
        }
        
        override public function getSample(numFrames:Number):Sample
        {
            requests.push(numFrames);
            return source.getSample(numFrames);
        }
    }
}