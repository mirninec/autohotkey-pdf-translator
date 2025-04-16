# 📘 AutoHotkey PDF Translator

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![AutoHotkey v2](https://img.shields.io/badge/AutoHotkey-v2-green.svg)](https://www.autohotkey.com/)
[![WSL + Translate Shell](https://img.shields.io/badge/WSL+trans-shell-lightgrey)](https://github.com/soimort/translate-shell)

> 🔤 Мгновенный перевод выделенного текста в **SumatraPDF** с английского на русский, без наворотов и с фокусом на удобство.  
> ✍️ Разработано пользователем [mirninec](https://github.com/mirninec)

---

## ✨ Возможности

-   🔍 Автоматический перевод текста по отпусканию ЛКМ
-   ⌨️ Режим только копирования (Ctrl + ЛКМ)
-   🧹 Очистка текста от переносов строк
-   💬 Всплывающее окно с оригиналом и переводом
-   🔁 Возможность редактирования и повторного перевода
-   🪟 Запоминает позицию и размер окна

---

## 📸 Скриншот

![Скриншот](Screenshot.jpg) 

---

## 🧰 Требования

-   **Windows 10 или 11**
-   [AutoHotkey v2](https://www.autohotkey.com/)
-   [WSL (Windows Subsystem for Linux)](https://learn.microsoft.com/ru-ru/windows/wsl/)
-   Установленный [translate-shell](https://github.com/soimort/translate-shell) внутри WSL

---

## ⚙️ Установка

1. Установите AutoHotkey v2 с [официального сайта](https://www.autohotkey.com/download/).
2. Настройте WSL (например, Ubuntu):

    ```bash
    wsl --install
    ```

3. Внутри WSL установите translate-shell:

    ```bash
    sudo apt update
    sudo apt install translate-shell
    ```

4. Клонируйте репозиторий:

    ```bash
    git clone https://github.com/mirninec/autohotkey-pdf-translator.git
    cd autohotkey-pdf-translator
    ```

5. Запустите `autohotkey-pdf-translator.ahk` двойным щелчком или через автозагрузку.

---

## 🖱 Как пользоваться

| Действие                  | Описание                                                    |
| ------------------------- | ----------------------------------------------------------- |
| Выделение текста мышью    | Автоматический перевод                                      |
| Ctrl + Выделение текста   | Только копирование (без перевода), переносы строк удаляются |
| Esc                       | Закрытие окна перевода                                      |
| Кнопка «Перевести» в окне | Повторный перевод отредактированного текста                 |

---

## 🧪 Замечания

-   Работает только в окне `SumatraPDF` (проверяется `ahk_class SUMATRA_PDF_FRAME`).
-   Использует `trans` через WSL, поэтому необходимо рабочее подключение к интернету.
-   Все временные файлы создаются в каталоге скрипта.

---

## 📝 Лицензия

Проект распространяется по лицензии [MIT License](LICENSE).

---

> © [mirninec](https://github.com/mirninec) | Сделано с ❤️ и AutoHotkey
