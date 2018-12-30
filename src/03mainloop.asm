;------------------------------------------
; メインループ
;------------------------------------------
mainloop:


mainloop_wait_vBlank:
    lda $2002
    bpl mainloop_wait_vBlank ; wait for vBlank
;   lda #$3
;   sta $4014

    jmp mainloop