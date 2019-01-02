sub_moveEnemy:
    lda #$00
moveEnemy_loop:
    tax
    lda v_enemy_f, x
    beq moveEnemy_next
    cmp #$01
    bne moveEnemy_not1
    jmp moveEnemy1
moveEnemy_not1:
    cmp #$02
    bne moveEnemy_not2
    jmp moveEnemy2
moveEnemy_not2:
    jmp moveEnemyFF
moveEnemy_next:
    txa
    clc
    adc #$08
    and #$3f
    bne moveEnemy_loop
    rts

;------------------------------------------------------------
; 敵1 (右方向へ動く潜水艦)
;------------------------------------------------------------
moveEnemy1:
    lda v_enemy_i0, x
    bne moveEnemy1_right
    ; 移動速度を決定
    ldy v_rand_idx
    iny
    sty v_rand_idx
    lda rand_table, y
    and #$03
    bne moveEnemy1_speed_over1
    adc #$01
moveEnemy1_speed_over1:
    sta v_enemy_i0, x
moveEnemy1_right:
    clc
    adc v_enemy_x, x
    cmp #240
    bcs moveEnemy1_erase
    sta v_enemy_x, x
    ldy v_enemy_si, x
    sta sp_enemyX, y
    clc
    adc #$08
    sta sp_enemyX + 4, y
    adc #$08
    sta sp_enemyX + 8, y
moveEnemy1_animate:
    ; アニメーション
    lda v_counter
    and #%00001100
    ror
    clc
    adc #$20
    sta sp_enemyT, y
    ; ショットとの当たり判定
    lda v_shotF
    beq moveEnemy1_noHit
    lda v_shotY
    cmp v_enemy_y, x
    bcs moveEnemy1_noHit
    adc #$10
    cmp v_enemy_y, x
    bcc moveEnemy1_noHit
    lda v_shotX
    adc #$07
    cmp v_enemy_x, x
    bcc moveEnemy1_noHit
    lda v_enemy_x, x
    adc #$17
    cmp v_shotX
    bcc moveEnemy1_noHit
    jmp moveEnemy1_destruct
moveEnemy1_erase:
    ldy v_enemy_si, x
    lda #$00
    sta v_enemy_f, x
    sta sp_enemyT, y
    sta sp_enemyT + 4, y
    sta sp_enemyT + 8, y
    sta sp_enemyY, y
    sta sp_enemyY + 4, y
    sta sp_enemyY + 8, y
    ldy v_enemy_i1, x
    sta v_sb_exist, y
moveEnemy1_noHit:
    jmp moveEnemy_next
moveEnemy1_destruct:
    ; 爆発
    lda #$00
    sta v_shotF
    sta sp_shotT
    sta sp_shotY
    lda #$ff
    sta v_enemy_f, x
    lda v_enemy_x, x
    adc #$04
    sta v_enemy_x, x
    ldy v_enemy_si, x
    sta sp_enemyX, y
    clc
    adc #$08
    sta sp_enemyX + 4, y
    lda #$00
    sta sp_enemyT + 8, y
    sta sp_enemyY + 8, y
    sta v_enemy_i0, x
    lda #$01
    sta sp_enemyA, y
    sta sp_enemyA + 4, y
    lda #$40
    sta sp_enemyT + 0, y
    lda #$50
    sta sp_enemyT + 4, y
    ldy v_enemy_i1, x
    lda #$00
    sta v_sb_exist, y
    jmp moveEnemy_next

;------------------------------------------------------------
; 敵2 (左方向へ動く潜水艦)
;------------------------------------------------------------
moveEnemy2:
    lda v_enemy_i0, x
    bne moveEnemy2_left
    ; 移動速度を決定
    ldy v_rand_idx
    iny
    sty v_rand_idx
    lda rand_table, y
    and #$03
    bne moveEnemy2_speed_over1
    adc #$01
moveEnemy2_speed_over1:
    sta v_enemy_i0, x
moveEnemy2_left:
    lda v_enemy_x, x
    clc
    sbc v_enemy_i0, x
    cmp #248
    bcs moveEnemy2_erase
    sta v_enemy_x, x
    ldy v_enemy_si, x
    sta sp_enemyX, y
    adc #$08
    sta sp_enemyX + 4, y
    adc #$08
    sta sp_enemyX + 8, y
    ; アニメーション
    lda v_counter
    and #%00001100
    ror
    clc
    adc #$30
    sta sp_enemyT + 8, y
    ; ショットとの当たり判定
    lda v_shotF
    beq moveEnemy2_noHit
    lda v_shotY
    cmp v_enemy_y, x
    bcs moveEnemy2_noHit
    adc #$10
    cmp v_enemy_y, x
    bcc moveEnemy2_noHit
    lda v_shotX
    adc #$07
    cmp v_enemy_x, x
    bcc moveEnemy2_noHit
    lda v_enemy_x, x
    adc #$17
    cmp v_shotX
    bcc moveEnemy2_noHit
    jmp moveEnemy2_destruct
moveEnemy2_erase:
    ldy v_enemy_si, x
    lda #$00
    sta v_enemy_f, x
    sta sp_enemyT, y
    sta sp_enemyT + 4, y
    sta sp_enemyT + 8, y
    sta sp_enemyY, y
    sta sp_enemyY + 4, y
    sta sp_enemyY + 8, y
    ldy v_enemy_i1, x
    sta v_sb_exist, y
moveEnemy2_noHit:
    jmp moveEnemy_next
moveEnemy2_destruct:
    ; 爆発
    lda #$00
    sta v_shotF
    sta sp_shotT
    sta sp_shotY
    lda #$ff
    sta v_enemy_f, x
    lda v_enemy_x, x
    adc #$04
    sta v_enemy_x, x
    ldy v_enemy_si, x
    sta sp_enemyX, y
    clc
    adc #$08
    sta sp_enemyX + 4, y
    lda #$00
    sta sp_enemyT + 8, y
    sta sp_enemyY + 8, y
    sta v_enemy_i0, x
    lda #$01
    sta sp_enemyA, y
    sta sp_enemyA + 4, y
    lda #$40
    sta sp_enemyT + 0, y
    lda #$50
    sta sp_enemyT + 4, y
    ldy v_enemy_i1, x
    lda #$00
    sta v_sb_exist, y
    jmp moveEnemy_next

;------------------------------------------------------------
; 敵FF (爆発エフェクト)
;------------------------------------------------------------
moveEnemyFF:
    ldy v_enemy_i0, x
    bne moveEnemyFF_skipSE

    ; play SE1 (ノイズを使う)
    ;     --cevvvv (c=再生時間カウンタ, e=effect, v=volume)
    lda #%00011100
    sta $400C
    ;     r---ssss (r=乱数種別, s=サンプリングレート)
    lda #%00001001
    sta $400E
    ;     ttttt--- (t=再生時間)
    lda #%01111000
    sta $400F

    ; play SE2 (矩形波2を使う)
    ;     ddcevvvv (d=duty, c=再生時間カウンタ, e=effect, v=volume)
    lda #%00111101
    sta $4004
    ;     csssmrrr (c=周波数変化, s=speed, m=method, r=range)
    lda #%10110010
    sta $4005
    ;     kkkkkkkk (k=音程周波数の下位8bit)
    lda #%11101000
    sta $4006
    ;     tttttkkk (t=再生時間, k=音程周波数の上位3bit)
    lda #%10001000
    sta $4007

moveEnemyFF_skipSE:
    iny
    tya
    and #$1f
    beq moveEnemyFF_erase
    sta v_enemy_i0, x
    and #%00011100
    lsr
    clc
    adc #$40
    ldy v_enemy_si, x
    sta sp_enemyT, y
    adc #$10
    sta sp_enemyT + 4, y
    jmp moveEnemy_next
moveEnemyFF_erase:
    ldy v_enemy_si, x
    lda #$00
    sta v_enemy_f, x
    sta sp_enemyT, y
    sta sp_enemyY, y
    sta sp_enemyT + 4, y
    sta sp_enemyY + 4, y
    jmp moveEnemy_next
