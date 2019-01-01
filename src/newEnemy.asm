sub_newEnemy:
    ; 敵のパターン情報を記憶
    ldx v_et_idx
    inx
    txa
    and #$0f
    sta v_et_idx
    tax
    lda enemy_table, x
    sta v_work
    ; インデックスを加算
    lda v_enemy_idx
    clc
    adc #$08
    and #$3f
    sta v_enemy_idx
    tax
    lda v_enemy_f, x
    beq newEnemy_ok
    rts
newEnemy_ok:
    ; 使用するスプライトindex (敵index * 1.5) をv_enemy_siに格納しておく
    txa
    ror
    clc
    adc v_enemy_idx
    sta v_enemy_si, x
    lda v_work
    cmp #$01
    bne newEnemy_not1
    jmp newEnemy1
newEnemy_not1:
    jmp newEnemy2

;------------------------------------------------------------
; 敵1 (右方向へ動く潜水艦)
;------------------------------------------------------------
newEnemy1:
    sta v_enemy_f, x
    lda #$00
    sta v_enemy_x, x
    ldy v_enemy_si, x
    sta sp_enemyX, y
    clc
    adc #$08
    sta sp_enemyX + 4, y
    clc
    adc #$08
    sta sp_enemyX + 8, y
    ; Y座標をランダムで決定
    txa
    pha
    ldx v_rand_idx
    inx
    stx v_rand_idx
    lda rand_table, x
    and #$07
    cmp #$00
    beq newEnemy1_cancel
    cmp #$07
    beq newEnemy1_cancel
    sta v_work + 1
    tax
    pha
    lda v_sb_exist, x
    beq newEnemy1_ok
    ; 同じY座標に既に潜水艦が居るので登場をキャンセル
    pla
newEnemy1_cancel:
    pla
    tax
    lda #$00
    sta v_enemy_f, x
    rts
newEnemy1_ok:
    lda #$01
    sta v_sb_exist, x
    pla
    rol
    rol
    rol
    rol
    clc
    adc #$60
    sta v_work
    pla
    tax
    lda v_work + 1
    sta v_enemy_i1, x
    lda v_work
    sta v_enemy_y, x
    sta sp_enemyY, y
    sta sp_enemyY + 4, y
    sta sp_enemyY + 8, y
    lda #$20
    sta sp_enemyT, y
    lda #$28
    sta sp_enemyT + 4, y
    lda #$2a
    sta sp_enemyT + 8, y
    lda #$00
    sta sp_enemyA, y
    sta sp_enemyA + 4, y
    sta sp_enemyA + 8, y
    sta v_enemy_i0, x
    sta v_enemy_i2, x
    sta v_enemy_i3, x
    rts

;------------------------------------------------------------
; 敵2 (左方向へ動く潜水艦)
;------------------------------------------------------------
newEnemy2:
    sta v_enemy_f, x
    lda #232
    sta v_enemy_x, x
    ldy v_enemy_si, x
    sta sp_enemyX, y
    clc
    adc #$08
    sta sp_enemyX + 4, y
    adc #$08
    sta sp_enemyX + 8, y
    ; Y座標をランダムで決定
    txa
    pha
    ldx v_rand_idx
    inx
    stx v_rand_idx
    lda rand_table, x
    and #$07
    cmp #$00
    beq newEnemy2_cancel
    cmp #$07
    beq newEnemy2_cancel
    sta v_work + 1
    tax
    pha
    lda v_sb_exist, x
    beq newEnemy2_ok
    ; 同じY座標に既に潜水艦が居るので登場をキャンセル
    pla
newEnemy2_cancel:
    pla
    tax
    lda #$00
    sta v_enemy_f, x
    rts
newEnemy2_ok:
    lda #$01
    sta v_sb_exist, x
    pla
    rol
    rol
    rol
    rol
    clc
    adc #$60
    sta v_work
    pla
    tax
    lda v_work + 1
    sta v_enemy_i1, x
    lda v_work
    sta v_enemy_y, x
    sta sp_enemyY, y
    sta sp_enemyY + 4, y
    sta sp_enemyY + 8, y
    lda #$30
    sta sp_enemyT + 8, y
    lda #$38
    sta sp_enemyT + 4, y
    lda #$3a
    sta sp_enemyT, y
    lda #$00
    sta sp_enemyA, y
    sta sp_enemyA + 4, y
    sta sp_enemyA + 8, y
    sta v_enemy_i0, x
    sta v_enemy_i2, x
    sta v_enemy_i3, x
    rts
