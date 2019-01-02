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
    cmp #$03
    bne moveEnemy_not3
    jmp moveEnemy3
moveEnemy_not3:
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
    jmp moveEnemy_next
moveEnemy1_noHit:
    ; 自機が射程に居る場合は魚雷を発射
    lda v_enemy_x, x
    adc #24
    cmp v_playerX
    bcc moveEnemy1_noFire
    lda v_playerX
    adc #24
    cmp v_enemy_x, x
    bcc moveEnemy1_noFire
    jmp moveEnemy_fire
moveEnemy1_noFire:
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
    jmp moveEnemy_next
moveEnemy2_noHit:
    ; 自機が射程に居る場合は魚雷を発射
    lda v_enemy_x, x
    adc #24
    cmp v_playerX
    bcc moveEnemy2_noFire
    lda v_playerX
    adc #24
    cmp v_enemy_x, x
    bcc moveEnemy2_noFire
    jmp moveEnemy_fire
moveEnemy2_noFire:
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
; 潜水艦から魚雷を発射 (xが発射元の潜水艦のindexでa/yを自由に使用可能)
;------------------------------------------------------------
moveEnemy_fire:
    ldy v_enemy_i2, x
    beq moveEnemy_fire_start
    dey
    sty v_enemy_i2, x
    jmp moveEnemy_next
moveEnemy_fire_start:
    ; 発射抑止を設定
    lda #$04
    sta v_enemy_i2, x
    ; インデックスを加算
    lda v_enemy_idx
    clc
    adc #$08
    and #$3f
    sta v_enemy_idx
    tay
    lda v_enemy_f, y
    beq moveEnemy_fire_ok
    jmp moveEnemy_next
moveEnemy_fire_ok:
    lda #$03
    sta v_enemy_f, y
    ; 使用するスプライトindex (敵index * 1.5) をv_enemy_siに格納しておく
    tya
    ror
    clc
    adc v_enemy_idx
    sta v_enemy_si, y
    ; X座標 = 潜水艦+8
    lda v_enemy_x, x
    clc
    adc #$08
    sta v_enemy_x, y
    sta v_work + 0 ; 後でスプライトに設定するために一時記憶
    ; Y座標 = 潜水艦-16
    lda v_enemy_y, x
    clc
    sbc #$10
    sta v_enemy_y, y
    sta v_work + 1 ; 後でスプライトに設定するために一時記憶
    ; 使用するフラグを初期化
    lda #$00
    sta v_enemy_i0, y
    sta v_enemy_i1, y
    ; レジスタYをスプライトindexに変更してスプライトの初期化
    lda v_enemy_si, y
    tay
    lda #$0a
    sta sp_enemyT, y
    lda v_work+0
    sta sp_enemyX, y
    lda v_work+1
    sta sp_enemyY, y
    lda #%00000010
    sta sp_enemyA, y
    jmp moveEnemy_next

;------------------------------------------------------------
; 敵3 (潜水艦の魚雷)
;------------------------------------------------------------
moveEnemy3:
    ldy v_enemy_i0, x
    iny
    sty v_enemy_i0, x
    tya
    and #$0f
    bne moveEnemy3_notSpeedUp
    ldy v_enemy_i1, x
    iny
    sty v_enemy_i1, x
moveEnemy3_notSpeedUp:
    ; 加速しながら上昇
    lda v_enemy_y, x
    clc
    sbc v_enemy_i1, x
    cmp #$f8
    bcs moveEnemy3_erase
    sta v_enemy_y, x
    ldy v_enemy_si, x
    sta sp_enemyY, y
    ; アニメーション
    lda v_counter
    and #%00000100
    ror
    clc
    adc #$0a
    sta sp_enemyT, y
    jmp moveEnemy_next
moveEnemy3_erase:
    ldy v_enemy_si, x
    lda #$00
    sta v_enemy_f, x
    sta sp_enemyT, y
    sta sp_enemyY, y
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
