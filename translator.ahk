#Requires AutoHotkey v2.0
#Warn
#SingleInstance Force
FileEncoding "UTF-8"

; === Глобальные переменные ===
global currentGui := unset
global lastClipboard := ""
global isTranslating := false
global iniFile := A_ScriptDir "\window_pos.ini"

; === Основной хоткей — отпускание ЛКМ в SumatraPDF ===
~LButton Up::
{
    if isTranslating || !WinActive("ahk_class SUMATRA_PDF_FRAME")
        return

    SetTimer(() => TryCopyAndTranslate(), -100)
}

; === Попытка скопировать выделенный текст и перевести ===
TryCopyAndTranslate() {
    global lastClipboard, isTranslating

    A_Clipboard := ""
    Send("^c")

    if !ClipWait(0.5)
        return

    selected := RegExReplace(Trim(A_Clipboard), "[\r\n]+", " ")
    if (selected = "" || selected = lastClipboard)
        return

    lastClipboard := selected
    isTranslating := true

    TranslateAndShow(selected)
}

; === Выполнить перевод текста и отобразить результат ===
TranslateAndShow(text) {
    global isTranslating

    escapedText := StrReplace(text, "`"", "\`"")
    isSingleWord := !RegExMatch(escapedText, "\s")

    try {
        ; Выбор команды в зависимости от типа текста
        if isSingleWord {
            command := 'wsl.exe trans en:ru "' escapedText '" | iconv -f UTF-8 -t CP1251'
        } else {
            command := 'wsl.exe trans en:ru -b "' escapedText '" | iconv -f UTF-8 -t CP1251'
        }

        translation := ExecAndGetOutput(command)

        if (translation != "") {
            ShowResultWindow(text, translation)
        } else {
            MsgBox("Перевод не получен.", "Ошибка", 48)
        }
    }
    catch as e {
        MsgBox("Ошибка перевода: " e.Message, "Ошибка", 16)
    }

    isTranslating := false
}

; === Запуск внешней команды и получение вывода ===
ExecAndGetOutput(command) {
    try {
        shell := ComObject("WScript.Shell")
        exec := shell.Exec(command)
        output := ""
        while !exec.StdOut.AtEndOfStream {
            output .= exec.StdOut.ReadLine() . "`n"
        }
        return Trim(output)
    } catch {
        return ""
    }
}

; === Отображение окна с результатом перевода ===
ShowResultWindow(original, translation) {
    global currentGui
    static iniFile := A_ScriptDir "\window_pos.ini"

    ; Уничтожить предыдущее окно, если есть
    if IsSet(currentGui) {
        try currentGui.Destroy()
    }

    currentGui := Gui("+AlwaysOnTop", "Перевод")
    currentGui.SetFont("s14", "Segoe UI")
    currentGui.AddText("w700", "Оригинал:")
    currentGui.AddEdit("ReadOnly w600 r12 Multi", original)
    currentGui.AddText("w700", "Перевод:")
    currentGui.AddEdit("ReadOnly w600 r18 Multi", translation)

    ; Кнопка "Закрыть"
    closeBtn := currentGui.AddButton("Default w100", "Закрыть")
    closeBtn.OnEvent("Click", (*) => SaveAndClose())

    ; Позиция окна
    x := IniRead(iniFile, "Window", "X", "")
    y := IniRead(iniFile, "Window", "Y", "")
    w := IniRead(iniFile, "Window", "W", "")
    h := IniRead(iniFile, "Window", "H", "")

    showOptions := ""
    if (x != "" && y != "")
        showOptions .= " x" x " y" y
    else
        showOptions .= " Center"
    if (w != "" && h != "")
        showOptions .= " w" w " h" h

    currentGui.Show(showOptions)

    ; Сохранение и закрытие
    SaveAndClose() {
        global currentGui, iniFile
        currentGui.GetPos(&gx, &gy, &gw, &gh)
        IniWrite(gx, iniFile, "Window", "X")
        IniWrite(gy, iniFile, "Window", "Y")
        IniWrite(gw, iniFile, "Window", "W")
        IniWrite(gh, iniFile, "Window", "H")
        currentGui.Destroy()
        currentGui := unset
    }
}

; === Сохранение позиции и закрытие окна ===
SaveAndClose() {
    global currentGui, iniFile
    currentGui.GetPos(&gx, &gy, &gw, &gh)
    IniWrite(gx, iniFile, "Window", "X")
    IniWrite(gy, iniFile, "Window", "Y")
    IniWrite(gw, iniFile, "Window", "W")
    IniWrite(gh, iniFile, "Window", "H")
    currentGui.Destroy()
    currentGui := unset
}

; === Выход по Esc (на всякий случай) ===
Esc:: ExitApp