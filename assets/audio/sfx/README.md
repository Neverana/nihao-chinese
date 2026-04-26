# Sound Effects Guide

## Files (all CC0 licensed)

| SFX type | Filename | Source |
|----------|----------|--------|
| Click | `click.wav` | Kenney Interface Sounds (CC0) |
| Correct | `correct.wav` | Kenney Interface Sounds (CC0) |
| Wrong | `wrong.wav` | Kenney Interface Sounds (CC0) |
| Complete | `complete.wav` | Kenney Interface Sounds (CC0) |
| Achievement | `achievement.wav` | trophyso/example-study-platform (CC0) |

## Notes

- Files are placed in `assets/audio/sfx/` and declared in `pubspec.yaml`.
- Format: WAV (PCM, 16-bit, 44.1kHz, stereo) — cross-platform compatible.
- `AudioService.playSfx(SfxType.xxx)` triggers playback.

## Replacement

To replace a sound, simply drop a new file with the same name (WAV format, 44.1kHz, stereo, PCM 16-bit) into this folder and run `flutter clean && flutter pub get`.
