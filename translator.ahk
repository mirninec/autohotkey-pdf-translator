#Requires AutoHotkey v2.0
#Warn
#SingleInstance Force
FileEncoding "UTF-8"

; === Глобальные переменные ===
global currentGui := unset
global lastClipboard := ""
global isTranslating := false
global iniFile := A_ScriptDir "\window_pos.ini"
global originalEdit, translationEdit
global loadingGui := unset
global hLoadingCursor := LoadLoadingCursor()

; === Загрузка курсора ожидания ===
LoadLoadingCursor() {
    ; Создаем временный курсор (вращающееся кольцо)
    hCursor := DllCall("LoadCursor", "UInt", 0, "UInt", 32650) ; IDC_APPSTARTING
    return hCursor
}

; === Основной хоткей — отпускание ЛКМ в SumatraPDF ===
~LButton Up::
{
    if !WinActive("ahk_class SUMATRA_PDF_FRAME")
        return

    if GetKeyState("Ctrl", "P") {
        ; Копирование текста с удалением переносов строк, если зажат Ctrl
        A_Clipboard := ""
        Send("^c")
        if ClipWait(0.5) {
            cleanedText := RegExReplace(Trim(A_Clipboard), "[\r\n]+", " ")
            A_Clipboard := cleanedText
        }
        return
    }

    if isTranslating
        return

    SetTimer(() => TryCopyAndTranslate(), -100)
}

; === Попытка скопировать выделенный текст и перевести ===
TryCopyAndTranslate() {
    global lastClipboard, isTranslating, hLoadingCursor

    A_Clipboard := ""
    Send("^c")

    if !ClipWait(0.5)
        return

    selected := RegExReplace(Trim(A_Clipboard), "[\r\n]+", " ")
    if (selected = "" || selected = lastClipboard)
        return

    lastClipboard := selected
    isTranslating := true

    ; Показать курсор ожидания
    DllCall("SetCursor", "Ptr", hLoadingCursor)
    ShowLoadingTooltip("Перевожу...")

    TranslateAndShow(selected)
}

; === Показать подсказку загрузки ===
ShowLoadingTooltip(text) {
    global loadingGui

    if IsSet(loadingGui) {
        try loadingGui.Destroy()
    }

    loadingGui := Gui("+ToolWindow +AlwaysOnTop -Caption +Owner", "Loading Indicator")
    loadingGui.BackColor := "FFFF00"
    loadingGui.SetFont("s10", "Arial")
    loadingGui.Add("Text", "w100 Center", text)

    ; Позиционируем подсказку рядом с курсором
    CoordMode("Mouse", "Screen")
    MouseGetPos(&mx, &my)
    loadingGui.Show("x" mx + 20 " y" my + 20 " NoActivate")
}

; === Скрыть подсказку загрузки ===
HideLoadingTooltip() {
    global loadingGui

    if IsSet(loadingGui) {
        loadingGui.Destroy()
        loadingGui := unset
    }

    ; Восстановить обычный курсор
    DllCall("SetCursor", "Ptr", DllCall("LoadCursor", "UInt", 0, "UInt", 32512)) ; IDC_ARROW
}

; === Выполнить перевод текста и отобразить результат ===
TranslateAndShow(text) {
    global isTranslating

    ; Замена проблемных символов
    cleanedText := text
    cleanedText := StrReplace(cleanedText, "÷", "/")
    cleanedText := StrReplace(cleanedText, "`"", "\`"")
    cleanedText := RegExReplace(cleanedText, "[`n`r]+", " ")

    isSingleWord := !RegExMatch(cleanedText, "\s")

    try {
        ; Указываем UTF-8 локаль для trans
        if isSingleWord {
            command := 'wsl.exe bash -c "LANG=en_US.UTF-8 trans en:ru \"' cleanedText '\""'
        } else {
            command := 'wsl.exe bash -c "LANG=en_US.UTF-8 trans en:ru -b \"' cleanedText '\""'
        }

        translation := ExecAndGetOutput(command)

        ; Очистка перевода от лишних переносов строк
        translation := RegExReplace(translation, "[\r\n]+", " ")

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
    HideLoadingTooltip()
}

; === Запуск внешней команды и получения вывода ===
ExecAndGetOutput(command) {
    try {
        tempFile := A_ScriptDir "\temp_output.txt"
        RunWait('cmd.exe /c ' command ' > "' tempFile '"', , "Hide")
        output := FileRead(tempFile, "UTF-8")
        FileDelete(tempFile)
        return Trim(output)
    } catch as e {
        return ""
    }
}

; === Повторный перевод измененного текста ===
TranslateButtonClick(ctrl, info) {
    global originalEdit
    updatedText := originalEdit.Value
    if (Trim(updatedText) != "")
        TranslateAndShow(updatedText)
}

; === Отображение окна с результатом перевода ===
ShowResultWindow(original, translation) {
    global currentGui, originalEdit, translationEdit
    static iniFile := A_ScriptDir "\window_pos.ini"

    ; Уничтожить предыдущее окно, если есть
    if IsSet(currentGui) {
        try currentGui.Destroy()
    }

    ; Создать окно с возможностью изменения размера
    currentGui := Gui("+AlwaysOnTop +Resize +MinSize400x400", "Перевод")
    currentGui.SetFont("s14", "Segoe UI")

    ; Текст "Оригинал"
    currentGui.AddText("x10 y10", "Оригинал:")

    ; Поле для оригинального текста
    originalEdit := currentGui.AddEdit("x10 y+5 r12 Multi +Wrap", original)

    ; Кнопка "Перевести"
    translateBtn := currentGui.AddButton("Default w120 y+5", "Перевести")
    translateBtn.OnEvent("Click", TranslateButtonClick)

    ; Текст "Перевод"
    currentGui.AddText("x10 y+5", "Перевод:")

    ; Поле для перевода (с переносом текста)
    translationEdit := currentGui.AddEdit("x10 y+5 ReadOnly r18 Multi +Wrap", translation)

    ; Кнопка "Закрыть"
    closeBtn := currentGui.AddButton("Default w100 y+5", "Закрыть")
    closeBtn.OnEvent("Click", (*) => SaveAndClose())

    ; Чтение сохранённых параметров
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

    ; Показать окно
    currentGui.Show(showOptions)

    ; Установить начальные размеры полей
    currentGui.GetClientPos(, , &clientWidth)
    AdjustControls(clientWidth)

    ; Обработчик изменения размера окна
    currentGui.OnEvent("Size", GuiSize)
}

; === Функция для установки размеров элементов управления ===
AdjustControls(clientWidth) {
    global originalEdit, translationEdit

    ; Отступы
    margin := 10
    newWidth := clientWidth - 2 * margin

    ; Установить ширину поля оригинала
    if IsSet(originalEdit) {
        originalEdit.GetPos(&origX, &origY, &origW, &origH)
        originalEdit.Move(margin, origY, newWidth)
    }

    ; Установить ширину поля перевода
    if IsSet(translationEdit) {
        translationEdit.GetPos(&transX, &transY, &transW, &transH)
        translationEdit.Move(margin, transY, newWidth)
    }
}

; === Обработка изменения размера окна ===
GuiSize(thisGui, MinMax, Width, Height) {
    if (MinMax = -1)
        return

    ; Сохранить новый размер
    IniWrite(Width, iniFile, "Window", "W")
    IniWrite(Height, iniFile, "Window", "H")

    ; Пересчитать размеры элементов управления
    AdjustControls(Width)
}

; === Сохранение позиции и закрытие окна ===
SaveAndClose() {
    global currentGui, iniFile
    if IsSet(currentGui) {
        currentGui.GetPos(&gx, &gy, &gw, &gh)
        IniWrite(gx, iniFile, "Window", "X")
        IniWrite(gy, iniFile, "Window", "Y")
        IniWrite(gw, iniFile, "Window", "W")
        IniWrite(gh, iniFile, "Window", "H")
        currentGui.Destroy()
        currentGui := unset
    }
}

; === Обработка закрытия окна (через крестик) ===
GuiClose(thisGui) {
    SaveAndClose()
}

; === Выход по Esc (на всякий случай) ===
Esc::
{
    global currentGui
    if IsSet(currentGui)
        SaveAndClose()
}

