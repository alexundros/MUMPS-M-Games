    /// Булгаков А.С.; Функции,Процедуры
Echo(On) ; Включение/отключение ECHO
    ; Если [On>0] - включение
    ; Если [On=0] - выключение
    i $g(On) u 0:(0:"") q
    u 0:(0:"SI")
    q
Key(To) ; Обработка нажатия клавиш
    ; To -время ожидания
    ; Если [To=0] - Без ограничения времени ввода
    ; Если [To>0] - Время ввода ограничено секундами To
    n ch,b
    s To=$g(To)
    s b(3)="CTRL+C"
    s b(8)="BS"
    s b(9)="TAB"
    s b(13)="ENT"
    s b(21)="CAN"
    s b(27)="ESC"
    s b(32)="SPACE"
    s b(127)="DEL"
    s b(27_91_49_126)="HOME"
    s b(27_91_51_126)="INS"
    s b(27_91_51_126)="DEL"
    s b(27_91_52_126)="END"
    s b(27_91_53_126)="PAGE-UP"
    s b(27_91_54_126)="PAGE-DOWN"
    s b(27_91_65)="UP"
    s b(27_91_66)="DOWN"
    s b(27_91_67)="RIGHT"
    s b(27_91_68)="LEFT"
    s b(27_79_80)="F1"
    s b(27_79_81)="F2"
    s b(27_79_82)="F3"
    s b(27_79_83)="F4"
    s b(27_79_84)="F5"
    s b(27_91_49_55_126)="F6"
    s b(27_91_49_56_126)="F7"
    s b(27_91_49_57_126)="F8"
    s b(27_91_50_48_126)="F9"
    s b(27_91_50_49_126)="F10"
    s b(27_91_50_51_126)="F11"
    s b(27_91_50_52_126)="F12"
    r:To *key:To
    r:'To *key
    f  s ch=$$byte() s:ch key=key_ch q:'ch
    s key=$g(b(key),key)
    q key
byte() ; Чтение 4 байт
    n i,ch
    f i=1:1:4 r *ch:0 q:ch'<0
    q:ch'<0 ch
    q 0
Input(Def) ; Ввод данных
    n in
    d Echo(1)
    r in
    d Echo(0)
    q:$a($k)=27 -1
    s:'$l(in) in=$g(Def)
    q in