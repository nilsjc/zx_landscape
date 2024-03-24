; Put your Z80 assembly code into code files
Start:
    .model Spectrum48
	.org #8000
MyLandscape db 1,2,4,8,1,1,1,1,2,2,2,2,4,4,4,4,8,8,8,4,1,2,4,8,1,2,4,8,2, 2,8,4,1,2,8,4,1,1,1,1,2,2,2,2,8,8,8,8,4,4,4,4,1,2,2,4,1,2,1,4,1,2,2,4
	;; load user defined graphics
	ld hl, AttrMemo
	ld de,22528
	ld (AttrMemo),de
	ld hl,udgs ; address of user-defined graphics data.
	ld(23675),hl 
	;; prepare for printing to screen
	ld a,2;	      ; upper screen
	call #1601    ; open the channel
	ld hl,MyLandscape ; HL points the the landscape array
	ld b,8 ; loop eight times (x axis)
Newline:
	push bc
	ld b,8
NextCh:
	push bc
	;;check 
	ld a, (hl)
	push hl
udga:
	bit 0,a
	jr z, udgb
	ld a, 144 ; UDG A 65=normala A
	ld hl, 4
	ld (AddToAttr),hl
udgb:
	bit 1,a
	jr z, udgc
	ld a, 145 ; UDG B
	ld hl, 48
	ld (AddToAttr),hl
udgc:
	bit 2,a
	jr z, udgd
	ld a, 146 ; UDG C
	ld hl, 3
	ld (AddToAttr),hl
udgd:
	bit 3,a
	jr z, noudg
	ld a, 148; UDG E	
	ld hl, 22
	ld (AddToAttr),hl
noudg:
	rst 16 ; write to output
	pop hl
	inc hl

	push hl
	ld hl,(AttrMemo)
	ld a,(AddToAttr)
	ld (hl),a
	inc hl
	ld (AttrMemo),hl
	pop hl

	pop bc
	djnz NextCh     ; next loop
	ld a, 13 ;;skriv ut enter för radbryt (newline)
	rst 16 ;; utför kommandot
	;
	; newline for attribute map as well
	push hl ; NOTE never push and pop DE - it corrupts the screen(?)
	ld hl,(AttrMemo)
	ld de,24
	add hl,de
	ld (AttrMemo),hl
	pop hl
	;
	pop bc
	djnz Newline

Blurp:
ret
jp Blurp

Loop:
;; keyboard scanning
	ld a,#FE
	IN a,(#FE)
	bit 1,a
	jr z, KlickZ
	bit 2,a
	jr z, KlickX
	jp loop

KlickZ:
ret
KlickX:
; copy screen memory code
ld hl,16384
	ld de,18432
	ld bc,2040
	ldir
; copy screen memory end
endhere
jp endhere
udgs db 24,60,90,52,106,211,153,16, 0,32,0,2,72,0,4,0, 0,82,171,94,173,86,43,127, 60,60,24,255,24,60,102,195, 255,64,64,64,255,8,8,8
udgend db $
AttrMemo dw 22528 ; 88,0
AddToAttr db 0