////////////////////////////////////////////////////////////////////////////////
//
//  NOTEFLIGHT LLC
//  Copyright 2007-2008 Noteflight LLC
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

package com.noteflight.standingwave2.elements
{
    import flexunit.framework.TestCase;

    public class AudioTestCase extends TestCase
    {
        protected var s1:Sample;
        
        override public function setUp():void
        {
            s1 = new Sample(new AudioDescriptor(AudioDescriptor.RATE_22050, AudioDescriptor.CHANNELS_STEREO), 4);
            var i:Number = 0;
            s1.channelData[0][i++] = 200;
            s1.channelData[0][i++] = 400;
            s1.channelData[0][i++] = 600;
            s1.channelData[0][i++] = 800;
            i = 0;
            s1.channelData[1][i++] = -100;
            s1.channelData[1][i++] = -200;
            s1.channelData[1][i++] = -300;
            s1.channelData[1][i++] = -400;
       }
    }
}