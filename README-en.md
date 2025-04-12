# Automatic Text Translator for SumatraPDF

This [AutoHotkey v2](https://www.autohotkey.com/) script automatically translates selected text in SumatraPDF from English to Russian when the left mouse button is released. The translated text is displayed in a separate window, and the window’s position is saved between sessions.

## 🧩 Features

- Captures selected text from SumatraPDF
- Translates via WSL using `translate-shell` (`trans`)
- Supports both single words and full phrases
- Neat popup window showing original and translated text
- Remembers window size and position
- Fully runs in the background

## 🛠️ Requirements

- **Windows 10/11**
- [AutoHotkey v2](https://www.autohotkey.com/) (version 2 is required!)
- Installed [WSL](https://learn.microsoft.com/en-us/windows/wsl/)
- Installed [`translate-shell`](https://github.com/soimort/translate-shell) in WSL:

  ```bash
  sudo apt update
  sudo apt install translate-shell
  ```

- `iconv` utility (usually pre-installed in WSL)

## ⚙️ Installation

1. Download the file `translator.ahk`.
2. Make sure the `trans` command works inside WSL.
3. Run the script using AutoHotkey v2.
4. Open a PDF document in [SumatraPDF](https://www.sumatrapdfreader.org/free-pdf-reader).
5. Select text and release the left mouse button — the translation window will appear.

## 🧪 Example Usage

1. Open an English PDF in SumatraPDF.
2. Select some text:
   ```
   Artificial intelligence is transforming industries.
   ```
3. Release the left mouse button.
4. See the translation window:
   ```
   Искусственный интеллект трансформирует отрасли.
   ```

## 📝 Settings

- The file `window_pos.ini` is created automatically in the script folder.
- It stores the window's size and position so it can reopen in the same place.

## ⛔ Exit the Script

Press the `Esc` key to exit the script.

## 📌 Notes

- The script is designed for SumatraPDF but can be adapted for other apps.
- The translation requires an internet connection — make sure WSL has access to the internet.

## 📄 License

MIT License — free to use, modify, and share.

---

**Author:** [mirninec]

If you find this script useful, consider giving it a ⭐ and feel free to suggest improvements!
