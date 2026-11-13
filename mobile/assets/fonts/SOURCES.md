# Bundled fonts

The app draws every screen with the fonts in this folder. Nothing is
downloaded at run time (student_app #1, item 8): a student who installs the
app on a weak network, or offline, sees the same letters as everyone else.

All four families are free fonts under the SIL Open Font License 1.1. Each
folder keeps the licence (`OFL.txt`) next to the font files, as the licence
requires, and the app shows the same text on its licence page
(`lib/theme/font_licenses.dart`).

| Family | Used for | Files |
| --- | --- | --- |
| Geist | Every English word and every digit (the design handoff's UI face) | Regular 400, Medium 500, SemiBold 600, Bold 700 |
| GeistMono | Technical values: request ids, versions, hosts | Medium 500 |
| Fraunces | Screen titles (the handoff's serif) | 9pt Regular 400 |
| NotoSansDevanagari | Hindi. Geist has no Devanagari, so the theme lists it as the fallback font (`lib/theme/student_theme.dart`) | Regular 400, Medium 500, SemiBold 600, Bold 700 |

Only the weights the screens use are bundled, to keep the APK small. The
static files were taken as published, not converted or subset.

## Where each file comes from

| File | Source | Pinned to | SHA-256 |
| --- | --- | --- | --- |
| `Geist/Geist-Regular.ttf` | https://github.com/vercel/geist-font/blob/ef2597cfc42f4797676df105517ccc0a1cfa6569/fonts/Geist/ttf/Geist-Regular.ttf | commit `ef2597cf` | `85a1c6b18a6b0a06dfe9fd4f6d6a5d4979f74ec861eaef4bc7868b5492b8a117` |
| `Geist/Geist-Medium.ttf` | https://github.com/vercel/geist-font/blob/ef2597cfc42f4797676df105517ccc0a1cfa6569/fonts/Geist/ttf/Geist-Medium.ttf | commit `ef2597cf` | `3a3b36f0d0b981f4857f7f00eeef4a5ee123605575d362ab31ee7c19e3d11f2f` |
| `Geist/Geist-SemiBold.ttf` | https://github.com/vercel/geist-font/blob/ef2597cfc42f4797676df105517ccc0a1cfa6569/fonts/Geist/ttf/Geist-SemiBold.ttf | commit `ef2597cf` | `b9f52322d6d20a7ff1e7fe1310ff12ec851aebb83d24f8b4f1d4149298f489b2` |
| `Geist/Geist-Bold.ttf` | https://github.com/vercel/geist-font/blob/ef2597cfc42f4797676df105517ccc0a1cfa6569/fonts/Geist/ttf/Geist-Bold.ttf | commit `ef2597cf` | `3f21f02b827228c3f0c5fb230d027b5a1a263013618e8052bc1b3c5692812c88` |
| `Geist/OFL.txt`, `GeistMono/OFL.txt` | https://github.com/vercel/geist-font/blob/ef2597cfc42f4797676df105517ccc0a1cfa6569/OFL.txt | commit `ef2597cf` | |
| `GeistMono/GeistMono-Medium.ttf` | https://github.com/vercel/geist-font/blob/ef2597cfc42f4797676df105517ccc0a1cfa6569/fonts/GeistMono/ttf/GeistMono-Medium.ttf | commit `ef2597cf` | `6fa6a795c17a11bcbef410f52a853e8503f8e25d92762d202d907c54f5c0c0fb` |
| `Fraunces/Fraunces9pt-Regular.ttf` | https://github.com/undercasetype/Fraunces/blob/7ccdec31c6028118dce3e47fe864e3744460371d/fonts/ttf/Fraunces9pt-Regular.ttf | commit `7ccdec31` | `54f7ec6290e8ddb967e1ebddd2cadb706d6b448254e3489c04f2bcd265db5fa2` |
| `Fraunces/OFL.txt` | https://github.com/undercasetype/Fraunces/blob/7ccdec31c6028118dce3e47fe864e3744460371d/OFL.txt | commit `7ccdec31` | |
| `NotoSansDevanagari/NotoSansDevanagari-Regular.ttf` | https://github.com/notofonts/devanagari/releases/download/NotoSansDevanagari-v2.007/NotoSansDevanagari-v2.007.zip, `NotoSansDevanagari/unhinted/ttf/` | release `NotoSansDevanagari-v2.007` | `9c7d935139ea6a1e6ad9dbac4f6d27ece1e04bca8123c8888d00a0f9df4724cd` |
| `NotoSansDevanagari/NotoSansDevanagari-Medium.ttf` | same release zip, `NotoSansDevanagari/unhinted/ttf/` | release `NotoSansDevanagari-v2.007` | `bf141458ba69442b40126ec3ae083289dd3ca54bae43d5cbc6e27a59a8cfdc44` |
| `NotoSansDevanagari/NotoSansDevanagari-SemiBold.ttf` | same release zip, `NotoSansDevanagari/unhinted/ttf/` | release `NotoSansDevanagari-v2.007` | `efaa7d3f82ef6898e3fa79101f0d2b5ab9a25554296044123b402b7b571311b9` |
| `NotoSansDevanagari/NotoSansDevanagari-Bold.ttf` | same release zip, `NotoSansDevanagari/unhinted/ttf/` | release `NotoSansDevanagari-v2.007` | `ff2f76a23aad41e0608c2d7dbc4bacd247ff3bec78f0ec2a8fb106b561636e58` |
| `NotoSansDevanagari/OFL.txt` | same release zip, `OFL.txt` | release `NotoSansDevanagari-v2.007` | |

To check a file: `sha256sum assets/fonts/<Family>/<file>.ttf` must print the
value above.
