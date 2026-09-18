; fillRect. create_tbl — в text_util.c.

SECTION code_user

PUBLIC _fillRect
_fillRect:
extern _fr_a
extern _fr_w
extern _fr_h
extern _fr_c
extern _radio86rkVideoBpl
	push b
	lda _radio86rkVideoBpl
	mov c, a
	mvi b, 0
	lhld _fr_a
	lda _fr_h
	mov d, a
	lda _fr_c
	mov e, a
fillRect_l1:
	lda _fr_w
	push h
fillRect_l0:
	mov m, e
	inx h
	dcr a
	jnz fillRect_l0
	pop h
	dad b
	dcr d
	jnz fillRect_l1
	pop b
	ret
