;------------------------------------------
; メインループ
;------------------------------------------
mainloop:
    ; ジョイパットの入力値の取得開始
    lda #$01
    sta $4016
    lda #$00
    sta $4016

    ; カウンタをインクリメント
    ldx v_counter
    inx
    stx v_counter

    ; 16フレームに1回敵を出す
    txa
    and #$0f
    bne mainloop_addNewEnemy_end
    jsr sub_newEnemy
mainloop_addNewEnemy_end:


    ; 波座標を求める
    lda v_counter
    and #$1f
    tax
    lda wave_table, x
    sta v_wave

    ; 粉塵のアニメーション
mainloop_dust:
    lda v_dust
    beq mainloop_shot
    clc
    adc #$01
    and #%00011111
    sta v_dust
    beq mainloop_dustErase
    and #%00011000
    ror
    adc #$10
    sta sp_dustT
    adc #$02
    sta sp_dustT + 4
    bne mainloop_shot
mainloop_dustErase:
    sta sp_dustT
    sta sp_dustT + 4

    ; プレイヤのショットを動かす
mainloop_shot:
    lda v_shotF
    beq mainloop_movePlayer
    lda v_shotY
    clc
    adc #$04
    cmp #$d8
    bcs mainloop_eraseShot
    sta v_shotY
    sta sp_shotY
    bcc mainloop_movePlayer
mainloop_eraseShot:
    lda #$00
    sta v_shotF
    sta sp_shotT
    lda #$01
    sta v_dust
    lda v_shotX
    clc
    sbc #$04
    sta sp_dustX
    adc #$08
    sta sp_dustX + 4
    lda #$d0
    sta sp_dustY
    sta sp_dustY + 4
    lda #$10
    sta sp_dustT
    lda #$12
    sta sp_dustT + 4
    ;     VHP---CC
    lda #%00000001
    sta sp_dustA
    sta sp_dustA + 4
    ; play SE1 (ノイズを使う)
    ;     --cevvvv (c=再生時間カウンタ, e=effect, v=volume)
    lda #%00011111
    sta $400C
    ;     r---ssss (r=乱数種別, s=サンプリングレート)
    lda #%00001101
    sta $400E
    ;     ttttt--- (t=再生時間)
    lda #%11111000
    sta $400F

    ; ゲームオーバー中でなければプレイヤの移動処理を実行
mainloop_movePlayer:
    lda v_gameOver
    bne mainloop_skipPlayer
    jsr sub_movePlayer
mainloop_skipPlayer:

    ; 敵を動かす
    jsr sub_moveEnemy

mainloop_wait_vBlank:
    lda $2002
    bpl mainloop_wait_vBlank ; wait for vBlank
    lda #$3
    sta $4014

    jmp mainloop