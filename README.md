# AURORA

**A 64-voice stereo granular instrument for Cycling '74 Max 8.**

Turn a sample into shifting clouds, scattered notes, reverse textures, and dense microloops. AURORA pairs a sample-clock Gen engine with a custom waveform interface, five presets, stereo effects, and direct WAV recording.

An original source sample is included. No third-party Max externals are required.

[Listen to the demo](AURORA_Demo.wav) · [Audio validation](docs/VALIDATION.md) · [MIT license](LICENSE)

## Quick start

1. Download this repository using **Code → Download ZIP**, then extract it, or clone it:
   ```sh
   git clone https://github.com/AtsuyaTsuchida/aurora-max8.git
   ```
2. Keep the files together and open **`AURORA.maxpat`** in Max 8.
3. Press **PLAY** or **Space**. Audio processing starts automatically.
4. Try the five preset buttons, drag the waveform, and turn the knobs.
5. Use **LOAD SAMPLE** to open your own audio file. **DEMO** restores the included source.

The default output level is **−15 dB**. Adjust **OUTPUT** to taste. **STOP** fades the instrument out; **AUDIO OFF** turns off Max's audio processing.

### Requirements

- Cycling '74 Max 8 with its bundled Gen and MSP objects.
- Tested in **Max 8.6.5 on macOS**. Other versions and platforms have not been verified.
- A valid Max license or trial is needed for any editing or saving features that require it. This repository does not include Max.
- Python and Node.js are only needed for development tasks below, not for playing the instrument.

## Features

- Up to **64 simultaneous stereo grains**, scheduled at audio sample rate.
- Independent source scanning and pitch transposition.
- Four-point cubic sample interpolation and source-rate compensation.
- Hann-based grain envelopes, position spread, timing scatter, pitch spread, and probabilistic reverse playback.
- Equal-power grain panning and stereo width control.
- Soft saturation and a stereo state-variable low-pass filter.
- Ping-pong delay and a four-line feedback-network reverb.
- DC removal and a stereo-linked look-ahead limiter.
- Five factory presets, gentle parameter mutation, JSON state files, and **24-bit stereo WAV recording**.

## Controls

| Gesture or shortcut | Action |
| --- | --- |
| Drag a knob vertically | Change its value |
| Shift + drag a knob | Fine adjustment |
| Double-click a knob | Restore its default value |
| Drag the waveform | Move the source position |
| Space | Play / stop |
| F | Freeze / resume source scanning |
| 1–5 | Select a factory preset |
| MUTATE | Make small random changes to selected parameters |

Keyboard shortcuts apply when the AURORA window is active. Preset changes and MUTATE preserve the output level.

| Section | Parameters |
| --- | --- |
| **Source Motion** | **Position** sets the source offset. **Scan** controls traversal speed, including backward motion. **Spray** spreads grain starts around the playhead. |
| **Grain Cloud** | **Grain Size**: 10–500 ms. **Density**: 2–100 grains per second. **Scatter** randomizes onset intervals. |
| **Pitch & Stereo** | **Pitch**: ±24 semitones. **Detune** adds per-grain pitch variation. **Reverse** sets reverse-playback probability. **Width** controls the panning range. |
| **Shape & Color** | **Contour** focuses the grain envelope. **Lowpass** and **Resonance** shape the spectrum. **Warmth** adds soft saturation. |
| **Space & Time** | **Space** and **Decay** control reverb. **Echo**, **Time**, and **Feedback** control stereo repeats; the right delay uses a 4:3 time ratio. |
| **Output** | Master gain before the linked limiter. |

**Freeze holds the scan position, not the entire sound.** Grains continue to be generated, and spray, detune, and other variations remain active. Pitch values are relative to the source; the included source has a C3 fundamental.

## Presets and audio demo

[AURORA_Demo.wav](AURORA_Demo.wav) contains five excerpts recorded from Max, in this order:

| Start | Preset | Character |
| --- | --- | --- |
| 0.0 s | Glass Garden | Clear, gently moving texture |
| 4.2 s | Velvet Cloud | Low, thick, diffuse cloud |
| 8.4 s | Prism Rain | Short grains and broad pitch scatter |
| 12.6 s | Tape Orbit | Warm repeats with reverse grains |
| 16.8 s | Micro Bloom | Dense clusters of tiny grains |

The demo applies a uniform **+9 dB** gain to the recorded excerpts and fades their edges. The source sample is an original, procedurally generated stereo recording included as `AURORA_Source.wav`.

## Save a sound or record a performance

**SAVE STATE** writes the current parameters to a JSON file. **LOAD STATE** restores them. State files do not embed audio, the elapsed scan position, active grains, or effect tails. Keep any custom source files alongside your saved sounds.

While the instrument is playing, click **REC WAV**, choose a filename, and recording starts after the file dialog closes. Click **STOP REC** to finish and close the file. Recording captures the stereo signal after the limiter, at the current Max audio sample rate, with 24-bit depth.

## Source and development

| File | Purpose |
| --- | --- |
| `AURORA.maxpat` | Main patch, signal routing, dialogs, and keyboard shortcuts |
| `aurora_ui.js` | Custom interface, controls, presets, and state serialization |
| `aurora_engine_v2.gendsp` | Playable Gen DSP patch |
| `src/aurora_engine.genexpr` | Plain-text source for the Gen codebox |
| `tools/build.py` | Rebuilds the main patch, Gen patch, and original source sample |
| `AURORA_Source.wav` | 12-second, 48 kHz, 24-bit stereo source |
| `AURORA_Demo.wav` | 21-second listening demo recorded from Max |

To regenerate the patch files and source sample from this repository's root:

```sh
python3 -m venv .venv
source .venv/bin/activate
python -m pip install -r requirements-dev.txt
python tools/build.py
```

The build replaces `AURORA.maxpat`, `aurora_engine_v2.gendsp`, and `AURORA_Source.wav`. It leaves the UI script and recorded demo alone. Edit the generator for persistent changes to generated patch routing, and edit `src/aurora_engine.genexpr` for DSP changes.

Run the existing UI logic and state serialization checks with Node.js:

```sh
node tests/test_ui.cjs
node tests/test_state_io.cjs
```

These checks use lightweight stand-ins for Max APIs. They do **not** replace testing the patch in Max. See [the validation notes](docs/VALIDATION.md) for the real audio tests and their scope.

## Implementation notes

Each grain keeps its duration, start position, playback rate, pan, envelope shape, and amplitude for its lifetime. The voice pool does not steal active grains: a new onset is skipped if all 64 slots are occupied. The displayed grain dots are an illustrative visualization; the active-grain count comes from the DSP engine.

Cubic interpolation is not a band-limited resampler. Large upward transpositions can introduce aliasing. This is a sample-based, continuously running granular instrument; this version does not implement a MIDI note-input mode.

## License

The code and included original audio are distributed under the [MIT License](LICENSE). Cycling '74 Max remains separately licensed by its vendor.
