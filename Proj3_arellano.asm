TITLE Project 3 - Data Validation, Looping, and Constants     (Proj3_arellano.asm)

; Author: Osbaldo Arellano
; Last Modified:	10/29/2022
; OSU email address: arellano@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number:     3            Due Date: 10/30/2022 
; Description:	Introduces the program and greets the user.
;				Asks the user for their name. 
;				Repeatedly asks for user input in ranges [-200, -100] or [-5-, -1] until a positive number is given by the user. 
;				If input is not within either range, then the user is asked for another number. Invalid number is thrown away. 
;				If no user input is detected, then an error message is displayed.
;				Valid inputs are checked against current min and max values and set accordingly. 
;				Once a positive number is detected, calculations are done to get total (valid input) sum, rounded average, and decimal average. 
;				The total valid input count, minimum, maximum, total sum, rounded average, and decimal average are displayed. 
;				Finally, a farewell message is displayed

INCLUDE Irvine32.inc

UPPER1 = -100
LOWER1 = -200
UPPER2 = -1
LOWER2 = -50

.data
introduction 		BYTE	"Hello and welcome to the Integer Accumulator by Osbaldo Arellano.",13,10,0
description		BYTE	"The program repeatadly asks for negative input between specifed bounds until a positive number is detetced. Then the program will",13,10,0
description2		BYTE	"calculate minumum, maxium, rounded and unrounded average values, total (valid) sum, and total number of valid inputs.",13,10,0 
askName		        BYTE	"What's your name? ",0
greeting		BYTE	"Hello there, ",0
instruction		BYTE	"Please enter numbers in [-200, -100] or [-50, -1]. ",0
instruction2		BYTE	"Enter a non-negative number when you are finished, and input stats will be shown.",13,10,0
prompt			BYTE	"Enter a number: ",0
invalid			BYTE	"Invalid input! Number is not within ranges. ", 13,10,0
counterMssg		BYTE	"You entered ",0
counterMssg2		BYTE	" valid numbers. ",0
totalMssg		BYTE	"Your sum of valid numbers: ",0
maxIs			BYTE	"Max is: ",0
minIs			BYTE	"Min is: ",0
avgMssg		        BYTE	"The rounded average is: ",0
remainderMssg		BYTE	"Remainder: ",0
emptyInput		BYTE	"You did not enter any numbers.",13,10,0
decimalMssg		BYTE	"The decimal average is: ",0
point			BYTE	".",0
goodbye			BYTE	"Thank you for playing, ",0
exclamation		BYTE	"!",0

username		BYTE    33 DUP(0)				; User name is stored in an array 
input			SDWORD	?
max		        DWORD	0
min				DWORD	0
counter			DWORD	0
total			SDWORD	0
avg				SDWORD	0
remainder		SDWORD	0
tenMultiple		DWORD	100					; Used to multiuply counter to get a whole number to display after a decimal point 
unroundedAvg	DWORD	0					; Used to display decimal average 

.code
main PROC

; --------------------------
; Displays the program title and author's name. 
; Asks the user for their name, which is then stored in an array.
; Greets the user by their name and displays instructions. 
; Instructions: Enter number in range [-200,-100] or [-50,-1]. When done, 
; enter a positive number to display calculations. 
;--------------------------
_introduction:
	; Introduces the program
	mov     edx, OFFSET introduction			; Introduce the program 
	call	WriteString
	mov		edx, OFFSET description
	call	WriteString
	mov		edx, OFFSET description2
	call	WriteString
	mov		edx, OFFSET askName
	call	WriteString
	mov     edx, OFFSET username				; Read username
	mov     ecx, 32
    call    ReadString

_greeting:
	; Greet the user
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

; --------------------------
; Gets user input  
;
; _input is called every time a number in [-200,-100] or [-50,-1] is given or an invalid number is given. 
; Intially checks if the input is positive.
; Once a positive number is detected, program performs calculations based on all the valid inputs. 
;--------------------------
_input:
	; Get user input
	mov		edx, OFFSET prompt
	call	WriteString
	call	ReadInt
	cmp		eax, 0				; Initial check if user entered a positive number
	jge		_displayCounter			; Display total number of valid inputs if user input >= 0

_checkUpper:
	cmp		eax, UPPER1			; Checking if user input is within the first upper bound
	jg		_checkLower2		; If not inside first upper bound, check second upper bound
	jmp		_checkLower			; Else is inside the upper bound, now check lower bound 

_checkLower2:
	cmp		eax, LOWER2
	jge		_valid				; Number must be inside [-50, -1] bound 
	jmp		_invalid			; Number is not inside any bound. Invalid number. 

_checkLower:
	cmp		eax, LOWER1			; Checking if user input is within upper bound. 
	jge		_valid				; If upper bound is less than input, then we have a valid number

_invalid:
	; Displays error and prompts the user for more input 
	mov		edx, OFFSET invalid
	call	WriteString
	call	_input
	jmp		_invalid

; --------------------------
; Number is within bound  [-200,-100] or [-50,-1].
;
; Increments the counter by 1 and adds the current valid number to the total running count. 
; Min and max global variables are intially set to 0. 
; The program checks if min/max equal zero to determine if first valid input is current number. 
;	- If first valid input, set min and max to current number
;--------------------------
_valid:
	; Number is within bounds
	add		counter, 1			
	add		total, eax			; Add to running total 
	cmp		max, 0				 
	je		_intialize			; If zero, then we know this is the first valid input. Initialize.
	cmp		min, 0				
	je		_intialize			; If zero, then we know this is the first valid input. Initialize.
	jmp		_checkMax			; Else, do max checking

; --------------------------
; Min and max global variables are intially set to 0. 
; The program checks if min/max equal zero to determine if first valid input is given. 
; The current valid number eax is checked against current min and max, and set accordingly. 
; Once done, user is promted for new input. 
;--------------------------
_intialize:
	; Min/max is always initialized to first valid input
	mov		max, eax			
	mov		min, eax

_checkMax:
	cmp		max, eax
	jle		_setMax
	jmp		_checkMin			; If not a max, then check if min

_checkMin:
	cmp		min, eax
	jge		_setMin
	jmp		_input				; Not any min or max. Done checking for min/max, jump to get more user input

_setMax:
	mov		max, eax
	jmp		_input

_setMin:
	mov		min, eax
	jmp		_input

; --------------------------
; Displays result of calculations when an input >= 0 is detetced.
;	- Counter, minimum, maximum and total sum are displayed. 
;--------------------------
_displayCounter:
	cmp		counter, 0
	je		_displayNoInput
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

; --------------------------
; Calculates and displays rounded average.  
;
; Calculation to get remainder into a decimal: 
;	-- (total sum / counter)  remainder is multipled by 100 to get .01 place when dividing by counter. 
;   -- If result is >= 50, then we know we need to round.

; The decimal point average is displyed for extra credit. 
;--------------------------
_calculateAvg:
	mov		eax, total
	mov		ebx, counter
	cdq
	idiv	ebx							 
	mov		avg, eax					; stores quotient in eax
	mov		unroundedAvg, eax			; Save avg before rounding for later (extra credit)
	mov		remainder, edx				; remainder stored in edx	
	neg		remainder					; Dont care about signed calculations anymore

	mov		eax, remainder			
	mul		tenMultiple					; Multiplying by 100 will give us a whole number in eax. Can use to show decimal spot up to .01
	cdq
	div		counter						; ((Remainder*100) / counter) gives us a whole number in eax that we can use to check if we need rounding  
	mov		remainder, eax
	cmp		remainder, 50				; If >= 50 then we need to round 
	jge		_round
	jmp		_displayAvg

_round:
	dec		avg	
	
_displayAvg:
	mov		edx, OFFSET avgMssg
	call	WriteString
	mov		eax, avg
	call	WriteInt
	call	CrLf
	
; --------------------------
; Extra credit
; --------------------------
_displayDecimal:
	mov		edx, OFFSET decimalMssg
	call	WriteString
	mov		eax, unroundedAvg	
	call	WriteInt
	mov		edx, OFFSET point			; char '.'
	call	WriteString
	mov		eax, remainder
	call	WriteDec
	call	CrLf
	jmp		_goodbye

; --------------------------
; The first input that was deteced was a number >= 0. 
; Which means that there are zero numbers to do calculations on. 
; Displays an error message. 
; --------------------------
_displayNoInput:
	; Got no input from user. First number was positive. 
	mov		edx, OFFSET emptyInput
	call	WriteString
	Invoke	ExitProcess,0	

_goodbye:
	; Display goodbye message with the users name
	mov		edx, OFFSET goodbye
	call	WriteString
	mov		edx, OFFSET username
	call	WriteString
	mov		edx, OFFSET exclamation
	call	WriteString
	call	CrLf
	Invoke	ExitProcess,0	

main ENDP

END main
