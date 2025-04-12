

# Автоматический переводчик текста из SumatraPDF

Этот скрипт [AutoHotkey v2](https://www.autohotkey.com/) автоматически переводит выделенный текст в SumatraPDF с английского на русский язык при отпускании левой кнопки мыши. Переведённый текст отображается в отдельном окне, позиция которого сохраняется между запусками.

## 🧩 Основные возможности

- Перехват выделенного текста в SumatraPDF
- Перевод через WSL и `translate-shell` (`trans`)
- Поддержка как отдельных слов, так и фраз
- Удобное всплывающее окно с оригиналом и переводом
- Сохранение позиции и размера окна
- Работа полностью в фоновом режиме

## 🛠️ Требования

- **Windows 10/11**
- [AutoHotkey v2](https://www.autohotkey.com/) (обязательно v2!)
- Установленный [WSL](https://docs.microsoft.com/ru-ru/windows/wsl/)
- Установленная в WSL утилита [`translate-shell`](https://github.com/soimort/translate-shell):
  
  ```bash
  sudo apt update
  sudo apt install translate-shell
  ```

- Утилита `iconv` (обычно предустановлена в WSL)

## ⚙️ Установка

1. Скачайте файл `translator.ahk`.
2. Убедитесь, что в WSL работает команда `trans`.
3. Запустите скрипт через AutoHotkey v2.
4. Откройте PDF-документ в [SumatraPDF](https://www.sumatrapdfreader.org/free-pdf-reader).
5. Выделите текст и отпустите левую кнопку мыши — появится окно с переводом.

## 🧪 Пример использования

1. Открываете PDF-документ на английском языке в SumatraPDF.
2. Выделяете текст:
   ```
   Artificial intelligence is transforming industries.
   ```
3. Отпускаете левую кнопку мыши.
4. Получаете окно с переводом:
   ```
   Искусственный интеллект трансформирует отрасли.
   ```

## 📝 Настройки

- Файл `window_pos.ini` создаётся автоматически в папке скрипта.
- В нём хранится позиция и размер окна перевода, чтобы при следующем запуске оно появилось в том же месте.

## ⛔ Выход из скрипта

Нажмите клавишу `Esc`, чтобы выйти из скрипта.

## 📌 Примечания

- Скрипт ориентирован на работу с SumatraPDF, но его легко адаптировать под другие программы.
- Перевод выполняется через интернет — убедитесь, что у WSL есть доступ в сеть.

## 📄 Лицензия

MIT License — свободное использование, изменение и распространение.

---

**Автор:** [mirninec]

Если вам понравился скрипт — поставьте ⭐ и предложите улучшения!


