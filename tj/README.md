# Snortelefier - Огоҳкунандаи Telegram барои Snort

Snortelefier як скрипти оддии Bash мебошад, ки барои фиристодани огоҳиномаҳои логи Snort тавассути боти Telegram тарҳрезӣ шудааст. Ин скрипт файлҳои логии Snort-ро барои огоҳиномаҳои нав назорат мекунад ва огоҳиномаҳо ба ҳисоби Telegram-и корбар фиристода мешаванд. Он сабук, зуд ва барои мутобиқ шудан ба эҳтиёҷоти шахсии шумо танзимшаванда мебошад.

## Хусусиятҳо

- **Назорати логҳои Snort дар вақти воқеӣ**: Аз `inotifywait` барои пайгирии тағйирот дар файлҳои логии Snort истифода мебарад.
- **Огоҳиномаҳои Telegram**: Огоҳиномаҳо ба ҳисоби Telegram-и шумо тавассути бот фиристода мешаванд.
- **Маҳдудияти фиристодани огоҳиномаҳо**: Назорат кунед, ки чӣ қадар огоҳиномаҳо фиристода мешаванд, то аз зиёда аз ҳад огоҳиномаҳо пешгирӣ шавад.
- **Осон танзимшаванда**: Танҳо токени боти Telegram ва ID-и чати худро дар файли `.env` насб кунед.
- **Дастгирии Systemd**: Илова кардани Snortelefier ҳамчун хидмати systemd барои оғози автоматӣ ҳангоми сарбории система.
- **Таваҷҷуҳи махсус ба амният**: Дастрасӣ ба файлҳои конфигуратсияи ҳассос танҳо барои корбари root маҳдуд карда мешавад.

## Чӣ тавр кор мекунад

Snortelefier бо истифода аз `inotifywait` аз бастаи `inotify-tools` файлҳои логии Snort-ро назорат мекунад. Вақте ки файл навсозӣ мешавад (масалан, огоҳиномаи нав пайдо мешавад), скрипт вуруди охирини логро ҳамчун паёми Telegram мефиристад. Барои пешгирӣ аз спам, маҳдудияти фиристодани огоҳиномаҳо ба асоси порогҳои муайяншудаи корбар истифода мешавад.

## Радди масъулият

Snortelefier "ҳамон тавре, ки ҳаст" пешниҳод шудааст. Муаллиф барои ягон зарар ё талафот ҷавобгар нест. Ин скриптро масъулона истифода баред! Назорати ғайрирасмӣ, маълумотро хориҷ кардан (data exfiltration) ё дигар ҳамлаҳои киберӣ, ки ин скрипт метавонад ба онҳо кӯмак расонад, метавонад қонунҳо ва қоидаҳоро вайрон кунад. Пеш аз истифода, боварӣ ҳосил кунед, ки ин скрипт бо меъёрҳои ҳуқуқии дахлдор мувофиқат мекунад.

## Талабот

- **Snort**: Боварӣ ҳосил кунед, ки Snort дар системаи шумо насб ва танзим шудааст.
- **inotify-tools**: Барои назорати тағйироти файлҳои логӣ.
- **curl**: Барои фиристодани дархостҳои HTTP ба API-и Telegram.
- **shc** (ихтиёрӣ): Барои компилятсия кардани скрипт барои амнияти иловагӣ.
- **systemd** (ихтиёрӣ): Барои кор кардани Snortelefier ҳамчун хидмат.

## Насб

1. Репозиториро клон кунед:
    ```bash
    git clone https://github.com/oxb1te/snortelefier.git
    cd snortelefier
    ```

2. Насби вобастагиҳои зарурӣ:
    ```bash
    sudo apt-get install inotify-tools curl shc -y
    ```

3. Скрипти танзимотро иҷро кунед:
    ```bash
    ./setup.sh
    ```

4. Файли `.env`-ро танзим кунед:
    - Шумо ҳангоми иҷрои скрипти танзимот токени боти Telegram ва ID-и чати худро ворид мекунед.
    - Файли `.env` бо арзишҳои пешфарз барои масирҳои лог, муддатҳои санҷиш ва маҳдудиятҳои нарх сохта мешавад.
    Ё
    - Шумо метавонед онро дастӣ таҳрир кунед.

## Мисол

Ин як мисоли он аст, ки чӣ гуна огоҳинома метавонад чунин ба назар расад:
```
[!] - Салом, корбар! 
[!] - Фаъолияти шубҳаноки шабака дар сервер ошкор шуд!

[*] - Вақти сервер: 03 Oct 2024 10:15:34 Snort Alert: [] [1:1000001:0] ICMP PING [] [Classification: Misc activity] [Priority: 3] SRC_IP -> DST_IP
```

## Мусоидат

Агар шумо ягон пешниҳодҳо, беҳбудӣ ё хатоҳо дошта бошед, лутфан як масъала (issue) ё дархости кашиш (pull request) фиристед.

## Литсензия

Ин лоиҳа таҳти Литсензияи MIT иҷозатнома дода шудааст. Барои маълумоти бештар файли ![LICENSE](./LICENSE)-ро бубинед.