////////////////////////////////////////////////////////////////////////////////
//
//  NOTEFLIGHT LLC
//  Copyright 2009 Noteflight LLC
// 
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
////////////////////////////////////////////////////////////////////////////////


package com.noteflight.standingwave2.sources
{
    import __AS3__.vec.Vector;
    
    import com.noteflight.standingwave2.elements.AudioDescriptor;
    import com.noteflight.standingwave2.elements.IAudioSource;
    
    /**
     * A SineSource provides a source whose signal in all channels is a pure sine wave of a given frequency. 
     */
    public class SineSource extends AbstractSource
    {
        /** Audio descriptor for this source. */
        public var frequency:Number;

        public function SineSource(descriptor:AudioDescriptor, duration:Number, frequency:Number, amplitude:Number = 0.5)
        {
            super(descriptor, duration, amplitude);
            this.frequency = frequency;
        }

        override protected function generateChannel(data:Vector.<Number>, channel:Number, numFrames:Number):void
        {
            var factor:Number = frequency * Math.PI * 2 / descriptor.rate;
            for (var i:Number = 0; i < numFrames; i++)
            {
                data[i] = Math.sin((_position + i) * factor) * amplitude;
            }
        }
        
        override public function clone():IAudioSource
        {
            return new SineSource(descriptor, duration, frequency, amplitude);
        }
    }
}
