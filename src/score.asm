;----------------------------------------------------------
; サブルーチン: スコアを加算+描画 (vBlank中にのみ実行できる)
; * xレジスタ: unused (このサブルーチン内では使わない)
; * yレジスタ: unused (このサブルーチン内では使わない)
; * aレジスタ: 計算用のワーク
;----------------------------------------------------------
sub_addScore10:
    ; 現在のスコアの数値型を計算
    lda v_sc
    clc
    adc #$01
    sta v_sc
    lda v_sc + 1
    adc #$00
    sta v_sc + 1
    lda v_sc + 2
    adc #$00
    sta v_sc + 2
    ; ハイスコア更新済みかチェック
    lda v_hi_update
    bne sub_addScore10_start ; 更新済みなので比較を省略して加算開始
    ; 数値型のハイスコアと比較1 (上位8bit)
    lda v_sc + 2
    cmp v_hi + 2
    bcc sub_addScore10_start ; ハイスコア未満なので更新していない
    bne sub_addScore10_detectHighScore ; ハイスコアより大きいので更新
    ; 数値型のハイスコアと比較2 (中位8bit)
    lda v_sc + 1
    cmp v_hi + 1
    bcc sub_addScore10_start ; ハイスコア未満なので更新していない
    bne sub_addScore10_detectHighScore ; ハイスコアより大きいので更新
    ; 数値型のハイスコアと比較3 (下位8bit)
    lda v_sc
    cmp v_hi
    bcc sub_addScore10_start ; ハイスコア未満なので更新していない
    ; sc >= hi なので更新したものと見做す
sub_addScore10_detectHighScore:
    lda #$ff
    sta v_hi_update
sub_addScore10_start:
    lda v_sc10
    clc
    adc #$01
    cmp #$0a
    bcc sub_addScore10_display
    jsr sub_addScore100
    lda #$00
sub_addScore10_display:
    sta v_sc10
    lda #$20
    sta $2006
    lda #$2c
    sta $2006
    lda v_sc10
    clc
    adc #$30
    sta $2007
    ; 必要に応じてハイスコアの更新
    lda v_hi_update
    bne sub_addScore10_displayH
    rts
sub_addScore10_displayH:
    lda #$20
    sta $2006
    lda #$3b
    sta $2006
    lda v_sc10
    sta v_hi10
    clc
    adc #$30
    sta $2007
    ; ハイスコアの数値型を更新
    lda v_sc
    sta v_hi
    lda v_sc + 1
    sta v_hi + 1
    lda v_sc + 2
    sta v_hi + 2
    rts

sub_addScore100:
    lda v_sc100
    clc
    adc #$01
    cmp #$0a
    bcc sub_addScore100_display
    jsr sub_addScore1000
    lda #$00
sub_addScore100_display:
    sta v_sc100
    lda #$20
    sta $2006
    lda #$2b
    sta $2006
    lda v_sc100
    clc
    adc #$30
    sta $2007
    ; 必要に応じてハイスコアの更新
    lda v_hi_update
    bne sub_addScore100_displayH
    rts
sub_addScore100_displayH:
    lda #$20
    sta $2006
    lda #$3a
    sta $2006
    lda v_sc100
    sta v_hi100
    clc
    adc #$30
    sta $2007
    rts

sub_addScore1000:
    lda v_sc1000
    clc
    adc #$01
    cmp #$0a
    bcc sub_addScore1000_display
    jsr sub_addScore10000
    lda #$00
sub_addScore1000_display:
    sta v_sc1000
    lda #$20
    sta $2006
    lda #$2a
    sta $2006
    lda v_sc1000
    clc
    adc #$30
    sta $2007
    ; 必要に応じてハイスコアの更新
    lda v_hi_update
    bne sub_addScore1000_displayH
    rts
sub_addScore1000_displayH:
    lda #$20
    sta $2006
    lda #$39
    sta $2006
    lda v_sc1000
    sta v_hi1000
    clc
    adc #$30
    sta $2007
    rts

sub_addScore10000:
    lda v_sc10000
    clc
    adc #$01
    cmp #$0a
    bcc sub_addScore10000_display
    jsr sub_addScore100000
    lda #$00
sub_addScore10000_display:
    sta v_sc10000
    lda #$20
    sta $2006
    lda #$29
    sta $2006
    lda v_sc10000
    clc
    adc #$30
    sta $2007
    ; 必要に応じてハイスコアの更新
    lda v_hi_update
    bne sub_addScore10000_displayH
    rts
sub_addScore10000_displayH:
    lda #$20
    sta $2006
    lda #$38
    sta $2006
    lda v_sc10000
    sta v_hi10000
    clc
    adc #$30
    sta $2007
    rts

sub_addScore100000:
    lda v_sc100000
    clc
    adc #$01
    cmp #$0a
    bcc sub_addScore100000_display
    jsr sub_addScore1000000
    lda #$00
sub_addScore100000_display:
    sta v_sc100000
    lda #$20
    sta $2006
    lda #$28
    sta $2006
    lda v_sc100000
    clc
    adc #$30
    sta $2007
    ; 必要に応じてハイスコアの更新
    lda v_hi_update
    bne sub_addScore100000_displayH
    rts
sub_addScore100000_displayH:
    lda #$20
    sta $2006
    lda #$37
    sta $2006
    lda v_sc100000
    sta v_hi100000
    clc
    adc #$30
    sta $2007
    rts

sub_addScore1000000:
    lda v_sc1000000
    clc
    adc #$01
    cmp #$0a
    bcc sub_addScore1000000_display
    rts
sub_addScore1000000_display:
    sta v_sc1000000
    lda #$20
    sta $2006
    lda #$27
    sta $2006
    lda v_sc1000000
    clc
    adc #$30
    sta $2007
    ; 必要に応じてハイスコアの更新
    lda v_hi_update
    bne sub_addScore1000000_displayH
    rts
sub_addScore1000000_displayH:
    lda #$20
    sta $2006
    lda #$36
    sta $2006
    lda v_sc1000000
    sta v_hi1000000
    clc
    adc #$30
    sta $2007
    rts

;----------------------------------------------------------
; 現在のスコアを表示する（初期表示用）
;----------------------------------------------------------
draw_score:
    lda #$20
    sta $2006
    lda #$23
    sta $2006
    ldy #26
    ldx #$00
draw_score_loop:
    lda string_score, x
    sta $2007
    inx
    dey
    bne draw_score_loop

    ; スコアの数値を描画
    lda v_sc1000000
    bne draw_score_sc1000000
    lda v_sc100000
    bne draw_score_sc100000
    lda v_sc10000
    bne draw_score_sc10000
    lda v_sc1000
    bne draw_score_sc1000
    lda v_sc100
    bne draw_score_sc100
    jmp draw_score_sc10
draw_score_sc1000000:
    lda #$20
    sta $2006
    lda #$27
    sta $2006
    lda v_sc1000000
    clc
    adc #$30
    sta $2007
draw_score_sc100000:
    lda #$20
    sta $2006
    lda #$28
    sta $2006
    lda v_sc100000
    clc
    adc #$30
    sta $2007
draw_score_sc10000:
    lda #$20
    sta $2006
    lda #$29
    sta $2006
    lda v_sc10000
    clc
    adc #$30
    sta $2007
draw_score_sc1000:
    lda #$20
    sta $2006
    lda #$2a
    sta $2006
    lda v_sc1000
    clc
    adc #$30
    sta $2007
draw_score_sc100:
    lda #$20
    sta $2006
    lda #$2b
    sta $2006
    lda v_sc100
    clc
    adc #$30
    sta $2007
draw_score_sc10:
    lda #$20
    sta $2006
    lda #$2c
    sta $2006
    lda v_sc10
    clc
    adc #$30
    sta $2007

    ; ハイスコアの数値を描画
    lda v_hi1000000
    bne draw_score_hi1000000
    lda v_hi100000
    bne draw_score_hi100000
    lda v_hi10000
    bne draw_score_hi10000
    lda v_hi1000
    bne draw_score_hi1000
    lda v_hi100
    bne draw_score_hi100
    jmp draw_score_hi10
draw_score_hi1000000:
    lda #$20
    sta $2006
    lda #$36
    sta $2006
    lda v_hi1000000
    clc
    adc #$30
    sta $2007
draw_score_hi100000:
    lda #$20
    sta $2006
    lda #$37
    sta $2006
    lda v_hi100000
    clc
    adc #$30
    sta $2007
draw_score_hi10000:
    lda #$20
    sta $2006
    lda #$38
    sta $2006
    lda v_hi10000
    clc
    adc #$30
    sta $2007
draw_score_hi1000:
    lda #$20
    sta $2006
    lda #$39
    sta $2006
    lda v_hi1000
    clc
    adc #$30
    sta $2007
draw_score_hi100:
    lda #$20
    sta $2006
    lda #$3a
    sta $2006
    lda v_hi100
    clc
    adc #$30
    sta $2007
draw_score_hi10:
    lda #$20
    sta $2006
    lda #$3b
    sta $2006
    lda v_hi10
    clc
    adc #$30
    sta $2007
    rts

