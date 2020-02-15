.386
.model flat, stdcall
option casemap :none
include includes\masm32.inc
include includes\kernel32.inc
include includes\user32.inc
include includes\macros\macros.asm
includelib includes\masm32.lib
includelib includes\kernel32.lib
includelib includes\user32.lib
BSIZE equ 15

.DATA
ifmt db "%d", 0     ;строка числового формата
chfmt db "%c", 0	;строка строкового формата
 

;три массива для печати начального значения переменных
first BYTE "a=" 
second BYTE "b="
third BYTE "c="
nor BYTE "No roots"
koren1 BYTE "x1 ="
koren2 BYTE "x2 ="

;значения переменных
a DD 1
b DD 3
z DD 1
result dd 0;место под результат

.DATA?
X1 DD ?
X2 DD ?
A2 DD ?
D DD ?
buf db BSIZE dup(?);буфер
zn DD ?
temp DD ?
CRLF WORD ?
 msg DD ?      ;то что мы выводим
stdout dd ?         
cWritten dd ?
;число из которого берем квадратный корень


.code
start:
	mov CRLF, 0d0ah
	invoke GetStdHandle, -11 ;дескриптор окна по умолчаниу в EAX
	mov stdout,eax 
	
	mov esi, offset first
	invoke WriteConsoleA, stdout, esi, 2, ADDR cWritten, 0
	mov EAX,a
	invoke wsprintf, ADDR buf, ADDR ifmt, eax
	invoke WriteConsoleA, stdout, ADDR buf, BSIZE, ADDR cWritten, 0 
	invoke WriteConsoleA, stdout, ADDR CRLF, 2, ADDR cWritten,0
	
	mov esi, offset second
	invoke WriteConsoleA, stdout, esi, 2, ADDR cWritten, 0
	mov EAX,b
	invoke wsprintf, ADDR buf, ADDR ifmt, EAX
	invoke WriteConsoleA, stdout, ADDR buf, BSIZE, ADDR cWritten, 0 
	invoke WriteConsoleA, stdout, ADDR CRLF, 2, ADDR cWritten,0
	
	mov esi, offset third
	invoke WriteConsoleA, stdout, esi, 2, ADDR cWritten, 0
	mov EAX,z
	invoke wsprintf, ADDR buf, ADDR ifmt, eax
	invoke WriteConsoleA, stdout, ADDR buf, BSIZE, ADDR cWritten, 0 
	invoke WriteConsoleA, stdout, ADDR CRLF, 2, ADDR cWritten,0
	invoke WriteConsoleA, stdout, ADDR CRLF, 2, ADDR cWritten,0
	
	;считаем b^2
	mov ebx, b
	mov eax, b
	mul ebx
	mov zn,eax 
	
	invoke wsprintf, ADDR buf, ADDR ifmt, zn
	invoke WriteConsoleA, stdout, ADDR buf, BSIZE, ADDR cWritten, 0
	invoke WriteConsoleA, stdout, ADDR CRLF, 2, ADDR cWritten,0
	
	;считаем a*c
	mov EAX, a
	mov EBX, z
	mul EBX
	mov temp,eax
	
	invoke wsprintf, ADDR buf, ADDR ifmt, temp
	invoke WriteConsoleA, stdout, ADDR buf, BSIZE, ADDR cWritten, 0
	invoke WriteConsoleA, stdout, ADDR CRLF, 2, ADDR cWritten,0
	
	;считаем -4*a*c
	mov EBX, 4
	mov EAX, temp
	mul EBX
	neg EAX
	mov temp,EAX
	
	invoke wsprintf, ADDR buf, ADDR ifmt, temp
	invoke WriteConsoleA, stdout, ADDR buf, BSIZE, ADDR cWritten, 0
	invoke WriteConsoleA, stdout, ADDR CRLF, 2, ADDR cWritten,0
	
	;считаем b^2 -4*a*c
	mov EBX,zn 
	add EBX, temp
	mov D,EBX
	invoke wsprintf, ADDR buf, ADDR ifmt, D
	invoke WriteConsoleA, stdout, ADDR buf, BSIZE, ADDR cWritten, 0 
	invoke WriteConsoleA, stdout, ADDR CRLF, 2, ADDR cWritten,0
	
;делим на 2	
	;mov EAX,zn
	;mov EDX,0
	;mov EBX,2
	;IDIV EBX
	;mov D,EAX

	;invoke wsprintf, ADDR buf, ADDR ifmt, D
	;invoke WriteConsoleA, stdout, ADDR buf, BSIZE, ADDR cWritten, 0 
	;invoke WriteConsoleA, stdout, ADDR CRLF, 2, ADDR cWritten,0
	
	CMP D,0
	JB L ;нет корней
	JE B ;1 корень
	JG Q ;2 корня
	
	Q:FINIT
	fild D
	fsqrt
	fist result
	invoke WriteConsoleA, stdout, ADDR CRLF, 2, ADDR cWritten,0
	invoke wsprintf, ADDR buf, ADDR ifmt, result
	invoke WriteConsoleA, stdout, ADDR buf, BSIZE, ADDR cWritten, 0
	
	mov EAX, 2
	mov EBX, a
	mul EBX
	mov A2,EAX
	invoke WriteConsoleA, stdout, ADDR CRLF, 2, ADDR cWritten,0
	INVOKE wsprintf, ADDR buf, ADDR ifmt, A2
	INVOKE WriteConsoleA, stdout, ADDR buf, BSIZE, ADDR cWritten, 0
	
	MOV ebx,b
	NEG EBX
	ADD ebx,result
	MOV zn, EBX
	
	invoke WriteConsoleA, stdout, ADDR CRLF, 2, ADDR cWritten,0
	INVOKE wsprintf, ADDR buf, ADDR ifmt, zn
	INVOKE WriteConsoleA, stdout, ADDR buf, BSIZE, ADDR cWritten, 0
		               
	MOV EAX,zn
	MOV EDX,0
	MOV EBX,A2
	DIV EBX
	MOV X1,EAX
	
	invoke WriteConsoleA, stdout, ADDR CRLF, 2, ADDR cWritten,0
	invoke WriteConsoleA, stdout, ADDR CRLF, 2, ADDR cWritten,0
	invoke WriteConsoleA, stdout, ADDR CRLF, 2, ADDR cWritten,0
	
	neg result
	invoke WriteConsoleA, stdout, ADDR CRLF, 2, ADDR cWritten,0
	INVOKE wsprintf, ADDR buf, ADDR ifmt, result
	INVOKE WriteConsoleA, stdout, ADDR buf, BSIZE, ADDR cWritten, 0
	mov ebx,b
	neg EBX
	invoke WriteConsoleA, stdout, ADDR CRLF, 2, ADDR cWritten,0
	INVOKE wsprintf, ADDR buf, ADDR ifmt, EBX
	INVOKE WriteConsoleA, stdout, ADDR buf, BSIZE, ADDR cWritten, 0
	add ebx,result
	mov zn, EBX
	
	invoke WriteConsoleA, stdout, ADDR CRLF, 2, ADDR cWritten,0
	INVOKE wsprintf, ADDR buf, ADDR ifmt, zn
	INVOKE WriteConsoleA, stdout, ADDR buf, BSIZE, ADDR cWritten, 0
	
	mov EAX,zn
	mov EDX,0
	mov EBX,A2
	DIV EBX
	mov X2,EAX
	
	invoke WriteConsoleA, stdout, ADDR CRLF, 2, ADDR cWritten,0
	mov esi, offset koren1
	INVOKE WriteConsoleA, stdout, esi, 3, ADDR cWritten, 0
	MOV EAX,X1
	INVOKE wsprintf, ADDR buf, ADDR ifmt, X1
	INVOKE WriteConsoleA, stdout, ADDR buf, BSIZE, ADDR cWritten, 0
	
	invoke WriteConsoleA, stdout, ADDR CRLF, 2, ADDR cWritten,0
	mov esi, offset koren2
	invoke WriteConsoleA, stdout, esi, 3, ADDR cWritten, 0
	mov EAX,X2
	invoke wsprintf, ADDR buf, ADDR ifmt, X2
	invoke WriteConsoleA, stdout, ADDR buf, BSIZE, ADDR cWritten, 0
	
	invoke ExitProcess,0
	
	B: FINIT
	
	mov EAX,D
	mov EDX,0
	mov EBX,A2
	DIV EBX
	mov X1,EAX
	
	invoke WriteConsoleA, stdout, ADDR CRLF, 2, ADDR cWritten,0
	mov esi, offset koren1
	INVOKE WriteConsoleA, stdout, esi, 3, ADDR cWritten, 0
	MOV EAX,X1
	INVOKE wsprintf, ADDR buf, ADDR ifmt, X1
	INVOKE WriteConsoleA, stdout, ADDR buf, BSIZE, ADDR cWritten, 0
		
	invoke ExitProcess,0
	
	L: mov esi, offset nor
	invoke WriteConsoleA, stdout, esi, 8, ADDR cWritten, 0
	
;invoke ExitProcess,0  
end start