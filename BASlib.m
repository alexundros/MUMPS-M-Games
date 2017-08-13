    /// Булгаков А.С.; Программа Библиотека
MAIN ; Начало программы
    n data,menu,book,cat,author
    n user,cwidth,cheight,screen,mi,limit
    ; data - глобал данных
    ; menu - пункты меню
    ; book - база данных книг
    ; cat - база данных категорий книг
    ; author - база данных авторов книг
    ; user - база данных пользователей
    ; screen - ячейки экрана
    ; limit - ограничение таблиц
    d SETDEF^tmpBASlibs
    d Echo^tmpBASsys(0)
    ; основная процедура
    f  q:$$MScr
    d Echo^tmpBASsys(1)
    w #
    q
TXT(Top,Lft,Txt,Aln,Rpt,Lmt,Aln2) ; Cсылка
    s Top=$g(Top,1)
    s Lft=$g(Lft,0)
    s Txt=$g(Txt,"")
    s Aln=$g(Aln,0)
    s Rpt=$g(Rpt,0)
    s Lmt=$g(Lmt,0)
    s Aln2=$g(Aln2,0)
    d TXT^tmpBASlibs(Top,Lft,Txt,Aln,Rpt,Lmt,Aln2)
    q
DRAW ; Cсылка
    d DRAW^tmpBASlibs
    q
HINT(Txt) ; Cсылка
    d HINT^tmpBASlibs(Txt)
    q
TOP ; Cсылка
    d TOP^tmpBASlibs
    q
SORT ; Сортировка
    n mi
    s mi=1
    f  q:$$SortScr
    q
SortScr() ; Экран сорт.
    n id
    s:mi>4 mi=4
    s:mi<1 mi=1
    d TOP
    d TXT(3,1,"Сортировка")
    s id=""
    f  s id=$$Menu^tmpBASlibs("sort",id,mi,5) q:'id
    d HINT("ESC:вых.")
    d DRAW
    q $$KeyCont("SortKeys")
SortKeys(I) ; Обработка нажатий сорт.
    s:(I=1)!(I=3) sort=1
    s:(I=2)!(I=4) sort=-1
    i (I=1)!(I=2) s idx=1 q 1
    i (I=3)!(I=4) s idx=2 q 1
    q 0
FIND ; Ввод строки поиска
    n in
    d TOP
    d TXT(3,1,"Настройка поиска")
    d DRAW
    w !!," Найти текст: "
    s in=$$Input^tmpBASsys()
    q:in=-1
    s fnd=in
    q
KeyCont(Fn) ; Обработка нажатий
    n key
    s key=$$Key^tmpBASsys()
    q:key="ESC" 1
    s:key="UP" mi=mi-1
    s:key="DOWN" mi=mi+1
    q:key="ENT" $$@(Fn)(mi)
    q:(key>48)&&(key<58) $$@(Fn)(key-48)
    q 0
    ; -------------------------
MScr() ; Главный экран
    n id
    s:mi>5 mi=5
    s:mi<1 mi=1
    d TOP
    d TXT(3,1,"Главная")
    d TXT(4,1,"-",,cwidth-3)
    s id=""
    f  s id=$$Menu^tmpBASlibs("main",id,mi,5) q:'id
    d HINT("ESC:выход")
    d DRAW
    q $$KeyCont("MKeys")
MKeys(I) ; Обработка нажатий
    i I=1 d BKLIST q 0
    i I=2 d CAT q 0
    i I=3 d AUTHOR q 0
    i I=4 d USER q 0
    i I=5 d SELECT
    q 0
    ; -------------------------
BKLIST(Fcat,Fath,Fus,Flt) ; Страница списка книг
    n bknidx,bkididx,ci,idx,index,ctidx,pgs,crp,sort,fnd,fcat,fath,fus,flt
    ; Fcat - фильтр категории
    ; Fath - фильтр автора
    ; Fus - фильтр по пользователю
    ; Flt - дополнительный фильтр
    ; bknidx - именной индекс
    ; bkididx - индексный индекс
    ; ci - активный элемент
    ; idx - указатель индекса
    ; index - активный индекс
    ; ctidx - размер индекса
    ; pgs - количество страниц
    ; crp - текущая страница
    ; sort - сорт. прямая/обратная
    ; fnd - строка поиска
    ; fcat - фильтр категории
    ; fath - фильтр автора
    ; fus - фильтр пользователя
    ; flt - дополнительный фильтр
    s index=data_"(""bkidx"")"
    s bknidx=data_"(""bknidx"")"
    s bkididx=data_"(""bkididx"")"
    s fcat=$g(Fcat)
    s fath=$g(Fath)
    s fus=$g(Fus)
    s flt=$g(Flt)
    d BKIDX
    d BKUPD
    s ci=1
    s crp=1
    f  q:$$BkLsScr
    q
BKIDX ; Обновление индекса книг
    n cnt,id
    k @bknidx
    k @bkididx
    s id=""
    f  s id=$o(@book@(id)) q:id=""  d BKIDXI
    s @book=$g(cnt,0)
    q
BKIDXI ; Индексирование книги
    n name,key
    s name=@book@(id)
    s key=name_id
    s cnt=$i(cnt)
    s @bknidx@(key)=id
    s @bkididx@(id)=id
    q
BKUPD ; Обновление таблицы книг
    n bkf
    ; bkf - флаг запуска поиска
    k @index
    s fnd=$g(fnd)
    s bkf=$s(flt:1,fnd:1,fcat:1,1:0)
    s:'bkf bkf=$s(fath:1,fus:1,1:0)
    s idx=$g(idx,1)
    m:idx=1 @index=@bkididx
    m:idx=2 @index=@bknidx
    s ctidx=$g(@book)
    d:bkf BKFND
    d PGSUPD^tmpBASlibs(ctidx,.pgs,limit)
    s sort=$g(sort,1)
    q
BKFND ; Поиск книги по индексу
    n ix,cnt
    s ix=""
    f  s ix=$o(@index@(ix)) q:ix=""  d BKFNDI
    s ctidx=$g(cnt,0)
    q
BKFNDI ; Поиск по записи
    n id,name,ct,ath,fs,ius,cb
    ; fs-флаг поиска
    ; ius - есть ли книга у пользователя
    ; cb-количество книг
    s id=$g(@index@(ix))
    s name=$g(@book@(id))
    s ct=$g(@book@(id,"cat"))
    s ath=$g(@book@(id,"author"))
    s cb=$g(@book@(id,"count"),0)
    ; книга у пользователя fus
    s:fus ius=$d(@user@(fus,"bk",id))
    s fs=1
    i fcat,(ct'=fcat) s fs=0
    i fath,(ath'=fath) s fs=0
    i fus,'ius s fs=0
    ; существует ли категория
    i flt=3,$d(@cat@(ct)) s fs=0
    ; книг нет, кол. книг=0
    i flt=4,cb s fs=0
    ; поиск по id и name
    i fs,$f(id,fnd) s cnt=$i(cnt) q
    i fs,$f(name,fnd) s cnt=$i(cnt) q
    k @index@(ix) q
    q
BkLsScr() ; Экран списка книг
    n i,key,ix,txt,strt,pgc,item
    ; strt - начальное смещение
    ; pgc - элементов на странице
    ; item - выбранный элемент
    d TOP
    s txt="Книги > Список"
    s:fcat txt="Книги > Список по категории: ["_fcat_"]"
    s:fath txt="Книги > Список по автору: ["_fath_"]"
    s:fus txt="Книги > Список пользователя: ["_fus_"]"
    s:flt txt="Книги > Выборка: ["_flt_"]"
    d TXT(3,1,txt)
    d SRTXT^tmpBASlibs
    d INFPGS^tmpBASlibs(ctidx,crp,pgs)
    d TXT(4,-1,"Поиск:["_fnd_"]",2)
    d TXT(5,1,"-",,cwidth-3)
    d TXT(6,1,"Индекс")
    d:'fus TXT(6,10,"Название")
    d:fus TXT(6,10,"Название",,,23)
    d:fus TXT(6,33,"Взята",,,10,1)
    d TXT(6,44,"Категория",,,9,1)
    d TXT(6,54,"Автор",,,5,1)
    d TXT(6,60,"Кол-во",,,8,1)
    d TXT(6,69,"Издана",,,10,1)
    d TXT(7,1,"-",,cwidth-3)
    s ix=$o(@index@(""),sort)
    s strt=crp-1*limit
    f i=1:1:strt s ix=$o(@index@(ix),sort)
    f i=1:1:limit d BKITEM
    d TBFT^tmpBASlibs
    d DRAW
    s key=$$Key^tmpBASsys()
    q:key="ESC" 1
    d:key="LEFT" TBLEFT^tmpBASlibs
    d:key="RIGHT" TBRIGHT^tmpBASlibs
    d:key="UP" TBUP^tmpBASlibs
    d:key="DOWN" TBDOWN^tmpBASlibs
    d:key="ENT" BKSHOW
    d:key="DEL" BKDEL,BKUPD
    d:key="F2" BKNEW,BKUPD
    d:key="F3" SORT,BKUPD
    d:key="F4" FIND,BKUPD
    d:key="F5" BKIDX,BKUPD
    q 0
BKITEM ; Вывод книги
    n id,nm,ct,at,cnt,prn,gt
    q:ix=""
    q:strt+i>ctidx
    s id=$g(@index@(ix))
    q:id=""
    s nm=$g(@book@(id))
    s ct=$g(@book@(id,"cat"))
    s at=$g(@book@(id,"author"))
    s cnt=$g(@book@(id,"count"))
    s prn=$g(@book@(id,"print"))
    s:fus gt=$g(@user@(fus,"bk",id))
    s:i=ci item=id
    d:i=ci TXT(7+i,1,">")
    d TXT(7+i,2,id,,,7)
    d:'fus TXT(7+i,10,nm,,,32)
    d:fus TXT(7+i,10,nm,,,22)
    d:fus TXT(7+i,33,gt,,,10,1)
    d TXT(7+i,44,ct,,,9,1)
    d TXT(7+i,54,at,,,5,1)
    d TXT(7+i,60,cnt,,,8,1)
    d TXT(7+i,69,prn,,,10,1)
    s ix=$o(@index@(ix),sort)
    s pgc=$i(pgc)
    q
BKSHOW ; Страница просмотра книги
    q:'$d(item)
    q:'$d(@book@(item))
    f  q:$$BkShScr
    q
BkShScr() ; Экран книги
    n txt,nm,ct,at,cnt,ctn,atn,prt,txt,gt
    s nm=$g(@book@(item))
    s ct=$g(@book@(item,"cat"),0)
    s at=$g(@book@(item,"author"),0)
    s cnt=$g(@book@(item,"count"),0)
    s prt=$g(@book@(item,"print"),0)
    s ctn=$g(@cat@(ct))
    s atn=$g(@author@(at))
    s:fus gt=$g(@user@(fus,"bk",item))
    d TOP
    s txt="Книги > Книга: ["_item_"]"
    s:fus txt="Книги > Книга: ["_item_"] пользователя: ["_fus_"]"
    d TXT(3,1,txt)
    d TXT(5,1,"Название: "_nm)
    d TXT(6,1,"Категория["_ct_"]: "_ctn)
    d TXT(7,1,"Автор["_at_"]: "_atn)
    d TXT(8,1,"Количество: "_cnt)
    d TXT(9,1,"Издана: "_$g(prt))
    d:fus TXT(11,1,"Взята: "_$g(gt))
    s txt="ESC:выход DEL:удаление"
    s txt=txt_" ENT:редактирование"
    d TXT(cheight-1,1,"-",,cwidth-3)
    d TXT(cheight,1,txt)
    d DRAW
    s key=$$Key^tmpBASsys()
    i key="DEL" d BKDEL q 1
    i key="ENT" d BKEDIT q 0
    q:key="ESC" 1
    q 0
BKDEL ; Удаление книги
    n name,key
    q:'$d(item)
    if fus k @user@(fus,"bk",item) q
    ; удаление из индекса
    s name=@book@(item)
    s key=name_id
    k @bknidx@(key)
    k @bkididx@(item)
    k @book@(item)
    q
BKEDIT ; Страница редактирования книги
    d TOP
    s txt="Книги > Обновление книги: ["_item_"]"
    s:fus txt="Книги > Обновление книги: ["_item_"],"
    s:fus txt=txt_" пользователя: ["_fus_"]"
    d TXT(3,1,txt)
    d DRAW
    if fus d BKUSUP q
    d BKIN
    q
BKUSUP ; Страница обновления взятой книги
    n dat
    w !!," Пропуская ввод, Вы оставляете значение без изменения!",!
    w !," Дата взятия книги: "
    s dat=$$Input^tmpBASsys()
    q:dat=-1
    s:$l(dat) @user@(fus,"bk",item)=dat
    q
BKNEW ; Страница регистрации книги
    n nm,ct,at,cnt,prt,txt
    d TOP
    s txt="Книги > Регистрация"
    s:fus txt="Книги > Добавление пользователю: ["_fus_"]"
    d TXT(3,1,txt)
    d DRAW
    if fus d BKADD q
    d BKIN
    q
BKADD ; Добавление книги пользователю
    n id,dat
    w !!," Индекс книги: "
    s id=$$Input^tmpBASsys()
    q:id=-1
    w !," Дата взятия книги: "
    s dat=$$Input^tmpBASsys()
    q:dat=-1
    s @user@(fus,"bk",id)=dat
    q
BKIN ; Ввод данных книги
    n id,nm2,ct2,at2,cnt2,prt2
    w !!," Пропуская ввод, Вы оставляете значение без изменения!",!
    w !," Индекс:* "
    s id=$$Input^tmpBASsys($g(item))
    q:id=-1
    w !," Название: "
    s nm2=$$Input^tmpBASsys($g(nm))
    q:nm2=-1
    w !," Категория[id]: "
    s ct2=$$Input^tmpBASsys($g(ct))
    q:ct2=-1
    w !," Автор[id]: "
    s at2=$$Input^tmpBASsys($g(at))
    q:at2=-1
    w !," Количество: "
    s cnt2=$$Input^tmpBASsys($g(cnt))
    q:cnt2=-1
    w !," Издана: "
    s prt2=$$Input^tmpBASsys($g(prt))
    q:prt2=-1
    s:$l(nm2) @book@(id)=nm2
    s:$l(ct2) @book@(id,"cat")=ct2
    s:$l(at2) @book@(id,"author")=at2
    s:$l(cnt2) @book@(id,"count")=cnt2
    s:$l(prt2) @book@(id,"print")=prt2
    q
CAT ; Страница управления категориями
    n catnidx,catididx,ci,idx,index,ctidx,pgs,crp,sort,fnd
    ; catnidx - именной индекс
    ; catididx - индексный индекс
    s index=data_"(""catidx"")"
    s catnidx=data_"(""catnidx"")"
    s catididx=data_"(""catididx"")"
    d CTIDX
    d CTUPD
    f  q:$$CtScr
    q
CTIDX ; Обновление индекса категорий
    n cnt,id
    k @catnidx
    k @catididx
    s id=""
    f  s id=$o(@cat@(id)) q:id=""  d CTIDXI
    s @cat=$g(cnt,0)
    q
CTIDXI ; Индексирование категори
    n i,name,key,cc
    s name=@cat@(id)
    s key=name_id
    s cnt=$i(cnt)
    s @catnidx@(key)=id
    s @catididx@(id)=id
    s i=""
    f  s i=$o(@book@(i)) q:i=""  d BKCTCN
    s @cat@(id,"count")=$g(cc)
    q
BKCTCN ; Подсчет книг категории
    s bc=$g(@book@(i,"cat"))
    s:bc=id cc=$i(cc)
    q
CTUPD ; Обновление таблицы категорий
    k @index
    s idx=$g(idx,1)
    s sort=$g(sort,1)
    s fnd=$g(fnd)
    m:idx=1 @index=@catididx
    m:idx=2 @index=@catnidx
    s ctidx=$g(@cat)
    d:$l(fnd) CTFND
    d PGSUPD^tmpBASlibs(ctidx,.pgs,limit)
    s ci=1
    s crp=1
    q
CTFND ; Поиск категории
    n ix,cnt
    s ix=""
    f  s ix=$o(@index@(ix)) q:ix=""  d CTFNDI
    s ctidx=$g(cnt,0)
    q
CTFNDI ; Поиск по записи
    n id,name
    s id=$g(@index@(ix))
    i $f(id,fnd) s cnt=$i(cnt) q
    s name=$g(@cat@(id))
    i $f(name,fnd) s cnt=$i(cnt) q
    k @index@(ix) q
    q
CtScr() ; Экран
    n i,key,ix,strt,pgc,item
    ; *описаны в BkLsScr
    d TOP
    d TXT(3,1,"Категории > Список")
    d SRTXT^tmpBASlibs
    d INFPGS^tmpBASlibs(ctidx,crp,pgs)
    d TXT(4,-1,"Поиск: ["_fnd_"]",2)
    d TXT(5,1,"-",,cwidth-3)
    d TXT(6,1,"Индекс")
    d TXT(6,10,"Название",,,40)
    d TXT(6,50,"Количество книг",,,30,1)
    d TXT(7,1,"-",,cwidth-3)
    s ix=$o(@index@(""),sort)
    s strt=crp-1*limit
    f i=1:1:strt s ix=$o(@index@(ix),sort)
    f i=1:1:limit d CTITEM
    d TBFT^tmpBASlibs
    d TXT(cheight,-1,"F6:книги",2)
    d DRAW
    s key=$$Key^tmpBASsys()
    q:key="ESC" 1
    d:key="LEFT" TBLEFT^tmpBASlibs
    d:key="RIGHT" TBRIGHT^tmpBASlibs
    d:key="UP" TBUP^tmpBASlibs
    d:key="DOWN" TBDOWN^tmpBASlibs
    d:key="ENT" CTSHOW
    d:key="DEL" CTDEL
    d:key="F2" CTNEW
    d:key="F3" SORT,CTUPD
    d:key="F4" FIND,CTUPD
    d:key="F5" CTIDX,CTUPD
    d:key="F6" BKLIST(item)
    q 0
CTITEM ; Вывод категории
    n id,nm,cnt
    q:ix=""
    q:strt+i>ctidx
    s id=$g(@index@(ix))
    q:id=""
    s nm=$g(@cat@(id))
    s cnt=$g(@cat@(id,"count"))
    s:i=ci item=id
    d:i=ci TXT(7+i,1,">")
    d TXT(7+i,2,id,,,8)
    d TXT(7+i,10,nm,,,40)
    d TXT(7+i,50,cnt,,,30,1)
    s ix=$o(@index@(ix),sort)
    s pgc=$i(pgc)
    q
CTSHOW ; Страница просмотра категории
    q:'$d(item)
    q:'$d(@cat@(item))
    f  q:$$CtShScr
    q
CtShScr() ; Экран категории
    n nm
    s nm=$g(@cat@(item))
    d TOP
    d TXT(3,1,"Категории > Просмотр: ["_item_"]")
    d TXT(5,1,"Название: "_nm)
    s txt="ESC:выход DEL:удаление"
    s txt=txt_" ENT:редактирование"
    d TXT(cheight-1,1,"-",,cwidth-3)
    d TXT(cheight,1,txt)
    d DRAW
    s key=$$Key^tmpBASsys()
    i key="DEL" d CTDEL q 1
    i key="ENT" d CTEDIT q 0
    q:key="ESC" 1
    q 0
CTDEL ; Удаление категории
    q:'$d(item)
    ; удаление из индекса
    s name=@cat@(item)
    s key=name_id
    k @catnidx@(key)
    k @catididx@(item)
    k @cat@(item)
    q
CTEDIT ; Страница редактирования категории
    d TOP
    d TXT(3,1,"Категории > Редактирование: ["_item_"]")
    d DRAW
    d CTIN
    q
CTNEW ; Страница создания категории
    n item,nm
    d TOP
    d TXT(3,1,"Категории > Создание")
    d DRAW
    d CTIN
    q
CTIN ; Ввод данных категории
    n id,nm2
    w !!," Пропуская ввод, Вы оставляете значение без изменения!",!
    w !," Индекс: "
    s id=$$Input^tmpBASsys($g(item))
    q:id=-1
    w !," Название: "
    s nm2=$$Input^tmpBASsys($g(nm))
    q:nm2=-1
    s:$l(nm2) @cat@(id)=nm2
    q
AUTHOR ; Страница управления авторами
    n athnidx,athididx,ci,idx,index,ctidx,pgs,crp,sort,fnd
    ; athnidx - именной индекс
    ; athididx - индексный индекс
    s athnidx=data_"(""athnidx"")"
    s athididx=data_"(""athididx"")"
    d ATHUPD
    f  q:$$AthScr
    q
ATHIDX ; Обновление индекса авторов
    n cnt,id
    k @athnidx
    k @athididx
    s id=""
    f  s id=$o(@author@(id)) q:id=""  d ATHIDXI
    s @author=$g(cnt,0)
    q
ATHIDXI ; Индексирование авторов
    n name,key,i,cc
    s name=@author@(id)
    s key=name_id
    s cnt=$i(cnt)
    s @athnidx@(key)=id
    s @athididx@(id)=id
    s i=""
    f  s i=$o(@book@(i)) q:i=""  d BKATCN
    s @author@(id,"count")=$g(cc)
    q
BKATCN ; Подсчет книг автора
    n at
    s at=$g(@book@(i,"author"))
    s:at=id cc=$i(cc)
    q
ATHUPD ; Обновление таблицы авторов
    k index
    s idx=$g(idx,1)
    s sort=$g(sort,1)
    s fnd=$g(fnd)
    m:idx=1 index=athididx
    m:idx=2 index=athnidx
    s ctidx=$g(@author)
    d:$l(fnd) ATHFND
    d PGSUPD^tmpBASlibs(ctidx,.pgs,limit)
    s ci=1
    s crp=1
    q
ATHFND ; Поиск автора
    n ix,cnt
    s ix=""
    f  s ix=$o(@index@(ix)) q:ix=""  d ATHFNDI
    s ctidx=$g(cnt,0)
    q
ATHFNDI ; Поиск по записи
    n id,name
    s id=$g(@index@(ix))
    i $f(id,fnd) s cnt=$i(cnt) q
    s name=$g(@author@(id))
    i $f(name,fnd) s cnt=$i(cnt) q
    k @index@(ix) q
    q
AthScr() ; Экран
    n i,key,ix,strt,pgc,item
    d TOP
    d TXT(3,1,"Авторы > Список")
    d SRTXT^tmpBASlibs
    d INFPGS^tmpBASlibs(ctidx,crp,pgs)
    d TXT(4,-1,"Поиск: ["_fnd_"]",2)
    d TXT(5,1,"-",,cwidth-3)
    d TXT(6,1,"Индекс")
    d TXT(6,10,"Фамилия Имя Отчество")
    d TXT(6,40,"Количество книг",,,20,1)
    d TXT(6,60,"Дата рождения",,,20,1)
    d TXT(7,1,"-",,cwidth-3)
    s ix=$o(@index@(""),sort)
    s strt=crp-1*limit
    f i=1:1:strt s ix=$o(@index@(ix),sort)
    f i=1:1:limit d ATHITEM
    d TBFT^tmpBASlibs
    d TXT(cheight,-1,"F6:книги",2)
    d DRAW
    s key=$$Key^tmpBASsys()
    q:key="ESC" 1
    d:key="LEFT" TBLEFT^tmpBASlibs
    d:key="RIGHT" TBRIGHT^tmpBASlibs
    d:key="UP" TBUP^tmpBASlibs
    d:key="DOWN" TBDOWN^tmpBASlibs
    d:key="ENT" ATHSHOW
    d:key="DEL" ATHDEL
    d:key="F2" ATHNEW
    d:key="F3" SORT,ATHUPD
    d:key="F4" FIND,ATHUPD
    d:key="F5" ATHIDX,ATHUPD
    d:key="F6" BKLIST(,item)
    q 0
ATHITEM ; Вывод автора
    n id,nm,cnt,dat
    q:ix=""
    q:strt+i>ctidx
    s id=$g(@index@(ix))
    q:id=""
    s nm=$g(@author@(id))
    s cnt=$g(@author@(id,"count"))
    s dat=$g(@author@(id,"birth"))
    s:i=ci item=id
    d:i=ci TXT(7+i,1,">")
    d TXT(7+i,2,id)
    d TXT(7+i,10,nm)
    d TXT(7+i,40,cnt,,,20,1)
    d TXT(7+i,60,dat,,,20,1)
    s ix=$o(@index@(ix),sort)
    s pgc=$i(pgc)
    q
ATHSHOW ; Страница просмотра автора
    q:'$d(item)
    q:'$d(@author@(item))
    f  q:$$AthShScr
    q
AthShScr() ; Экран автора
    n nm,dat,txt
    s nm=$g(@author@(item))
    s dat=$g(@author@(item,"birth"))
    d TOP
    d TXT(3,1,"Авторы > Просмотр: ["_item_"]")
    d TXT(5,1,"Ф.И.О.: "_nm)
    d TXT(6,1,"Дата рождения: "_dat)
    s txt="ESC:выход DEL:удаление"
    s txt=txt_" ENT:редактирование"
    d TXT(cheight-1,1,"-",,cwidth-3)
    d TXT(cheight,1,txt)
    d DRAW
    s key=$$Key^tmpBASsys()
    i key="DEL" d ATHDEL q 1
    i key="ENT" d ATHEDIT q 0
    q:key="ESC" 1
    q 0
ATHDEL ; Удаление автора
    q:'$d(item)
    ; удаление из индекса
    s name=@author@(item)
    s key=name_id
    k @athnidx@(key)
    k @athididx@(item)
    k @author@(item)
    q
ATHEDIT ; Страница редактирования автора
    d TOP
    d TXT(3,1,"Авторы > Редактирование: ["_item_"]")
    d DRAW
    d ATHIN
    q
ATHNEW ; Страница регистрации автора
    n item,nm,dat
    d TOP
    d TXT(3,1,"Авторы > Регистрация")
    d DRAW
    d ATHIN
    q
ATHIN ; Ввод данных автора
    n id,nm2,dat2
    w !!," Пропуская ввод, Вы оставляете значение без изменения!",!
    w !," Индекс: "
    s id=$$Input^tmpBASsys($g(item))
    q:id=-1
    w !," Ф.И.О.: "
    s nm2=$$Input^tmpBASsys($g(nm))
    q:nm2=-1
    w !," Дата рождения: "
    s dat2=$$Input^tmpBASsys($g(dat))
    q:dat2=-1
    s:$l(nm2) @author@(id)=nm2
    s:$l(dat2) @author@(id,"birth")=dat2
    q
USER(Flt) ; Страница управления пользователями
    n usnidx,usididx,ci,idx,index,ctidx,pgs,crp,sort,fnd,flt
    ; usnidx - именной индекс
    ; usididx - индексный индекс
    s usnidx=data_"(""usnidx"")"
    s usididx=data_"(""usididx"")"
    ; установка фильтра
    s flt=$g(Flt)
    d USIDX
    d USUPD
    f  q:$$UsScr
    q
USIDX ; Обновление индекса пользователей
    n cnt,id
    k @usnidx
    k @usididx
    s id=""
    f  s id=$o(@user@(id)) q:id=""  d USIDXI
    s @user=$g(cnt,0)
    q
USIDXI ; Индексирование пользователей
    n name,key,i,cc
    s name=@user@(id)
    s key=name_id
    s cnt=$i(cnt)
    s @usnidx@(key)=id
    s @usididx@(id)=id
    s i=""
    f  s i=$o(@user@(id,"bk",i)) q:i=""  s cc=$i(cc)
    s @user@(id,"bk")=$g(cc,0)
    q
USUPD ; Обновление таблицы пользователей
    n usf
    k index
    ; usf - флаг поиска
    s idx=$g(idx,1)
    s sort=$g(sort,1)
    s fnd=$g(fnd)
    m:idx=1 index=usididx
    m:idx=2 index=usnidx
    s ctidx=$g(@user)
    s usf=$s(fnd:1,flt:1,1:0)
    d:usf USFND
    d PGSUPD^tmpBASlibs(ctidx,.pgs,limit)
    s ci=1
    s crp=1
    q
USFND ; Поиск пользователя
    n ix,cnt
    s ix=""
    f  s ix=$o(@index@(ix)) q:ix=""  d USFNDI
    s ctidx=$g(cnt,0)
    q
USFNDI ; Поиск по записи
    n id,name,bk,fs
    ; fs - флаг поиска
    s id=$g(@index@(ix))
    s name=$g(@user@(id))
    s bk=$g(@user@(id,"bk"))
    s fs=1
    i flt=1,bk<1 s fs=0
    i flt=2,bk<5 s fs=0
    i fs,$f(id,fnd) s cnt=$i(cnt) q
    i fs,$f(name,fnd) s cnt=$i(cnt) q
    k @index@(ix) q
    q
UsScr() ; Экран
    n i,key,ix,strt,pgc,item
    d TOP
    d TXT(3,1,"Пользователи > Список")
    d SRTXT^tmpBASlibs
    d INFPGS^tmpBASlibs(ctidx,crp,pgs)
    d TXT(4,-1,"Поиск: ["_fnd_"]",2)
    d TXT(5,1,"-",,cwidth-3)
    d TXT(6,1,"Индекс")
    d TXT(6,10,"Фамилия Имя Отчество",,,30)
    d TXT(6,40,"Книг",,,20,1)
    d TXT(6,60,"Дата рождения",,,20,1)
    d TXT(7,1,"-",,cwidth-3)
    s ix=$o(@index@(""),sort)
    s strt=crp-1*limit
    f i=1:1:strt s ix=$o(@index@(ix),sort)
    f i=1:1:limit d USITEM
    d TBFT^tmpBASlibs
    d TXT(cheight,-1,"F6:книги",2)
    d DRAW
    s key=$$Key^tmpBASsys()
    q:key="ESC" 1
    d:key="LEFT" TBLEFT^tmpBASlibs
    d:key="RIGHT" TBRIGHT^tmpBASlibs
    d:key="UP" TBUP^tmpBASlibs
    d:key="DOWN" TBDOWN^tmpBASlibs
    d:key="ENT" USSHOW
    d:key="DEL" USDEL
    d:key="F2" USNEW
    d:key="F3" SORT,USUPD
    d:key="F4" FIND,USUPD
    d:key="F5" USIDX,USUPD
    d:key="F6" BKLIST(,,item)
    q 0
USITEM ; Вывод пользователя
    n id,nm,dat,bk
    q:ix=""
    q:strt+i>ctidx
    s id=$g(@index@(ix))
    q:id=""
    s nm=$g(@user@(id))
    s dat=$g(@user@(id,"birth"))
    s bk=$g(@user@(id,"bk"))
    s:i=ci item=id
    d:i=ci TXT(7+i,1,">")
    d TXT(7+i,2,id)
    d TXT(7+i,10,nm,,,30)
    d TXT(7+i,40,bk,,,20,1)
    d TXT(7+i,60,dat,,,20,1)
    s ix=$o(@index@(ix),sort)
    s pgc=$i(pgc)
    q
USSHOW ; Страница просмотра пользователя
    q:'$d(item)
    q:'$d(@user@(item))
    f  q:$$UsShScr
    q
UsShScr() ; Экран пользователя
    n nm,dat,bk,txt
    s nm=$g(@user@(item))
    s dat=$g(@user@(item,"birth"))
    s bk=$g(@user@(item,"bk"))
    d TOP
    d TXT(3,1,"Пользователи > Просмотр: ["_item_"]")
    d TXT(5,1,"Ф.И.О.: "_nm)
    d TXT(6,1,"Дата рождения: "_dat)
    d TXT(7,1,"Взято книг: "_bk)
    s txt="ESC:выход DEL:удаление"
    s txt=txt_" ENT:редактирование"
    d TXT(cheight-1,1,"-",,cwidth-3)
    d TXT(cheight,1,txt)
    d DRAW
    s key=$$Key^tmpBASsys()
    i key="DEL" d USDEL q 1
    i key="ENT" d USEDIT q 0
    q:key="ESC" 1
    q 0
USDEL ; Удаление автора
    q:'$d(item)
    ; удаление из индекса
    s name=@user@(item)
    s key=name_id
    k @usnidx@(key)
    k @usididx@(item)
    k @user@(item)
    q
USEDIT ; Страница редактирования пользователя
    d TOP
    d TXT(3,1,"Пользователи > Редактирование: ["_item_"]")
    d DRAW
    d USIN
    q
USNEW ; Страница регистрации пользователя
    n item,nm,dat
    d TOP
    d TXT(3,1,"Пользователи > Регистрация")
    d DRAW
    d USIN
    q
USIN ; Ввод данных пользователя
    n id,nm2,dat2
    w !!," Пропуская ввод, Вы оставляете значение без изменения!",!
    w !," Индекс: "
    s id=$$Input^tmpBASsys($g(item))
    q:id=-1
    w !," Ф.И.О.: "
    s nm2=$$Input^tmpBASsys($g(nm))
    q:nm2=-1
    w !," Дата рождения: "
    s dat2=$$Input^tmpBASsys($g(dat))
    q:dat2=-1
    s:$l(nm2) @user@(id)=nm2
    s:$l(dat2) @user@(id,"birth")=dat2
    q
SELECT ; Страница с выборками
    n mi
    s mi=1
    f  q:$$SlScr
    q
SlScr() ; Экран выбори
    n id
    s:mi>4 mi=4
    s:mi<1 mi=1
    d TOP
    d TXT(3,1,"Выборки")
    d TXT(4,1,"-",,cwidth-3)
    s id=""
    f  s id=$$Menu^tmpBASlibs("select",id,mi,5) q:'id
    d HINT("ESC:выход")
    d DRAW
    q $$KeyCont("SlKeys")
SlKeys(I) ; Обработка нажатий
    i I=1 d USER(1)
    i I=2 d USER(2)
    i I=3 d BKLIST(,,,3)
    i I=4 d BKLIST(,,,4)
    q 0