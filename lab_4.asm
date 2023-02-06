; 8. В заданной строке удалить повторяющиеся  пробелы,  оставив только по одному
.286C
.model small
.stack 100h

.data
	str2        db 100 dup ('$')
	buff1       db 100 dup('$')
	skip        db ' ',0Dh,0Ah,'$'
	spacescount db 0

.code
	start:         
	               mov  ax, @data        	;Инициализация сегментных данных
	               mov  ds, ax

	               call In_str

	               mov  si, offset buff1
	               mov  di, offset str2

	DoubleSpace:   
	               mov  al, [si]
	               cmp  al, ' '
	               je   SFound
	               mov  spacescount, 0
	NextSymbol:    
	               mov  al, [si]
	               mov  [di], al

	               cmp  al, '$'
	               je   EndSearch
	               inc  si
	               inc  di
	               jmp  DoubleSpace
	SFound:        
	               add  spacescount, 1
	               cmp  spacescount, 1
	               jg   DSFound
	               jmp  NextSymbol
	DSFound:       
	               inc  si
	               mov  al, [si]
	               cmp  al, ' '
	               je   DSFound
	               mov  spacescount, 0
	               jmp  NextSymbol
	EndSearch:     

	               mov  ah, 09h
	               mov  dx, offset skip
	               int  21h

	               mov  ah, 09h
	               mov  dx, offset str2
	               int  21h

	               mov  ax, 4c00h        	;Стандартный выход - ah=00h
	               int  21h

LenCount proc                        		;Подсчёт количества символов в строке
	               mov  al, [si]         	;Получаем символ

	lencount_posit:
	               mov  al, [si + bx]    	;Получаем символ
	               cmp  al, '$'
	               je   lencount_End
	               inc  bx
	               loop lencount_posit

	lencount_End:  
	               ret
LenCount endp

In_str proc                          		;Посимвольный ввод строки
	               mov  si, 0
	               mov  bx, offset buff1

	loop1:         
	               mov  ax, 0

	               mov  ah,01h           	;Вызов ввода символа
	               int  21h

	               cmp  al, 13           	;Сравнение символа и символа конца строки
	               je   loopend          	;Если конец строки - выходим
	               mov  byte ptr [bx], al
	               inc  bx
	               loop loop1

	loopend:       
	               mov  si, offset buff1
	               mov  bx, 0
	               call LenCount

	               add  si, bx           	;Перемещение указателя за строку

	               mov  [si], 0Dh        	;Вставка символа возврата каретки
	               inc  si
	               mov  [si], 0Ah        	;Вставка символа начала строки
	               inc  si
	               mov  [si], byte ptr 13	;Вставка символа конца строки
	               ret
In_str endp

end start
