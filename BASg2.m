    /// Булгаков А.С.; Игра "Пьяница"
MAIN ; Начало игры
    n cwidth,cheight,tmp,lines,rules
    n menu,cards,key,mi,user
    ; cwidth - ширина окна
    ; cheight - высота окна
    ; tmp - глобал игры
    ; lines - буфер экрана
    ; rules - правила игры
    ; menu - пункты меню
    ; key -  последняя нажатая клавиша
    ; mi -  активный пункт меню
    ; user -  пользователи
    d Echo(0)
    ; настройки
    d SETDEF
    ; основная процедура
    f  q:$$mainAct()
    d Echo(1)
    w #
    q
SETDEF ; Базовые настройки игры
    s mi=1
    s cwidth=80
    s cheight=23
    s tmp="^tmpBASg2"
    s rules=tmp_"(""rules"")"
    s @rules@(1)="Количество карт в колоде: 36"
    s @rules@(2)="Старшинство карт: 6,7,8,9,10,В,Д,К,Т"
    s @rules@(3)="Цель игры: собрать все карты у себя"
    s @rules@(4)="Правила игры:"
    s @rules@(5)="Сдатчик карт определяется жребием. Карты в колоде тщательно тасуются"
    s @rules@(6)="колода раздается поровну между игроками. Игроки не смотрят своих карт,"
    s @rules@(7)="а кладут их стопкой в закрытом виде возле себя. Первый ход принадлежит"
    s @rules@(8)="сдатчику карт, он снимает свою верхнюю карту, открывает и кладет "
    s @rules@(9)="на центр стола в открытом виде. Другие игроки по кругу по часовой"
    s @rules@(10)="стрелке делают то же самое. Затем смотрят чья карта старше, тот игрок"
    s @rules@(11)="у которого карта старше, забирает карты и кладет их в том же порядке"
    s @rules@(12)="под низ своей колоды. Если у игроков окажутся равные старшие карты,"
    s @rules@(13)="то забирает тот игрок, который после дополнительного хода положит"
    s @rules@(14)="старшую карту, Далее ход переходит к следующему игроку по часовой"
    s @rules@(15)="стрелке. Если у игрока заканчиваются карты, то он выбывает из игры."
    s @rules@(16)="Выигрывает игрок, который соберет все карты у себя."
    s menu=tmp_"(""menu"")"
    s @menu@("main",1)="Правила"
    s @menu@("main",2)="Начать игру"
    s @menu@("main",3)="Выход"
    s cards=tmp_"(""cards"")"
    s @cards@("r")="6,7,8,9,10,Валет,Дама,Король,Tуз"
    s @cards@("d",1)="6"
    s @cards@("d",2)="7"
    s @cards@("d",3)="8"
    s @cards@("d",4)="9"
    s @cards@("d",5)="10"
    s @cards@("d",6)="Валет"
    s @cards@("d",7)="Дама"
    s @cards@("d",8)="Король"
    s @cards@("d",9)="Tуз"
    s @cards@("m",1)="черви"
    s @cards@("m",2)="буби"
    s @cards@("m",3)="пики"
    s @cards@("m",4)="крести"
    q
    /// Обработка нажатий клавиш 
    /// в основном меню
mainAct()
    n id
    s id=""
    s:mi>3 mi=3
    s:mi<1 mi=1
    d CLEAR
    d TOP
    d HINT("Начните игру")
    ; заголовок
    d LINE(5,"МЕНЮ",,1)
    d LINE(6,"-",,1,15)
    f  q:$$MainMList()
    ; вывод буфера строк
    d DRAW
    s key=$$Key()
    i key="ESC" q 1
    i key="ENT" q $$MainENT()
    i key="UP" s mi=mi-1
    i key="DOWN" s mi=mi+1
    q 0
    /// Вывод пунктов основного меню
MainMList()
    n txt
    s id=$o(@menu@("main",id))
    q:id="" 1
    s txt=@menu@("main",id)
    ; активный пункт меню
    i id=mi s txt="> "_txt_" <"
    d LINE(7+id,txt,,1)
    q 0
    /// Обработка нажатой клавишы ENT
    /// в основном меню
MainENT()
    i mi=1 d RULES q 0
    i mi=2 d GAME q 0
    i mi=3 q 1
    q 0
RULES ; Постраничный вывод правил игры
    n limit,lsize,pages,cur
    ; limit - ограничение строк
    ; lsize - кол-во строк rules
    ; pages - всего страниц
    ; cur - активная страница
    s cur=1,limit=14
    s lsize=$o(@rules@(""),-1)
    s pages=lsize\limit+1
    ; вывод страниц правил
    f  q:$$RulShow()
    q
    /// Управление выводом страниц правил
    /// (управление кнопками)
RulShow()
    d CLEAR
    d TOP
    d HINT("ESC:Выход; LEFT:Назад; RIGHT:Вперед;")
    ; проверка страницы
    s:cur>pages cur=pages
    s:cur<1 cur=1
    ; заголовок
    d LINE(2,"Правила",,1)
    d LINE(3,"Страница:"_cur_"/"_pages,,1)
    f i=1:1:limit d RLINE
    d DRAW
    s key=$$Key()
    i key="ESC" q 1
    i key="LEFT" s cur=cur-1
    i key="RIGHT" s cur=cur+1
    q 0
RLINE ; Вывод одной строки правил
    n txt,ln
    s ln=cur-1*limit+i
    s txt=$g(@rules@(ln))
    d LINE(5+i,txt,2)
    q
GAME ; Главная процедура игры
    n i,crd,gi
    ; crd -  массив карт
    ; gi - круг игры
    k user(1,"crd")
    k user(2,"crd")
    ; ввод пользователя 1
    f  q:$$GUser(1)
    q:$a($k)=27
    ; ввод пользователя 2
    f  q:$$GUser(2)
    q:$a($k)=27
    ; установка карт
    f i=1:1:9 d CRDD
    ; перемешиваем
    d MIX
    ; раздача карт
    f i=1:1:36 d CRDTOUS
    ; круг игры
    f  q:$$Round()
    q
Round() ; Круг игры
    n k,save,tmp,cu,win
    ; save - хранилище карт хода
    ; tmp - последний ход
    ; cu - число активных игроков
    s gi=$i(gi)
    d GTOP
    d HINT("ESC:Выход; SPACE:Пауза")
    d LINE(4,"Круг: "_gi,,1)
    ; пересчет карт игроков
    d CNTALL
    d LINE(6,"Карт: "_$g(user(1,"crd")),2)
    d LINE(6,"Карт: "_$g(user(2,"crd")),0,2)
    ; ход 1 игрока
    d USCRD(1)
    ; ход 2 игрока
    d USCRD(2)
    d LINE(8,"# "_tmp(1),2)
    d LINE(8,"# "_tmp(2),0,2)   
    ; определение победителя
    s:$g(tmp(1,1))>$g(tmp(2,1)) win=1
    s:$g(tmp(1,1))<$g(tmp(2,1)) win=2
    i $g(tmp(1,1))=$g(tmp(2,1)) d EQUAL
    ; передача карт победителю
    d SVTOUS(win)
    ; пересчет карт после круга
    d CNTALL
    d DRAW
    ; определение победителя
    q:cu<2 $$Win()
    s key=$$Key(1)
    i key="ESC" q 1
    i key="SPACE" r *k
    q 0
EQUAL ; Дополнитьельная процедура при равенстве достоинств карт
    d LINE(6,"Дополнтельный ход:",,1)
    ; ход в закрытую
    d USCRD(1)
    d USCRD(2)
    ; ход
    d USCRD(1)
    d USCRD(2)
    ; вывод карт хода
    d LINE(10,"# "_tmp(1),2)
    d LINE(10,"# "_tmp(2),0,2)
    s:$g(tmp(1,1))>$g(tmp(2,1)) win=1
    s:$g(tmp(1,1))<=$g(tmp(2,1)) win=2
    q
SVTOUS(I) ; Передача карт из хранилища победителю
    n id
    s id=""
    f  s id=$o(save(id)) q:id=""  d ADDCRD(I,save(id))
    d LINE(8,"Старшая карта:",,1)
    d LINE(9,tmp(I),,1)
    d LINE(11,"Карты забирает:",,1)
    d LINE(12,user(I),,1)
    q
Win() ; Вывод определенного победителя
    d GTOP
    d LINE(10,"ПОБЕДИТЕЛЬ",,1)
    d LINE(11,$g(user(win)),,1)
    d LINE(13,"СПАСИБО ЗА ИГРУ!",,1)
    d HINT("*:Продолжить")
    d DRAW
    r *k
    q 1
GTOP ; Шапка игры
    d CLEAR
    d TOP
    d LINE(2,"Игра начата",,1)
    d:$d(user(1)) LINE(5,"№1: "_user(1),2)
    d:$d(user(2)) LINE(5,"№2: "_user(2),0,2)
    q
GUDRAW ; Установка буфера строк при вводе данных игроков
    d GTOP
    d LINE(10,"Заполните информацию об игроках",,1)
    d HINT("Установи имена игроков")
    d DRAW
    q
GUser(I) ; Ввод информации об игроке
    n in
    q:$d(user(I)) 1
    d GUDRAW
    w " Игрок("_I_")[3-30]:"
    d Echo(1)
    r in
    d Echo(0)
    i $a($k)=27 q 1
    ; проверка по шаблону
    i in?3.30E s user(I)=in q 1
    q
CRDD ; Проход по достоинствам карт при заполнении
    n j
    f j=1:1:4 d CRDM
    q
CRDM ; Проход по мастям карт при заполнении
    n id,d,m
    s d=$g(@cards@("d",i))
    s m=$g(@cards@("m",j))
    s id=$o(crd(""),-1)
    s crd(id+1)=d_$c(32)_m
    q
MIX ; Перемешиваем массив полученных карт
    n i
    f i=1:1:36 d MOVE
    q
MOVE ; Перестановка 2-х карт
    n j,t
    s j=$r(36-i+1)+1
    s t=crd(i)
    s crd(i)=crd(j)
    s crd(j)=t
    q
CRDTOUS ; Раздача карт
    s j=i#2
    s:'j j=2
    d ADDCRD(j,crd(i))
    q
    /// Добавление карты игроку
    /// [Параметры]
    /// I* -номер игрока
    /// V* -карта
ADDCRD(I,V)
    n id
    s id=$o(user(I,"crd",""),-1)+1
    s user(I,"crd",id)=V
    q
CNTALL ; Пересчет карт всех игроков
    s cu=0
    f i=1:1:2 d CNTUS
    q
CNTUS ; Пересчет карт игрока
    n uc,id
    s uc=0
    s id=""
    f  s id=$o(user(i,"crd",id)) q:id=""  s uc=$i(uc)
    s user(i,"crd")=uc
    s:uc cu=$i(cu) 
    q
    /// Карта игрока
    /// [Параметры]
    /// I* - номер игрока
    /// [Описание]
    /// Обработка первой по
    /// младшему индексу карты
USCRD(I)
    n id,v,d
    s id=$o(user(I,"crd",""))
    q:id=""
    s v=$g(user(I,"crd",id))
    k user(I,"crd",id)
    s tmp(I)=v
    s d=$p(v," ",1)
    s tmp(I,1)=$f(@cards@("r"),d)
    d CRDSAVE(v)
    q
CRDSAVE(V) ; Сохранение карты
    n id
    s id=$o(save(""),-1)+1
    s save(id)=V
    q
TOP ; Установка шапки игры
    d LINE(1,"ИГРА ПЬЯНИЦА",2)
    d LINE(2,"-",2,,11)
    d LINE(3,"на 2 игрока",2)
    d LINE(1,"Разработка НПЦ АИР",0,2)
    d LINE(2,"-",0,2,17)
    q
FOOT ; Установка  низа окна
    d LINE(cheight,"-",2,,cwidth-3)
    d LINE(cheight-1,"["_$g(key)_"]",0,2)
    q
HINT(Txt) ; Установка подсказки в низу окна
    d CLEAR(cheight-1)
    d LINE(cheight-1,"Подсказка: "_Txt,2)
    q
CLEAR(I) ; Инициализация и отчистка буфера строк
    n i,tmp
    s tmp=""
    f i=1:1:cwidth s tmp=tmp_" "
    s i=$g(I,0)
    i i s lines(i)=tmp q
    f i=1:1:cheight s lines(i)=tmp
    q
    /// Обработка линии буфера строк
    /// [Параметры]
    /// Num - номер строки буфера
    /// Txt* - строка текста для установки
    /// Start - начальная позиция или смешение при выравнивании в строке
    /// Align - выравнивание
    /// Repeat - количество повторений строки текста
    /// [Описание]
    /// Если [Align=1] - Выравнивание по центру
    /// Если [Align=2] - Выравнивание в право
LINE(Num,Txt,Start,Align,Repeat)
    n i,tmp,rep,len,str,left,right
    ; входные параметры
    s Num=$g(Num,1)
    s Start=$g(Start,1)
    s Align=$g(Align,0)
    s Repeat=$g(Repeat,0)
    ; повтор строки
    s tmp=""
    f i=1:1:Repeat s tmp=tmp_Txt
    s Txt=Txt_tmp
    ; длина строки
    s len=$l(Txt)
    ; выравн. по центру
    s:Align=1 Start=cwidth-len\2+Start
    ; выравн. вправо
    s:Align=2 Start=cwidth-len+Start
    ; конец строки
    s end=Start+len
    ; строка буфера 
    s str=lines(Num)
    ; левая част строки
    s left=$e(str,1,Start-1)
    ; правая часть строки
    s right=$e(str,end,$l(str))
    ; совмещеная строка
    s lines(Num)=left_Txt_right
    q
DRAW ; Вывод буфера строк
    n i
    ; Вывод низа, перемещено в процедуру
    ; т.к. тиспользуется перед каждым её вызовом
    d FOOT
    w #
    f i=1:1:cheight w $g(lines(i)),!
    q
Echo(On) ; Включение/отключение ECHO
    ; включить
    u:On 0:(0:"")
    ; выключить
    u:'On 0:(0:"SI")
    q
    /// Обработка нажатия клавишы
    /// [Параметры]
    /// To -время ожидания
    /// [Описание]
    /// Если [To=0] - Без ограничения времени ввода
    /// Если [To>0] - Время ввода ограничено секундами To
Key(To)
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