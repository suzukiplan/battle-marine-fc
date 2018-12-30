;------------------------------------------
; メインループ
;------------------------------------------
mainloop:
    ldx v_counter
    inx
    stx v_counter

    ; プレイヤをプカつかせる
    lda v_counter
    and #$1f
    tax
    lda playerY_table, x
    sta v_playerY
    sta sp_playerY
    sta sp_playerY + 4
    sta sp_playerY + 8

mainloop_wait_vBlank:
    lda $2002
    bpl mainloop_wait_vBlank ; wait for vBlank
    lda #$3
    sta $4014

    jmp mainloop