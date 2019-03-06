;============================================
; NICU RAZVAN-ALEXANDRU 323CB - TEMA2 IOCLA
;============================================
extern puts
extern printf
extern strlen

%define BAD_ARG_EXIT_CODE -1

section .data
filename: db "./input0.dat", 0
inputlen: dd 2263

fmtstr:            db "Key: %d",0xa, 0
usage:             db "Usage: %s <task-no> (task-no can be 1,2,3,4,5,6)", 10, 0
error_no_file:     db "Error: No input file %s", 10, 0
error_cannot_read: db "Error: Cannot read input file %s", 10, 0

section .text
global main
;============================================= TASK 1 ============================================
xor_strings:
	; TODO TASK 1
	push ebp
    	mov ebp,esp
    	mov esi, [ebp+8] ; esi - cheia
    	mov edi, [ebp+12]; edi - string
    	mov ecx, edi
loop1:    
    	mov dl, byte [esi]
    	cmp dl, 0x00
    	je exit1  
    	mov dh, byte [edi]
    	cmp dh, 0x00
    	je exit1
    	; in dh am un caracter din string
    	; in dl am un caracter din cheie
    	xor dh, dl
    	mov al, dh
    	; in al am caracterul obtinut
    	stosb ; pun caracterul in edi
    	inc esi ; trec la caracterul urmator din cheie
    	jmp loop1
exit1:
    	leave
    	ret

;============================================= TASK 2 =============================================
rolling_xor:
	; TODO TASK 2
	push ebp	
    	mov ebp,esp       
    	mov esi, [ebp+8] ; esi - string    	
    	mov al, byte [esi] ; primul caracter din string
    	mov [ecx], AL
    	inc esi
	mov ebx, 1  
loop2:   	
    	mov ah, byte [esi]
    	cmp ah, 0x00
    	je exit2
    	xor al, ah
    	mov [ecx+ebx], AL
    	inc esi
	inc ebx
	mov al,ah
    	jmp loop2
exit2:          
    	leave
    	ret    

;========================================== TASK 3 AUX ===========================================

converttodec: ; transform valorile din ah,al,bh,bl in valori decimale. ex. a=10 f=15
    	cmp ah, 'a'
    	jl cifraah
    	cmp ah, 'f'
   	jg cifraah
    	sub ah, 87 ; ah e litera
    	jmp continueal 
cifraah:
    	sub ah, '0'
continueal:
    	cmp al, 'a'
    	jl cifraal
    	cmp al, 'f'
    	jg cifraal
    	sub al, 87 ; dl e litera
    	jmp continuebh
cifraal:
   	 sub al, '0'
continuebh:
    	cmp bh, 'a'
    	jl cifrabh
    	cmp bh, 'f'
    	jg cifrabh
    	sub bh, 87 ; dh e litera
    	jmp continuebl
cifrabh:
    	sub bh, '0'
continuebl:
    	cmp bl, 'a'
    	jl cifrabl
    	cmp bl, 'f'
    	jg cifrabl
    	sub bl, 87 ; dh e litera
    	jmp exitconvert
cifrabl:
    	sub bl, '0'    
exitconvert:
    	shl ah, 4
    	add ah, AL
    	shl bh, 4
    	add bh, BL
    	jmp returnconv

;========================================== TASK 3 =================================================

xor_hex_strings:
	; TODO TASK 3
    	push ebp
    	mov ebp,esp
    	mov esi, [ebp+8] ; esi - cheia
    	mov edi, [ebp+12]; edi - string
    	xor edx,edx
loop3:    
    	mov ah, byte [edi]
    	cmp ah, 0x00
    	je exit3
    	mov al, byte [edi+1]
    	cmp al, 0x00
    	je exit3
    	mov bh, byte [esi]
    	cmp bh, 0x00
    	je exit3
    	mov bl, byte [esi+1]
    	cmp bl, 0x00
    	je exit3
    	jmp converttodec
	; iau cate 2 caractere din cheie si cuvant si le convertesc din hexa -> decimal
returnconv:    
    	; in AH am valoarea unui hex din string - in BH am valoarea unui hex din cheie
    	xor ah, bh
    	mov [ecx+edx], ah
    	add edx, 1 
    	add esi, 2
    	add edi, 2  
    	jmp loop3
exit3:
	mov byte [ecx+edx], 0x0
    	leave
    	ret    

;======================================== TASK 4 AUX ==================================================

stringtobinary: ; functie care converteste un string de forma "0100111" in valoarea decimala.
    	xor ah,ah
    	mov bl, byte [esi]
    	cmp bl, '1'
    	je adun128
ret128:
    	mov bl, byte [esi+1]
    	cmp bl, '1'   
    	je adun64
ret64:
    	mov bl, byte [esi+2]
    	cmp bl, '1'  
    	jmp adun32
ret32:
    	mov bl, byte [esi+3]
    	cmp bl, '1'   
    	je adun16
ret16:
    	mov bl, byte [esi+4]
    	cmp bl, '1'   
    	je adun8
ret8:
    	mov bl, byte [esi+5]
    	cmp bl, '1'   
    	je adun4
ret4:
    	mov bl, byte [esi+6]
    	cmp bl, '1'   
    	je adun2
ret2:
    	mov bl, byte [esi+7]
    	cmp bl, '1'   
    	je adun1
    	jmp returnconversion
    
adun128:
    	add ah,128
    	jmp ret128
adun64:
    	add ah,64
    	jmp ret64
adun32:
    	add ah,32
    	jmp ret32
adun16:
    	add ah,16
    	jmp ret16
adun8:
    	add ah,8
    	jmp ret8
adun4:
    	add ah,4
    	jmp ret4
adun2:
    	add ah,2
    	jmp ret2
adun1:
    	add ah,1
    	jmp returnconversion
;=========================================================================================================
; FUNCTIE DE INSERARE IN EDI A CORESPONDENTULUI BINAR A LITEREI "A" -> "00000000" "C" -> "00000010" etc.
insereaza:
    	push ebp
    	mov ebp,esp
    	mov edi, [ebp+8]
    	mov BL, [ebp+12]
    	cmp BL, 'A'
    	je A
    	jmp nextB
A:
    	mov AL, '0'
    	stosb
    	stosb
    	stosb
    	stosb
    	stosb
    	jmp exitfunction
    
nextB:    
    	cmp BL, 'B'
    	je B
    	jmp nextC
B:
    	mov AL, '0'
    	stosb
    	stosb
    	stosb
    	stosb
    	mov AL, '1'
    	stosb
    	jmp exitfunction

nextC:        
    	cmp BL, 'C'
    	je C
    	jmp nextD
C:
    	mov AL, '0'
    	stosb
    	stosb
    	stosb
    	mov AL, '1'
    	stosb
    	mov AL, '0'
    	stosb
    	jmp exitfunction

nextD:        
    	cmp BL, 'D'
    	je D
    	jmp nextE
D:
   	; mov byte [edi], "00011"
    	mov AL, '0'
    	stosb
    	stosb
    	stosb
    	mov AL, '1'
    	stosb
    	stosb
    	jmp exitfunction

nextE:        
    	cmp BL, 'E'
    	je E
    	jmp nextF
E:
   	; mov byte [edi], "00100"
    	mov AL, '0'
    	stosb
    	stosb
    	mov AL, '1'
    	stosb
    	mov AL, '0'
    	stosb
    	stosb
    	jmp exitfunction
 
nextF:       
    	cmp BL, 'F'
    	je F
    	jmp nextG
F:
   	; mov byte [edi], "00101"
    	mov AL, '0'
    	stosb
    	stosb
    	mov AL, '1'
    	stosb
    	mov AL, '0'
    	stosb
    	mov AL, '1'
    	stosb
    	jmp exitfunction
   
nextG:     
    	cmp BL, 'G'
    	je G
    	jmp nextH
G:
   	; mov byte [edi], "00110"
    	mov AL, '0'
    	stosb
    	stosb
    	mov AL, '1'
    	stosb
    	stosb
    	mov AL, '0'
    	stosb
    	jmp exitfunction
    
nextH:    
    	cmp BL, 'H'
    	je H
    	jmp nextI
H:
   	; mov byte [edi], "00111"
    	mov AL, '0'
    	stosb
    	stosb
    	mov AL, '1'
    	stosb
    	stosb
    	stosb
    	jmp exitfunction
    
nextI:        
    	cmp BL, 'I'
    	je I
    	jmp nextJ
I:
  	;  mov byte [edi], "01000"
    	mov AL, '0'
    	stosb
    	mov AL, '1'
    	stosb
    	mov AL, '0'
    	stosb
    	stosb
    	stosb
    	jmp exitfunction

nextJ:   
    	cmp BL, 'J'
    	je J
    	jmp nextK
J:
   	; mov byte [edi], "01001"
   	 mov AL, '0'
    	stosb
    	mov AL, '1'
    	stosb
    	mov AL, '0'
    	stosb
    	stosb
    	mov AL, '1'
    	stosb
    	jmp exitfunction
 
nextK:       
    	cmp BL, 'K'
    	je K
    	jmp nextL
K:
   	; mov byte [edi], "01010"
   	 mov AL, '0'
    	stosb
    	mov AL, '1'
    	stosb
    	mov AL, '0'
    	stosb
    	mov AL, '1'
    	stosb
    	mov AL, '0'
    	stosb
    	jmp exitfunction

nextL:    
    	cmp BL, 'L'
    	je L
    	jmp nextM
L:
   	; mov byte [edi], "01011"
    	mov AL, '0'
    	stosb
    	mov AL, '1'
    	stosb
    	mov AL, '0'
    	stosb
    	mov AL, '1'
    	stosb
    	stosb
    	jmp exitfunction

nextM:    
    	cmp BL, 'M'
    	je M
    	jmp nextN
M:
   	; mov byte [edi], "01100"
    	mov AL, '0'
    	stosb
    	mov AL, '1'
    	stosb
    	stosb
    	mov AL, '0'
    	stosb
    	stosb 
    	jmp exitfunction

nextN:    
    	cmp BL, 'N'
    	je N
    	jmp nextO
N:
   	; mov byte [edi], "01101"
    	mov AL, '0'
    	stosb
    	mov AL, '1'
    	stosb
    	stosb
    	mov AL, '0'
    	stosb
    	mov AL, '1'
    	stosb
    	jmp exitfunction

nextO:
    	cmp BL, 'O'
    	je O
    	jmp nextP
O:
   	; mov byte [edi], "01110"
   	 mov AL, '0'
   	 stosb
   	 mov AL, '1'
   	 stosb
    	stosb
   	 stosb
   	 mov AL, '0'
   	 stosb
   	 jmp exitfunction

nextP:
   	 cmp BL, 'P'
    	je P
    	jmp nextQ
P:
   	; mov byte [edi], "01111"
    	mov AL, '0'
   	 stosb
    	mov AL, '1'
    	stosb
    	stosb
   	 stosb
    	stosb   
    	jmp exitfunction
  
nextQ:     
    	cmp BL, 'Q'
    	je Q
   	 jmp nextR
Q:
  	 ; mov byte [edi], "10000"
   	 mov AL, '1'
   	 stosb
   	 mov AL, '0'
   	 stosb
  	 stosb
  	 stosb
  	 stosb
   	 jmp exitfunction
	
nextR:
    	cmp BL, 'R'
    	je R
    	jmp nextS
R:
   	; mov byte [edi], "10001"
   	mov AL, '1'
   	stosb
    	mov AL, '0'
    	stosb
    	stosb
    	stosb
    	mov AL, '1'
    	stosb
    	jmp exitfunction

nextS:    
    	cmp BL, 'S'
    	je S
    	jmp nextT
S:
   	; mov byte [edi], "10010"
    	mov AL, '1'
    	stosb
    	mov AL, '0'
    	stosb
    	stosb
    	mov AL, '1'
    	stosb
    	mov AL, '0'
    	stosb
    	jmp exitfunction

nextT: 
    	cmp BL, 'T'
    	je T
    	jmp nextU
T:
   	; mov byte [edi], "10011"
   	mov AL, '1'
    	stosb
    	mov AL, '0'
    	stosb
    	stosb
    	mov AL, '1'
    	stosb
    	stosb
    	jmp exitfunction

nextU:        
    	cmp BL, 'U'
    	je U
    	jmp nextV
U:
   	; mov byte [edi], "10100"
    	mov AL, '1'
    	stosb
    	mov AL, '0'
    	stosb
    	mov AL, '1'
    	stosb
    	mov AL, '0'
    	stosb
    	stosb
    	jmp exitfunction
 
nextV:   
    	cmp BL, 'V'
    	je V
    	jmp nextW
V:
   	; mov byte [edi], "10101"
    	mov AL, '1'
    	stosb
    	mov AL, '0'
    	stosb
    	mov AL, '1'
    	stosb
    	mov AL, '0'
    	stosb
    	mov AL, '1'
    	stosb
    	jmp exitfunction

nextW:        
    	cmp BL, 'W'
    	je W
    	jmp nextX
W:
   	; mov byte [edi], "10110"
    	mov AL, '1'
    	stosb
    	mov AL, '0'
    	stosb
    	mov AL, '1'
    	stosb
    	stosb
    	mov AL, '0'
    	stosb
    	jmp exitfunction

nextX:    
    	cmp BL, 'X'
    	je X
    	jmp nextY
X:
   	; mov byte [edi], "10111"
    	mov AL, '1'
    	stosb
    	mov AL, '0'
    	stosb
    	mov AL, '1'
    	stosb
    	stosb
    	stosb
    	jmp exitfunction

nextY:    
    	cmp BL, 'Y'
    	je Y
    	jmp nextZ
Y:
   	; mov byte [edi], "11000"
    	mov AL, '1'
    	stosb
    	stosb
    	mov AL, '0'
    	stosb
   	stosb
    	stosb
    	jmp exitfunction
 
nextZ:       
    	cmp BL, 'Z'
    	je Z
    	jmp nextcif2
Z:
  	;  mov byte [edi], "11001"
    	mov AL, '1'
    	stosb
    	stosb
    	mov AL, '0'
    	stosb
    	stosb
    	mov AL, '1'
    	stosb
    	jmp exitfunction
  
nextcif2:      
    	cmp BL, '2'
    	je cif2
    	jmp nextcif3
cif2:
  	;  mov byte [edi], "11010"
    	mov AL, '1'
    	stosb
    	stosb
    	mov AL, '0'
    	stosb
    	mov AL, '1'
    	stosb
    	mov AL, '0'
    	stosb
    	jmp exitfunction

nextcif3:        
    	cmp BL, '3'
    	je cif3
    	jmp nextcif4
cif3:
  	;  mov byte [edi], "11011"
    	mov AL, '1'
    	stosb
    	stosb
    	mov AL, '0'
    	stosb
    	mov AL, '1'
    	stosb
    	stosb
    	jmp exitfunction
    
nextcif4:
    	cmp BL, '4'
    	je cif4
    	jmp nextcif5
cif4:
   	; mov byte [edi], "11100"
    	mov AL, '1'
    	stosb
    	stosb
    	stosb
    	mov AL, '0'
    	stosb
    	stosb
    	jmp exitfunction
    
nextcif5:
    	cmp BL, '5'
    	je cif5
    	jmp nextcif6
cif5:
   	; mov byte [edi], "11101"
    	mov AL, '1'
    	stosb
    	stosb
    	stosb
    	mov AL, '0'
    	stosb
    	mov AL, '1'
    	stosb
    	jmp exitfunction
    
nextcif6:    
    	cmp BL, '6'
    	je cif6
    	jmp nextcif7
cif6:
   	; mov byte [edi], "11110"
    	mov AL, '1'
    	stosb
    	stosb
    	stosb
    	stosb
    	mov AL, '0'
    	stosb
    	jmp exitfunction

nextcif7:        
    	cmp BL, '7'
    	je cif7
    	jmp exitfunction
cif7:
  	; mov byte [edi], "11111"
    	mov AL, '1'
    	stosb
    	stosb
    	stosb
    	stosb
    	stosb
    	jmp exitfunction 
exitfunction:
    	leave
    	ret

;======================================== TASK 4  ==================================================

base32decode:
	; TODO TASK 4
    	push ebp
    	mov ebp,esp 
    	mov esi, [ebp+8] ; esi - string 
    	mov ecx, edi
    	xor edx,edx 
loop4:   
    	mov bl, byte [esi]
    	cmp ebx, 0x00
    	je exit4
    	cmp ebx, '=' ; daca este separator base32, trec peste
    	je continue4
    	inc edx ; incrementez numarul de litere convertite in valoarea binara
   	push ebx
    	push edi
    	call insereaza
    	add esp,8
continue4:
    	inc esi
    	jmp loop4
exit4:
    	mov al, 0x00
    	stosb
    	mov eax, 5
    	mul edx ; in edx am numarul de litere convertite in perechi de 5 biti
    	; in eax o sa am numarul total de biti = 5 * numarul de caractere
    	mov bl,8
    	div bl
    	; impart la 8 numarul de biti si retin doar catul.
    	; catul imi va spune cate caractere are sirul meu final (cate perechi de 8 biti pot realiza)
    	; urmeaza etapa de convertire a sirului de biti de 0 si 1 din edi in caractere
    	mov esi, ecx 
    	mov ecx, edi 
    	; esi -> 0101010.....0101 
    	xor edx,edx
bucla4:
    	cmp al, 0
    	je termin4     
    	jmp stringtobinary ; convertesc stringul in valoarea binara corespunzatoare
returnconversion:
    	; AH are numarul convertit
    	mov byte [ecx+edx], AH
    	add esi, 8
    	inc edx
    	dec al
    	jmp bucla4
termin4:
    	sub byte [ecx], 32
    	sub byte [ecx+34], 32
    	mov byte [ecx+edx], 0x00   
    	leave
    	ret

;======================================== TASK 5 AUX ===============================================
; functie care gaseste cheia de un byte care a fost folosita sa se codifice cuvantul force
findkey:
    	push ebp
    	mov ebp,esp
    	mov esi, [ebp+8] ; esi - string  
	xor eax,eax
	xor ebx,ebx
nextkey:   
    	mov bl, byte [esi]
    	cmp bl, 0x00
    	je exitkey
    	mov al, 'f'
    	xor al, bl
    	; in AL am presupusa cheie buna
    	mov bl, byte [esi+1]
    	xor bl,al
    	cmp bl, 'o'
    	jne trynext
    	mov bl, byte [esi+2]
    	xor bl,al
    	cmp bl, 'r'
    	jne trynext
	mov bl, byte [esi+3]
    	xor bl,al
    	cmp bl, 'c'
    	jne trynext
    	mov bl, byte [esi+4]
    	xor bl,al
    	cmp bl, 'e'
    	jne trynext
	; in AL se afla cheia buna
	jmp exitkey
trynext:    
    	inc esi
    	jmp nextkey
exitkey:
    	leave
	ret

;======================================== TASK 5 ==================================================
bruteforce_singlebyte_xor: ; asemanator cu prima functie, face xor intre cheie si string
    	push ebp
    	mov ebp,esp
    	mov bl, [ebp+8] ; cheia
    	mov edi, [ebp+12]; stringul
    	mov ecx, edi
loop5:
    	mov bh, byte [edi]
    	cmp bh,0x00
    	je exit5
    	xor bh, bl
    	mov byte [edi], bh
    	inc edi
    	jmp loop5
exit5:    
    	leave
	ret
;======================================== TASK 6 ===================================================
decode_vigenere:
	; TODO TASK 6
    	push ebp
    	mov ebp,esp  
    	mov edi, [ebp+8] ; edi - cheia
    	mov esi, [ebp+12]; esi - stringul
    	mov ecx, edi
    	xor edx,edx
    	xor ebx,ebx
    	mov eax,0
loop6:   
    	cmp [esi+edx],byte  0x0 ; verific daca am ajuns cu cheia pe null
    	je nullkey
returnkey:
    	mov bl, byte [edi]
    	cmp bl, 0x00
    	je exit6
    	cmp bl, 'a'
    	jl continue6
    	cmp bl, 'z'
    	jg continue6
    	; Ajung aici daca in BL se afla o litera
    	mov bh, byte [esi+edx]
    	sub bh, 'a'
    	sub bl, bh
    	cmp bl, 'a'
    	jge nextone
    	add bl, 26
nextone:
    	mov byte [edi], bl
    	inc edx
    	inc edi
    	jmp loop6   
continue6:
    	inc edi
    	jmp loop6 
exit6:
   	 leave
   	 ret    
nullkey: ; daca am ajuns la null, reiau cheia de la primul byte
    	xor edx,edx
    	jmp returnkey 
	
;================================================================================================
main:
	push ebp
	mov ebp, esp
	sub esp, 2300

	; test argc
	mov eax, [ebp + 8]
	cmp eax, 2
	jne exit_bad_arg

	; get task no
	mov ebx, [ebp + 12]
	mov eax, [ebx + 4]
	xor ebx, ebx
	mov bl, [eax]
	sub ebx, '0'
	push ebx

	; verify if task no is in range
	cmp ebx, 1
	jb exit_bad_arg
	cmp ebx, 6
	ja exit_bad_arg

	; create the filename
	lea ecx, [filename + 7]
	add bl, '0'
	mov byte [ecx], bl

	; fd = open("./input{i}.dat", O_RDONLY):
	mov eax, 5
	mov ebx, filename
	xor ecx, ecx
	xor edx, edx
	int 0x80
	cmp eax, 0
	jl exit_no_input

	; read(fd, ebp - 2300, inputlen):
	mov ebx, eax
	mov eax, 3
	lea ecx, [ebp-2300]
	mov edx, [inputlen]
	int 0x80
	cmp eax, 0
	jl exit_cannot_read

	; close(fd):
	mov eax, 6
	int 0x80

	; all input{i}.dat contents are now in ecx (address on stack)
	pop eax
	cmp eax, 1
	je task1
	cmp eax, 2
	je task2
	cmp eax, 3
	je task3
	cmp eax, 4
	je task4
	cmp eax, 5
	je task5
	cmp eax, 6
	je task6
	jmp task_done
;===============================================================================================
; functie care returneaza adresa de inceput a cheii
key_start:
	push ebp
	mov ebp, esp
	mov ecx, [ebp+8]	
	xor ebx,ebx
while:
    	mov bl, byte [ecx]
    	cmp bl, 0x00
    	je exitwhile
    	inc ecx
    	jmp while
exitwhile:
    	inc ecx
	leave
	ret
;================================================================================================
task1:
	; TASK 1: Simple XOR between two byte streams        
	push ecx ; push string
	
	push ecx
	call key_start
	add esp, 4

    	push ecx ; push key
    	call xor_strings
    	add esp,8	    	
	push ecx
	call puts                   
	add esp, 4
	jmp task_done

;===============================================================================================
task2:
	; TASK 2: Rolling XOR
	push ecx 
    	call rolling_xor
  	add esp,4  	    	                
	push ecx
	call puts
	add esp, 4
	jmp task_done

;================================================================================================
task3:
	; TASK 3: XORing strings represented as hex strings
	push ecx ; ecx = string
	
	push ecx
	call key_start
	add esp, 4

    	push ecx ; ecx = key
    	call xor_hex_strings                   
    	add esp, 8                    	
	push ecx
	call puts                   
	add esp, 4
	jmp task_done
;===================================================================================================
task4:
	; TASK 4: decoding a base32-encoded string
	push ecx
	call base32decode
	; TODO TASK 4: call the base32decode function
	
	push ecx
	call puts                    ;print resulting string
	pop ecx
	
	jmp task_done
;===================================================================================================
task5:
	; TASK 5: Find the single-byte key used in a XOR encoding

	push ecx ; ecx = string
	call findkey
	add esp, 4   
 	; in EAX voi avea cheia

	push ecx ; ecx = string
	push eax ; eax = key byte
	call bruteforce_singlebyte_xor
	add esp, 8

	push eax; salvez cheia
	push ecx                    ;print resulting string
	call puts
	add esp,4
	pop eax ; refac cheia
	
	push eax                    ;eax = key value
	push fmtstr
	call printf                 ;print key value
	add esp, 8

	jmp task_done
;===================================================================================================
task6:  ; TASK 6: decode Vignere cipher
	
	push ecx
	call strlen
	pop ecx
	add eax, ecx
	inc eax
	push eax ; eax = key
	push ecx ; ecx = string 
	call decode_vigenere
	pop ecx
	add esp, 4
	push ecx
	call puts
	add esp, 4

;===================================================================================================
task_done:
	xor eax, eax
	jmp exit

exit_bad_arg:
	mov ebx, [ebp + 12]
	mov ecx , [ebx]
	push ecx
	push usage
	call printf
	add esp, 8
	jmp exit

exit_no_input:
	push filename
	push error_no_file
	call printf
	add esp, 8
	jmp exit

exit_cannot_read:
	push filename
	push error_cannot_read
	call printf
	add esp, 8
	jmp exit

exit:
	mov esp, ebp
	pop ebp
	ret
