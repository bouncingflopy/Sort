IDEAL
MODEL small
STACK 100h
DATASEG

point dw 4 ; the location of the first element in the list (that still needs sorting)
len dw 8 ; the length of the list (that still needs sorting)
list dw -7, 5, 6, 10, 3487, 1233, -2832, 2883 ; the list to be sorted by the program

CODESEG

;---------------------------------------------------------------------------------
; FUNCTION	finds the smallest element in a given list
; INPUT		length of the given list, location of first element in the given list
; OUTPUT	location of smallest element in the given list
proc minimum
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	
	; set the starting maximum value, so that all numbers will be less than it
	mov ax, 07FFFh
	push ax
	
	mov cx, [bp+6]
	rol cx, 1
	min_loop:
		; get a yet-to-be-checked number from the given list
		mov bx, [bp+4]
		add bx, cx
		mov dx, 0
		mov dx, [bx-2] ; dl is used as the number is a byte, rather than a word
		
		; check if current number is smaller than the smallest yet checked number
		cmp ax, dx
		jl not_min
		
		; if current number is smaller than the smallest yet checked number
		mov ax, dx
		pop dx
		sub bx, 2
		push bx
		
		not_min:
		sub cx, 2
		cmp cx, 0
		jnz min_loop
	
	pop ax
	mov [bp+6], ax
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret
endp minimum
;---------------------------------------------------------------------------------

;---------------------------------------------------------------------------------
; FUNCTION	swaps two elements in data segment
; INPUT		two locations of elements which should be swapped
; OUTPUT	NONE
proc swap
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	
	; take out the values in the two locations which need to be swapped
	mov bx, [bp+6]
	mov ax, [bx]
	mov bx, [bp+4]
	mov cx, [bx]
	
	; put the numbers extracted from memory in, in swapped order
	mov [bx], ax
	mov bx, [bp+6]
	mov [bx], cx
	
	pop cx
	pop bx
	pop ax
	pop bp
	ret 4
endp swap
;---------------------------------------------------------------------------------

start:
	mov ax, @data
	mov ds, ax
	
	mov cx, [len]
	lop:
		mov bx, offset len
		push [bx]
		mov bx, offset point
		push [bx]
		call minimum
		call swap
		
		add [point], 2
		dec [len]
		dec cx
		cmp cx, 1
		jne lop
	
exit:
	mov ax, 4c00h
	int 21h
END start ; negative numbers


