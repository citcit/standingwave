StandingWave is an AS3 code library designed for high level control of
Flash Player 10's SampleDataEvent API for streaming audio output.  It
is based on a subset of the audio engine used by the [Noteflight](http://www.noteflight.com) Score
Editor.

**Note: This library has been superseded by StandingWave 3, which can be found on the [standingwave3 github repository](http://github.com/maxl0rd/standingwave3).**

The goal of StandingWave is to encapsulate the following kinds of objects, permitting them to be easily chained together and combined to produce complex, dynamic audio output:

  * audio sources (MP3 or WAV files, algorithmic sound generators...)
  * audio filters (echo, envelope shaping, equalization...)
  * timed sequences of audio sources, which may be hierarchically composed

For example, the following code snippet plays a synthesized sine wave with a calculated amplitude envelope:

```
   var source:IAudioSource = new SineSource(new AudioDescriptor(), duration, freq);
   source = new EnvelopeFilter(source, attack, decay, sustain, hold, release);
   new AudioPlayer().play(source);
```

There are no fundamental musical concepts embodied in StandingWave, but it may be straightforwardly extended with such, for instance by reading MIDI files or by writing utility classes to manage tones, scales, instruments, and so forth.