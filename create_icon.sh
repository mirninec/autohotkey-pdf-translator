#!/bin/bash

# Убедимся, что скрипт запущен в WSL
if ! grep -qi microsoft /proc/version; then
  echo "Ошибка: Этот скрипт должен запускаться в WSL!"
  exit 1
fi

# Проверка и установка зависимостей
echo "Проверяем установленные пакеты..."
sudo apt update > /dev/null 2>&1
packages=("imagemagick" "inkscape" "librsvg2-bin")
for pkg in "${packages[@]}"; do
  if ! dpkg -l | grep -q $pkg; then
    echo "Устанавливаем $pkg..."
    sudo apt install -y $pkg > /dev/null 2>&1
  fi
done

# Создаем SVG файл
cat > ./icon.svg << 'EOF'
<svg width="256" height="256" viewBox="0 0 256 256" xmlns="http://www.w3.org/2000/svg">
  <path fill="#2B579A" d="M50,40 L206,40 C220,40 230,50 230,64 L230,176 C230,190 220,200 206,200 L50,200 C36,200 26,190 26,176 L26,64 C26,50 36,40 50,40 Z"/>
  <path fill="#F25022" d="M50,200 L206,200 C220,200 230,190 230,176 L230,192 C230,206 220,216 206,216 L50,216 C36,216 26,206 26,192 L26,176 C26,190 36,200 50,200 Z"/>
  <path fill="white" d="M128,80 L160,120 L96,120 Z"/>
  <path fill="white" d="M128,176 L96,136 L160,136 Z"/>
</svg>
EOF

# Конвертируем SVG в ICO
echo "Конвертируем SVG в ICO..."
if command -v inkscape &> /dev/null; then
  inkscape -w 256 -h 256 ./icon.svg -o ./icon.png > /dev/null 2>&1
else
  rsvg-convert -w 256 -h 256 ./icon.svg -o ./icon.png > /dev/null 2>&1
fi

convert ./icon.png -define icon:auto-resize=256,128,64,48,32,16 ./icon.ico > /dev/null 2>&1

# Удаляем временные файлы
rm ./icon.svg ./icon.png

# Проверяем результат
if [ -f "./icon.ico" ]; then
  echo "Успешно! Иконка создана: $(wslpath -w ./icon.ico)"
else
  echo "Ошибка при создании иконки!"
  exit 1
fi