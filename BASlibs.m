    /// Булгаков А.С.; Функции,Процедуры "Программа Библиотека"
TXT(Top,Lft,Txt,Aln,Rpt,Lmt,Aln2) ; Установка текста
    ; Top - позиция строки
    ; Lft - позиция начала в строке
    ; Txt - текст для вывода
    ; Aln - выравнивание по окну
    ; Rpt - количество повторений строки
    ; Lmt - ограничение кол-ва символов
    ; Aln2 - выравнивание в ограничении
    n i,len
    s Top=$g(Top,1)
    s Lft=$g(Lft,0)
    s Txt=$g(Txt,"")
    s Aln=$g(Aln,0)
    s Rpt=$g(Rpt,0)
    s Lmt=$g(Lmt,0)
    s Aln2=$g(Aln2,0)
    ; повтор строки
    s tmp=""
    f i=1:1:Rpt s tmp=tmp_Txt
    s Txt=Txt_tmp
    s len=$l(Txt)
    i Lmt,len>Lmt d CROP
    ; выравнивание
    s:Aln=1 Lft=cwidth-len\2+Lft
    s:Aln=2 Lft=cwidth-len+Lft
    s:Aln2=1 Lft=Lmt-len\2+Lft
    s:Aln2=2 Lft=Lmt-len+Lft
    f i=1:1:len d SSTL
    q
CROP ; Обрезка длинных строк
    s Txt=$e(Txt,1,Lmt)_">"
    s len=$l(Txt)
    q
SSTL ; Установка экрана
    s screen(Top,Lft+i)=$e(Txt,i)
    q
DRAW ; Вывод экрана
    n i,lst
    ; lst - последняя строка
    s lst=$o(screen(""),-1)
    w #
    f i=1:1:lst d DLINE
    q
DLINE ; Вывод строки экрана
    n j
    f j=1:1:cwidth w $g(screen(i,j)," ")
    q
CLR(Strt,End) ; Очистка экрана
    ; Strt - начальная строка
    ; End - конечная строка
    n i,lst
    s lst=$o(screen(""),-1)
    s Strt=$g(Strt,1)
    s End=$g(End,lst)
    f i=Strt:1:End k screen(i)
    q
HINT(Txt) ; Установка подсказки
    d TXT(3,-1,Txt,2)
    q
TOP ; Установка шапки
    d CLR
    d TXT(1,1,"БИБЛИОТЕКА")
    d TXT(1,-1,"Разработка НПЦ АИР",2)
    d TXT(2,,"-",,cwidth-1)
    q
Menu(Key,Id,Ci,Top) ; Вывод меню
    ; Key - ключ меню
    ; Id - ид. меню
    ; Ci - активный пункт
    ; Top - позиция строки
    n txt
    s Top=$g(Top,6)
    s id=$o(@menu@(Key,Id))
    q:id="" 0
    d:id=Ci TXT(Top+id,1,">")
    s txt=@menu@(Key,id)
    d TXT(Top+id,3,"["_id_"]"_txt)
    q id
PGSUPD(Cn,Pg,Lm) ; Пересчет страниц
    ; Cn - количество элементов
    ; Pg - номер страницы
    ; Lm - на странице
    i 'Cn s Pg=1 q
    i Cn#Lm s Pg=Cn\Lm+1 q
    s Pg=Cn\Lm
    s:'Pg Pg=1
    q
SRTXT ; Информация сортировки
    n srtxt
    s srtxt="Сортировка: "
    s:idx=1 srtxt=srtxt_"по индексу"
    s:idx=2 srtxt=srtxt_"по имени"
    s:sort=1 srtxt=srtxt_" прямая"
    s:sort=-1 srtxt=srtxt_" обратная"
    d TXT(4,1,srtxt)
    q
INFPGS(Cnt,Crp,Pgs) ; Информация навигатора
    n hint
    s hint="Строк: ["_Cnt_"]"
    s hint=hint_" Стр.: ["_Crp_"/"_Pgs_"]"
    s hint=hint_" <LEFT|RIGHT>"
    d HINT(hint)
    q
TBLEFT ; Нажатие влево в таб.
    s crp=crp-1
    s:crp<1 crp=pgs
    s:pgs>1 ci=1
    q
TBRIGHT ; Нажатие вправо в таб.
    s crp=crp+1
    s:crp>pgs crp=1
    s:pgs>1 ci=1
    q
TBUP ; Нажатие вверх в таб.
    s ci=ci-1
    s:ci<1 ci=1
    q
TBDOWN ; Нажатие вниз в таб.
    s pgc=$g(pgc,1)
    s ci=ci+1
    s:ci>pgc ci=pgc
    q
TBFT ; Низ таблицы
    n txt
    s txt="ESC:выход ENT:вход"
    s txt=txt_" DEL:удалить F2:создать"
    s txt=txt_" F3:сорт. F4:поиск F5:обнов."
    d TXT(cheight-1,1,"-",,cwidth-3)
    d TXT(cheight,1,txt)
    q
SETDEF ; Настройки
    ; mi - активный пункт меню
    s data="^tmpBASlib"
    s book=data_"(""book"")"
    s cat=data_"(""cat"")"
    s author=data_"(""author"")"
    s user=data_"(""user"")"
    s menu=data_"(""menu"")"
    s cwidth=80
    s cheight=24
    s limit=15
    s mi=1
    s @menu@("main",1)="Книги"
    s @menu@("main",2)="Категории"
    s @menu@("main",3)="Авторы"
    s @menu@("main",4)="Пользователи"
    s @menu@("main",5)="Выборки"
    s @menu@("sort",1)="Сортировка по индексу прямая"
    s @menu@("sort",2)="Сортировка по индексу обратная"
    s @menu@("sort",3)="Сортировка по имени прямая"
    s @menu@("sort",4)="Сортировка по имени обратная"
    s @menu@("select",1)="Пользователи взявшие книги"
    s @menu@("select",2)="Пользователи взявшие более 5 книг"
    s @menu@("select",3)="Книги без категории"
    s @menu@("select",4)="Отсутствующие книги"
    q
TEST ; Тестовые данные
    n data,book,cat,author,user
    s data="^tmpBASlib"
    k @data
    s book=data_"(""book"")"
    s cat=data_"(""cat"")"
    s author=data_"(""author"")"
    s user=data_"(""user"")"
    ; категории
    s @cat@(1)="Художественные"
    s @cat@(2)="Юмор"
    s @cat@(3)="Информационные"
    s @cat@(4)="Технические"
    s @cat@(5)="Журналы"
    s @cat@(6)="Природа"
    s @cat@(7)="Спорт"
    s @cat@(8)="Религия"
    ; авторы
    f i=1:1:100 d GENAT
    ; пользователи
    f i=1:1:9999 d GENUS
    ; книги
    f i=1:1:9999 d GENBK
    w "Таблицы созданы!"
    q
GenFIO() ; Генерация ФИО
    n name,sname,patr,g,f,i,o
    s name="Александр,Алексей,Андрей,Антон,Борис,Валерий,Василий,Виктор,Владимир,Геннадий,"
    s name=name_"Григорий,Денис,Дмитрий,Евгений,Егор,Иван,Игорь,Константин,Леонид,Максим,"
    s name=name_"Михаил,Никита,Николай,Олег,Павел,Роман,Руслан,Сергей,Фёдор,Юрий"
    s patr(1)="Александрович,Алексеевич,Андреевич,Антонович,Борисович,Валерьевич,Васильевич,Викторович,"
    s patr(1)=patr(1)_"Владимирович,Геннадьевич,Григорьевич,Денисович,Дмитриевич,Евгеньевич,Егорьевич,"
    s patr(2)="Иванович,Игоревич,Константинович,Леонидович,Максимович,Михайлович,Никитович,Николаевич,"
    s patr(2)=patr(2)_"Олегович,Павлович,Романович,Русланович,Сергеевич,Фёдорович,Юрьевич"
    ; фамилии из списка Унбегауна
    s sname(1)="Иванов,Васильев,Петров,Смирнов,Михайлов,Фёдоров,Соколов,Яковлев,"
    s sname(1)=sname(1)_"Попов,Андреев,Алексеев,Александров,Лебедев,Григорьев,Степанов,"
    s sname(2)="Семёнов,Павлов,Богданов,Николаев,Дмитриев,Егоров,Волков,Кузнецов,"
    s sname(2)=sname(2)_"Никитин,Соловьёв,Тимофеев,Орлов,Афанасьев,Филиппов,Сергеев"
    s g=sname($r(2)+1)
    s f=$p(g,",",$r(15)+1)
    s i=$p(name,",",$r(30)+1)
    s g=patr($r(2)+1)
    s o=$p(g,",",$r(15)+1)
    q f_" "_i_" "_o
GenDATE(Ds,De,Ms,Me,Ys,Ye) ; Генерация даты
    ; Ds - день от, De - день до
    ; Ms - месяц от, Me - месяц до
    ; Ys - год от, Ye - год до
    n d,m,y,dl,ml,yl
    s dl=De-Ds
    s ml=Me-Ms
    s yl=Ye-Ys
    s d=Ds+$r(dl)+1
    s m=Ms+$r(ml)+1
    s y=Ys+$r(yl)+1
    s:'(m#2)&&(d=31) d=30
    s:(m=2)&&(d>29) d=29
    s:(y#4)&&(d>28) d=28
    s:$l(d)=1 d="0"_d
    s:$l(m)=1 m="0"_m
    q d_"."_m_"."_y
GENAT ; Генерация автора
    s @author@(i)=$$GenFIO()
    s @author@(i,"birth")=$$GenDATE(1,20,1,12,1870,1980)
    s @user@(i,"count")=0
    q
GENUS ; Генерация пользователя
    s @user@(i)=$$GenFIO()
    s @user@(i,"birth")=$$GenDATE(1,20,1,12,1950,2000)
    s @user@(i,"bk")=0
    q
GENBK ; Генерация книги
    s @book@(i)="Книга "_i
    s @book@(i,"count")=$r(10)+1
    s @book@(i,"cat")=$r(8)+1
    s @book@(i,"author")=$r(100)+1
    s @book@(i,"print")=$$GenDATE(1,31,1,12,2000,2010)
    q