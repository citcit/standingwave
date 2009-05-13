////////////////////////////////////////////////////////////////////////////////
//
//  NOTEFLIGHT LLC
//  Copyright 2007-2008 Noteflight LLC
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

package
{    
    import com.noteflight.standingwave2.elements.SampleTest;
    import com.noteflight.standingwave2.filters.CacheFilterTest;
    import com.noteflight.standingwave2.filters.EnvelopeFilterTest;
    import com.noteflight.standingwave2.filters.ResamplingFilterTest;
    import com.noteflight.standingwave2.performance.AudioPerformerTest;
    import com.noteflight.standingwave2.performance.ListPerformanceTest;
    import com.noteflight.standingwave2.performance.PerformanceElementTest;
    
    import flexunit.framework.TestSuite;
    
    public class StandingwaveTestSuite
    {
        public static function suite() : TestSuite
        {
            var testSuite:TestSuite = new TestSuite();

            testSuite.addTestSuite( SampleTest );
            testSuite.addTestSuite( PerformanceElementTest );
            testSuite.addTestSuite( ListPerformanceTest );
            testSuite.addTestSuite( AudioPerformerTest );
            testSuite.addTestSuite( EnvelopeFilterTest );
            testSuite.addTestSuite( CacheFilterTest );
            testSuite.addTestSuite( ResamplingFilterTest );

            return testSuite;
        }
    }
}
