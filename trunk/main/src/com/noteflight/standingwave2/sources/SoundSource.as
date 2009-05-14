////////////////////////////////////////////////////////////////////////////////
//
//  NOTEFLIGHT LLC
//  Copyright 2007-2008 Noteflight LLC
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

package com.noteflight.standingwave2.sources
{
    import __AS3__.vec.Vector;
    
    import com.noteflight.standingwave2.elements.AudioDescriptor;
    import com.noteflight.standingwave2.elements.IAudioSource;
    import com.noteflight.standingwave2.elements.Sample;
    
    import flash.media.Sound;
    import flash.utils.ByteArray;
    
    /**
     * A SoundSource serves as a source of stereo 44.1k sound extracted from an underlying
     * Flash Player Sound object. 
     */
    public class SoundSource extends AbstractSource
    {
        /** Underlying sound for this source. */
        private var _sound:Sound;

        public function SoundSource(sound:Sound)
        {
            super(new AudioDescriptor(44100, 2), (sound.length / 1000.0), 1.0);
            _sound = sound;
        }

        public function get sound():Sound
        {
            return _sound;
        }
        
        override public function getSample(numFrames:Number):Sample
        {
            var sample:Sample = new Sample(descriptor, numFrames);
            var chan0:Vector.<Number> = sample.channelData[0];
            var chan1:Vector.<Number> = sample.channelData[1];
            
            var bytes:ByteArray = new ByteArray();
            _sound.extract(bytes, numFrames, _position);
            bytes.position = 0;

            for (var i:Number = 0; i < numFrames; i++)
            {
                chan0[i] = bytes.readFloat();
                chan1[i] = bytes.readFloat();
            }
            
            _position += numFrames;
            
            return sample;
        }
        
        override public function clone():IAudioSource
        {
            return new SoundSource(sound);
        }
    }
}
