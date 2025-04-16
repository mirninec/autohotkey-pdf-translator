
# AutoHotkey PDF Translator

This script allows you to quickly translate text selected in SumatraPDF from English to Russian using a simple mouse action. The translation is displayed in a separate window.

## Features

- 🖱️ Just select text in SumatraPDF and release the left mouse button — the script will automatically copy and translate it.
- 🌀 A "translating..." tooltip appears near the mouse cursor.
- 🌐 Uses the command-line translator [`trans`](https://github.com/soimort/translate-shell) running in WSL (Windows Subsystem for Linux).
- 📄 The translation result appears in a resizable window.
- 🔁 The translation window allows editing the original text and re-translating it.
- 💾 Remembers the position and size of the translation window between runs.

## Requirements

- [AutoHotkey v2](https://www.autohotkey.com/)
- [SumatraPDF](https://www.sumatrapdfreader.org/free-pdf-reader)
- [WSL (Windows Subsystem for Linux)](https://learn.microsoft.com/en-us/windows/wsl/)
- [`trans`](https://github.com/soimort/translate-shell) — install in your WSL environment

Example installation for `trans` in Ubuntu (WSL):

```bash
sudo apt update
sudo apt install translate-shell
```

## How it works

1. The script waits for the left mouse button to be released in SumatraPDF.
2. It simulates `Ctrl+C`, cleans up line breaks, and stores the selected text.
3. The text is passed to the `trans` utility via WSL.
4. The translation result is shown in a window with the ability to copy or edit the text.

## License

This project is licensed under the MIT License.

---

© [mirninec](https://github.com/mirninec)
