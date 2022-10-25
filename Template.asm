TITLE Program Template     (template.asm)

; Author: 
; Last Modified:
; OSU email address: ONID_ID@oregonstate.edu
; Course number/section:   CS271 Section ???
; Project Number:                 Due Date:
; Description: This file is provided as a template from which you may work
;              when developing assembly projects in CS271.

INCLUDE Irvine32.inc

UPPER1 = -100
LOWER1 = -200

UPPER2 = -1
LOWER2 = -50

.data
introduction	BYTE	"Hello and welcome to the Integer Accumulator by Osbaldo Arellano.",13,10,0
description		BYTE	"The user will input negative numbers between specifed bounds. Then the program will",13,10,0
description2	BYTE	"calculate minumum, maxium, and average values, total sum, and total number of valid inputs.",13,10,0 
askName			BYTE	"What's your name? ",0
greeting		BYTE	"Hello there, ",0
instruction		BYTE	"Please enter numbers in [-200, -100] or [-50, -1]. ",0
instruction2	BYTE	"Enter a non-negative number when you are finished, and input stats will be shown.",13,10,0
prompt			BYTE	"Enter a number: ",0
invalid			BYTE	"Invalid input! Number is not within ranges. ", 13,10,0
counterMssg		BYTE	"You entered ",0
counterMssg2	BYTE	" valid numbers. ",0
totalMssg		BYTE	"Your sum of valid numbers: ",0
maxIs			BYTE	"Max is: ",0
minIs			BYTE	"Min is: ",0
avgMssg			BYTE	"The rounded average is: ",0
goodbye			BYTE	"Thank you for playing! ",0
goodbye2		BYTE	"Farewell, ",0

remainderMssg	BYTE	"Remainder: ",0


username		BYTE    33 DUP(0) 
input			SDWORD	?
max				DWORD	0
min				DWORD	0
counter			DWORD	0
total			SDWORD	0
avg				SDWORD	0
remainder		SDWORD	0
mulRemainder	SDWORD	0	

.code
main PROC
; Introduce the program 
; Get username
_introduction:
	mov		edx, OFFSET introduction
	call	WriteString
	mov		edx, OFFSET description
	call	WriteString
	mov		edx, OFFSET description2
	call	WriteString
	mov		edx, OFFSET askName
	call	WriteString
	mov     edx, OFFSET username
    mov     ecx, 32
    call    ReadString

_greeting:
; Greet User
	mov		edx, OFFSET greeting
	call	WriteString
	mov		edx, OFFSET username
	call	WriteString
	call	CrLf

_instructions:
; Display game rules
	mov		edx, OFFSET instruction
	call	WriteString
	mov		edx, OFFSET instruction2
	call	WriteString

_input:
	mov		edx, OFFSET prompt
	call	WriteString
	call	ReadInt
	cmp		eax, 0				; Initial check if user entered a positive number
	jge		_displayCounter		; Display total number of valid inputs 

_checkUpper:
	cmp		eax, UPPER1			; Checking if user input is within the first upper bound
	jg		_checkLower2		; If not inside first upper bound, check second upper bound
	jmp		_checkLower			; Is inside the upper bound, now check lower bound 

_checkLower2:
	cmp		eax, LOWER2
	jge		_valid				; Number must be inside [-50, -1] bound 
	jmp		_invalid			; Number is not inside any bound. 

_checkLower:
	cmp		eax, LOWER1			; Checking if user input is within upper bound (constant)
	jge		_valid				; If upper bound is less than input 

_invalid:
	mov		edx, OFFSET invalid
	call	WriteString
	call	_input
	jmp		_invalid

_valid:
; Number is within bounds
; Do calculations
; Max and min are initalized to zero. Check if zero. If zero,  then load number into it without checking 
; Increment valid input counter
; Add to total
	add		counter, 1
	add		total, eax
	cmp		max, 0
	je		_intialize 
	cmp		min, 0
	je		_intialize
	jmp		_checkMax

_intialize:
	mov		max, eax
	mov		min, eax

_checkMax:
	cmp		max, eax
	jle		_setMax
	jmp		_checkMin

_checkMin:
	cmp		min, eax
	jge		_setMin
	jmp		_input

_setMax:
	mov		max, eax
	jmp		_input

_setMin:
	mov		min, eax
	jmp		_input

_displayCounter:
	mov		edx, OFFSET counterMssg
	call	WriteString
	mov		eax, counter
	call	WriteDec
	mov		edx, OFFSET counterMssg2
	call	WriteString
	call	CrLf


_displayMinMax:
	mov		edx, OFFSET maxIs
	call	WriteString
	mov		eax, max
	call	WriteInt
	call	CrLf
	mov		edx, OFFSET minIs
	call	WriteString
	mov		eax, min
	call	WriteInt
	call	CrLf

_displaySum:
	mov		edx, OFFSET totalMssg
	call	WriteString
	mov		eax, total
	call	WriteInt
	call	CrLf

_calculateAvg:
	mov		eax, total
	mov		ebx, counter
	cdq
	idiv	ebx							;stores quotient in eax 
	mov		avg, eax
	mov		remainder, edx				;remainder stored in edx
	neg		remainder
	mov		eax, remainder				
	mov		ebx, 10						; multiply remainder by 10
	mul		ebx						
	mov		remainder, eax				;store remainder times 10
	mov		eax, counter				;mult num_valid by 10
	mov		ebx, 10
	mul		ebx
	mov		remainder, eax				;store in tenxnm_val
	mov		edx, 0
	mov		ebx, 2
	div		ebx
	cmp		mulRemainder, eax
	jge		_round						;if remainder >= eax(hf_num_val), round avg up
	call	CrLf
	call	CrLf
	jmp		_displayAvg

_round:
	dec		avg	
	
_displayAvg:
	mov		edx, OFFSET avgMssg
	call	WriteString
	mov		eax, avg
	call	WriteInt
	call	CrLf


	

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
