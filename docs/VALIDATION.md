# Validation notes

## Real Max audio checks

Tested on 2026-09-28 in Max 8.6.5 on macOS. The included 48 kHz source was played through a 44.1 kHz DSP session. Each of the five presets was recorded from the instrument's post-limiter output to a 24-bit stereo WAV file for approximately 4.85 seconds.

Every recording contained non-silent audio and different left/right signals. The decoded PCM values were finite, and no samples reached the clipping threshold of 0.999 full scale. These are checks on the captured examples, not a proof that every possible parameter combination or source is artifact-free.

| Preset | Peak, dBFS | RMS, dBFS | Clipped samples |
| --- | ---: | ---: | ---: |
| Glass Garden | −23.96 | −37.42 | 0 |
| Velvet Cloud | −21.60 | −34.75 | 0 |
| Prism Rain | −19.58 | −38.64 | 0 |
| Tape Orbit | −22.13 | −34.44 | 0 |
| Micro Bloom | −23.45 | −39.62 | 0 |

The measurements precede the demo file's +9 dB playback gain. Machine-readable measurements are in [audio-validation.json](audio-validation.json).

The Max interface displayed the source waveform, changing active-grain counts, and output meters. Keyboard playback and preset switching were exercised. Mouse preset selection and knob dragging were also confirmed manually by the user.

## Logic checks

The included Node.js checks cover preset hit testing, play-state changes, knob dragging, parameter serialization, and a state-file round trip. They use mocked Max drawing and file APIs. They do not validate native file-dialog behavior or DSP compilation.

## Test scope

Other Max versions, operating systems, audio sample rates, prolonged high-load operation, and every third-party source file have not been tested. Max is required to rerun the audio checks; the repository does not provide a headless DSP test runner.
