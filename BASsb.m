    /// Булгаков А.С.; Игра Морской бой
MAIN ; Начало программы
    n cwidth,cheight,data,screen,menu,pc,user
    ; data - глобал данных
    ; screen - ячейки экрана
    ; menu - пункты меню
    ; pc - глобал компьютера
    ; user - глобал пользователя
    d DEF
    d Echo^tmpBASsys(0)
    ; основной цикл
    f  q:$$MScr
    d Echo^tmpBASsys(1)
    w #
    q
DEF ; Настройки
    s game=0
    s cwidth=80
    s cheight=24
    s data="^tmpBASsb"
    s pc=data_"(""pc"")"
    s @pc@("cnt")=20
    s @pc="Компьютер"
    s user=data_"(""user"")"
    s @user@("cnt")=20
    s menu=data_"(""menu"")"
    s @menu@("main",1)="Начать игру"
    s @menu@("main",2)="Выйти"
    q
TXT(Top,Lft,Txt,Aln,Rpt,Lmt,Aln2) ; Установка текста
    n i,len
    s Top=$g(Top,1)
    s Lft=$g(Lft,0)
    s Txt=$g(Txt,"")
    s Aln=$g(Aln,0)
    s Rpt=$g(Rpt,0)
    s Lmt=$g(Lmt,0)
    s Aln2=$g(Aln2,0)
    s tmp=""
    f i=1:1:Rpt s tmp=tmp_Txt
    s Txt=Txt_tmp
    s len=$l(Txt)
    i Lmt,len>Lmt d CROP
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
    w #
    s lst=$o(screen(""),-1)
    f i=1:1:lst d DLINE
    q
DLINE ; Вывод строки экрана
    n j
    f j=1:1:cwidth w $g(screen(i,j)," ")
    q
CLR ; Очистка экрана
    n i,ls
    s ls=$o(screen(""),-1)
    f i=1:1:ls k screen(i)
    q
Menu(Key,Id,Top,Lft) ; Вывод меню
    n txt
    s Top=$g(Top,0)
    s Lft=$g(Lft,0)
    s id=$o(@menu@(Key,Id))
    q:id="" 0
    s txt=@menu@(Key,id)
    d TXT(Top+id,Lft,id_": "_txt)
    q id
TOP ; Установка шапки
    d CLR
    d TXT(1,1,"Игра МОРСКОЙ БОЙ")
    d TXT(1,-1,"Разработка НПЦ АИР",2)
    d TXT(2,,"-",,cwidth-1)
    q
MScr() ; Обработка главного окна
    n id,k
    d TOP
    d TXT(3,1,"Главное меню")
    s id=""
    f  s id=$$Menu("main",id,4,1) q:'id
    d DRAW
    w !!," Ваш выбор: "
    s k=$$Key^tmpBASsys()
    i k="ESC" w k q 1
    ; если указана цифра
    i k>48,k<58 q $$MKeys(k-48)
    q 0
MKeys(I) ; Обработка нажатий окна
    w I
    i I=1 d GAME q 0
    q:I=2 1
    q 0
FILDS ; Установка полей
    n lett,i,j,l1,t1,l2,t2,p,lf
    s lett="A,B,C,D,E,F,G,H,I,J"
    s l1=7
    s l2=cwidth/2+l1
    s t1=4
    s t2=4
    d TOP
    d TXT(2,1,"["_$g(@pc)_"]")
    s lf=cwidth/2+1
    d TXT(2,lf,"["_$g(@user)_"]")
    d TXT(17,,"-",,cwidth-1)
    f i=0:1:9 d FLDLN
    f i=1:1:16 s screen(1+i,cwidth/2)="|"
    d:$g(cnt) TXT(17,,"Ход:["_cnt_"]",1)
    q
FLDLN ; Заполнение полей
    s p=$p(lett,",",i+1)
    d TXT(t1,l1+i,p)
    d TXT(t1+11,l1+i,p)
    d TXT(t1,l2+i,p)
    d TXT(t1+11,l2+i,p)
    d TXT(t2+1+i,l1-2,i)
    d TXT(t2+1+i,l1+11,i)
    d TXT(t2+1+i,l2-2,i)
    d TXT(t2+1+i,l2+11,i)
    f j=0:1:9 d FLD1,FLD2
    d TXT(7,22,"Палубы:"_$g(@pc@("cnt")))
    d TXT(9,22,"Выстрелы:"_$g(sp,0))
    d TXT(7,62,"Палубы:"_$g(@user@("cnt")))
    d TXT(9,62,"Выстрелы:"_$g(su,0))
    q
FLD1 ; Поле 1
    n v,p
    s v=$g(@user@("hit",j,i),0)
    //s v=$g(@pc@("fld",j,i),0)
    s p=v
    s:'v p=$c(126)
    s:v=7 p=$c(164)
    s screen(t1+i+1,l1+j+1)=p
    q
FLD2 ; Поле 2
    n v,p
    s v=$g(@user@("fld",j,i),0)
    s p=v
    s:'v p=$c(126)
    s:v=5 p=$c(183)
    s:v=7 p=$c(164)
    s:v=9 p=$c(149)
    s screen(t2+i+1,l2+j+1)=p
    q
    ; -------------------------
GAME ; Запуск игры
    n er,sh,cnt,sp,su,pcx,pcy,pcp
    ; sh - номер стрелка
    ; sp - кол-во выстрелов pc
    ; su - кол-во выстрелов us
    ; pcx - x выстрела pc
    ; pcy - y выстрела pc
    ; pcp - точка выстрела pc
    d GMSET
    q:$g(er)
    s sh=$r(2)+1
    w:sh=1 !," Первым ходит компьютер"
    w:sh=2 !," Первым ходит игрок"
    f  q:$$Round()
    q
GMSET ; Новая игра
    n i,j
    d GMCLR
    d PCSET
    f  q:$$GmQA()
    q:er
    q
GMCLR ; Инициализация
    n i,j
    k @pc@("fld")
    k @user@("fld")
    s @pc@("cnt")=20
    s @user@("cnt")=20
    f i=0:1:9 d FRF
    q
FRF ; Инициализация ячеек
    f j=0:1:9 d FRFST
    q
FRFST ; Заполнение ячеек
    s @pc@("hit",i,j)=0
    s @user@("frf",i,j)=0
    s @user@("hit",i,j)=0
    q
PCSET ; Установка "Компьютера"
    n x,y
    s x=$r(10)
    s y=$r(10)
    ; 1*4 п.к
    d ASHIP(4)
    ; 1*1 п.к
    d ASHIP(1)
    ; 1*2 п.к
    d ASHIP(2)
    ; 1*3 п.к
    d ASHIP(3)
    ; 2*2 п.к.
    d ASHIP(2)
    ; 2*1 п.к
    d ASHIP(1)
    ; 2*3 п.к
    d ASHIP(3)
    ; 3*1 п.к
    d ASHIP(1)
    ; 3*2 п.к.
    d ASHIP(2)
    ; 4*1 п.к
    d ASHIP(1)
    q
ASHIP(N) ; Автоустановка
    s x=x+1
    s:x>9 x=0
    d STY
    s:N>0 @pc@("fld",x,y)=N
    s:N>1 @pc@("fld",x,y+1)=N
    s:N>2 @pc@("fld",x,y+2)=N
    s:N>3 @pc@("fld",x,y+3)=N
    q
STY ; Установка Y
    s y=y+5
    i y+N>10 s y=$r(3) q
    i y+N>=9 s y=9-N q
    q       
Round() ; Ход игры
    n st,k
    s cnt=$i(cnt)
    d SHOOT
    d WINPC
    d WINUS
    s st=$g(st,0)
    i st r *k q 1
    q 0
SHOOT ; Выстрел
    i sh=1 d PCSH q
    i sh=2 d USSH q
    q
PCSH ; Выстрел компьютера
    n cnt,st
    s pcx=$g(pcx,0)
    s pcy=$g(pcy,0)
    d FNDPNT
    q:$g(st,1)
    k @pc@("hit",pcx,pcy)
    w !," Ход компьютера!"
    w !," Выстрел: "_$c(pcx+65)_pcy
    s sh=2
    s sp=$i(sp)
    ; проверка попадания
    s pcp=$g(@user@("fld",pcx,pcy),0)
    s @user@("fld",pcx,pcy)=7
    q:$s(pcp=0:1,pcp=5:1,pcp=7:1,1:0)
    w !," Попадание!"
    s @user@("fld",pcx,pcy)=9
    s cnt=@user@("cnt")
    s @user@("cnt")=$i(cnt,-1)
    s sh=1
    q
FNDPNT ; Выбор точки выстрела   
    d FNDXY
    s:$d(@pc@("hit",pcx))'=10 pcx=$o(@pc@("hit",""))
    q:pcx=""
    s:'$d(@pc@("hit",pcx,pcy)) pcy=$o(@pc@("hit",pcx,""))
    q:pcy=""
    s st=0
    q
FNDXY ; Установка точки выстрела
    n p,r
    s p=$g(@user@("fld",pcx,pcy))
    ; если попадания ранее не было
    ; стреляем случайно
    s:p'=9 pcx=$r(10)
    s:p'=9 pcy=$r(10)
    q:p'=9
    ; стреляем рядом
    s r=$r(4)
    i r=0 s pcy=pcy-1 q
    i r=1 s pcx=pcx+1 q
    i r=2 s pcy=pcy+1 q
    s pcx=pcx-1 
    q   
USSH ; Выстрел игрока
    n er,x,y,p
    d FILDS
    d DRAW
    w !," Ход игрока!"
    w !," Выстрел ['-': пропуск]: "
    s in=$$Input^tmpBASsys()
    i in=-1 s st=1 q
    i in="-" s sh=1 q 
    d USXY
    i $g(er,1) d USXYER q
    ; проверка клетки выстрела
    q:$g(@user@("hit",x,y),0)
    s sh=1
    s su=$i(su)
    s @user@("hit",x,y)=7
    ; проверка попадания
    s p=$g(@pc@("fld",x,y),0)
    q:'p
    s @pc@("fld",x,y)=7
    w !," Попадание!"
    s @user@("hit",x,y)=p
    s p=@pc@("cnt")
    s @pc@("cnt")=$i(p,-1)
    s sh=2
    q
USXYER ; Ошибка игрока
    w !," Ошибка!"
    s sh=2
    q
USXY ; Проверка выстрела
    q:$l(in)<2
    s x=$a($e(in,1))-65
    q:(x<0)!(x>9)
    s y=$e(in,2)
    q:(y<0)!(y>9)
    s er=0
    q
WINPC ; Победа pc
    q:@user@("cnt")
    w !," Победа "_@pc_" !"
    w !," Может еще раз?"
    s st=1
    q
WINUS ; Победа user
    q:@pc@("cnt")
    w !," Победа "_@user_" !"
    w !," "_@pc_" хочет играть!"
    s st=1
    q
GmQA() ; Опрос пользователя
    n k,v,in
    s i=$g(i,1)
    q:(i<1)||(i>11) 1
    d FILDS
    d TXT(18,1,"Заполните все поля:")
    d DRAW
    s v=$g(@data@("GmQA",i))
    w:i=1 !," Укажите логин ["_v_"]: "
    w:i=2 !," Установка 4-п.к.'X1 X2 X3 X4' ["_v_"]: "
    w:i=3 !," Установка (1)3-п.к.'X1 X2 X3' ["_v_"]: "
    w:i=4 !," Установка (2)3-п.к.'X1 X2 X3' ["_v_"]: "
    w:i=5 !," Установка (1)2-п.к.'X1 X2' ["_v_"]: "
    w:i=6 !," Установка (2)2-п.к.'X1 X2' ["_v_"]: "
    w:i=7 !," Установка (3)2-п.к.'X1 X2' ["_v_"]: "
    w:i=8 !," Установка (1)1-п.к.'X1' ["_v_"]: "
    w:i=9 !," Установка (2)1-п.к.'X1' ["_v_"]: "
    w:i=10 !," Установка (3)1-п.к.'X1' ["_v_"]: "
    w:i=11 !," Установка (4)1-п.к.'X1' ["_v_"]: "
    s er=1
    s in=$$Input^tmpBASsys(v)
    q:in=-1 1
    ; возврат назад?
    i i=2,in="^" s i=1 q 0
    d:i=1 GMQA1
    d:i=2 GMQA2
    d:(i=3)!(i=4) GMQA3
    d:(i=5)!(i=6)!(i=7) GMQA4
    d:(i=8)!(i=9)!(i=10)!(i=11) GMQA5
    i er r *k q 0
    s @data@("GmQA",i)=in
    s i=$i(i)
    q 0
SetXY(Lm,N) ; Установка координат
    n i,j,v,l,t
    s st=0
    i $l(in," ")<Lm w !," Необходимо ["_Lm_"]!" q 1
    s v=$p(in," ",N)
    s l=$a($e(v,1))-65
    s t=$e(v,2)
    d USINXY(.N)
    i 'st w !," Ошибка!" q 1
    s p(N)=v
    s x(N)=l
    s y(N)=t
    s N=$i(N)
    q:N>Lm 1
    q 0
USINXY(N) ; Проверка точек
    q:(l<0)!(l>9)
    q:$l(v)<2
    q:'$d(@user@("frf",l,t))
    i N>1,v=p(N-1) q
    i N>1,'((l=x(N-1))||(t=y(N-1))) q
    i N>1,'((l-x(N-1)=1)||(t-y(N-1)=1)) q
    s st=1
    q
USFRF(L,T) ; Заполнение вокруг
    n i,j
    f i=L-1:1:L+1 d USFRI
    q
USFRI ; Проход по L
    q:(i<0)!(i>9)
    f j=T-1:1:T+1 d USFRJ
    q
USFRJ ; Проход по T
    q:(j<0)!(j>9)
    k @user@("frf",i,j)
    q:(i=L)&(j=T)
    q:$d(@user@("fld",i,j))
    s @user@("fld",i,j)=5
    q
GMQA1 ; Установка имени
    i $l(in)<3 w !," Имя короткое!" q
    i $l(in)>35 w !," Имя длинное!" q
    s @user=in
    s er=0
    q
GMQA2 ; Установка 4-п.к.
    n j,st,p,x,y
    s j=1
    f  q:$$SetXY(4,.j)
    i 'st s er=1 q
    s @user@("fld",x(1),y(1))=4
    s @user@("fld",x(2),y(2))=4
    s @user@("fld",x(3),y(3))=4
    s @user@("fld",x(4),y(4))=4
    d USFRF(x(1),y(1))
    d USFRF(x(4),y(4))
    s er=0
    q
GMQA3 ; Установка 3-п.к.
    n j,st,p,x,y
    s j=1
    f  q:$$SetXY(3,.j)
    i 'st s er=1 q
    s @user@("fld",x(1),y(1))=3
    s @user@("fld",x(2),y(2))=3
    s @user@("fld",x(3),y(3))=3
    d USFRF(x(1),y(1))
    d USFRF(x(3),y(3))
    s er=0
    q
GMQA4 ; Установка 2-п.к.
    n j,st,p,x,y
    s j=1
    f  q:$$SetXY(2,.j)
    i 'st s er=1 q
    s @user@("fld",x(1),y(1))=2
    s @user@("fld",x(2),y(2))=2
    d USFRF(x(1),y(1))
    d USFRF(x(2),y(2))
    s er=0
    q
GMQA5 ; Установка 1-п.к.
    n j,st,p,x,y
    s j=1
    f  q:$$SetXY(1,.j)
    i 'st s er=1 q
    s @user@("fld",x(1),y(1))=1
    d USFRF(x(1),y(1))
    s er=0
    q