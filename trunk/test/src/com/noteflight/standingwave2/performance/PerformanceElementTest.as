////////////////////////////////////////////////////////////////////////////////
//
//  NOTEFLIGHT LLC
//  Copyright 2007-2008 Noteflight LLC
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

package com.noteflight.standingwave2.performance
{
    import com.noteflight.standingwave2.elements.AudioTestCase;
        
    public class PerformanceElementTest extends AudioTestCase
    {
        public function testSource():void
        {
            var p:PerformanceElement = new PerformanceElement(10 / 22050.0, s1);
            assertEquals("source", s1, p.source);
            assertEquals("start", 10, p.start);
            assertEquals("end", 10 + s1.frameCount, p.end);
            assertEquals("startTime", 10 / 22050, p.startTime);
            assertEquals("endTime", (10 + s1.frameCount) / 22050, p.endTime);
        }
    }
}