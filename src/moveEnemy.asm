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
    cmp #$ff
    beq moveEnemy_isFF ; 敵4/5よりも爆発の方が出現頻度が高いので先に判定しておく
    cmp #$04
    bne moveEnemy_not4
    jmp moveEnemy4
moveEnemy_not4:
    cmp #$05
    bne moveEnemy_not5
    jmp moveEnemy5
moveEnemy_not5:
moveEnemy_isFF:
    jmp moveEnemyFF
moveEnemy_next:
    txa
    clc
    adc #$04
    and #$1f
    bne moveEnemy_loop
    rts

;------------------------------------------------------------
; 敵1 (右方向へ動く潜水艦)
;------------------------------------------------------------
moveEnemy1:
    lda v_enemy_i + 0, x
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
    sta v_enemy_i + 0, x
moveEnemy1_right:
    clc
    adc v_enemy_x, x
    cmp #240
    bcs moveEnemy1_erase
    sta v_enemy_x, x
    sta sp_enemyX0, x
    clc
    adc #$08
    sta sp_enemyX1, x
    adc #$08
    sta sp_enemyX2, x
moveEnemy1_animate:
    ; アニメーション
    lda v_counter
    and #%00001100
    ror
    clc
    adc #$20
    sta sp_enemyT0, x
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
    lda #$00
    sta v_enemy_f, x
    sta sp_enemyT0, x
    sta sp_enemyT1, x
    sta sp_enemyT2, x
    sta sp_enemyY0, x
    sta sp_enemyY1, x
    sta sp_enemyY2, x
    ldy v_enemy_i + 1, x
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
    sta sp_enemyX0, x
    clc
    adc #$08
    sta sp_enemyX1, x
    lda #$00
    sta sp_enemyT2, x
    sta sp_enemyY2, x
    sta v_enemy_i + 0, x
    lda #$01
    sta sp_enemyA0, x
    sta sp_enemyA1, x
    lda #$40
    sta sp_enemyT0, x
    lda #$50
    sta sp_enemyT1, x
    ldy v_enemy_i + 1, x
    lda #$00
    sta v_sb_exist, y
    jmp moveEnemy_next

;------------------------------------------------------------
; 敵2 (左方向へ動く潜水艦)
;------------------------------------------------------------
moveEnemy2:
    lda v_enemy_i + 0, x
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
    sta v_enemy_i + 0, x
moveEnemy2_left:
    lda v_enemy_x, x
    clc
    sbc v_enemy_i + 0, x
    cmp #248
    bcs moveEnemy2_erase
    sta v_enemy_x, x
    sta sp_enemyX0, x
    adc #$08
    sta sp_enemyX1, x
    adc #$08
    sta sp_enemyX2, x
    ; アニメーション
    lda v_counter
    and #%00001100
    ror
    clc
    adc #$30
    sta sp_enemyT2, x
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
    lda #$00
    sta v_enemy_f, x
    sta sp_enemyT0, x
    sta sp_enemyT1, x
    sta sp_enemyT2, x
    sta sp_enemyY0, x
    sta sp_enemyY1, x
    sta sp_enemyY2, x
    ldy v_enemy_i + 1, x
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
    sta sp_enemyX0, x
    clc
    adc #$08
    sta sp_enemyX1, x
    lda #$00
    sta sp_enemyT2, x
    sta sp_enemyY2, x
    sta v_enemy_i + 0, x
    lda #$01
    sta sp_enemyA0, x
    sta sp_enemyA1, x
    lda #$40
    sta sp_enemyT0, x
    lda #$50
    sta sp_enemyT1, x
    ldy v_enemy_i + 1, x
    lda #$00
    sta v_sb_exist, y
    jmp moveEnemy_next

;------------------------------------------------------------
; 潜水艦から魚雷を発射 (xが発射元の潜水艦のindexでa/yを自由に使用可能)
;------------------------------------------------------------
moveEnemy_fire:
    ldy v_enemy_i + 2, x
    beq moveEnemy_fire_start
    dey
    sty v_enemy_i + 2, x
    jmp moveEnemy_next
moveEnemy_fire_start:
    ; 発射抑止を設定
    lda #$04
    sta v_enemy_i + 2, x
    ; インデックスを加算
    lda v_enemy_idx
    clc
    adc #$04
    and #$1f
    sta v_enemy_idx
    tay
    lda v_enemy_f, y
    beq moveEnemy_fire_ok
    jmp moveEnemy_next
moveEnemy_fire_ok:
    lda #$03
    sta v_enemy_f, y
    ; X座標 = 潜水艦+8
    lda v_enemy_x, x
    clc
    adc #$08
    sta v_enemy_x, y
    sta sp_enemyX0, y
    ; Y座標 = 潜水艦-8
    lda v_enemy_y, x
    clc
    sbc #$08
    sta v_enemy_y, y
    sta sp_enemyY0, y
    ; 使用するフラグを初期化
    lda #$00
    sta v_enemy_i + 0, y
    sta v_enemy_i + 1, y
    sta v_enemy_i + 2, y
    ; スプライトパターン設定
    lda #$0a
    sta sp_enemyT0, y
    lda #%00000010
    sta sp_enemyA0, y
    ; play SE (矩形波2を使う)
    ;     ddcevvvv (d=duty, c=再生時間カウンタ, e=effect, v=volume)
    lda #%00011111
    sta $4004
    ;     csssmrrr (c=周波数変化, s=speed, m=method, r=range)
    lda #%11111010
    sta $4005
    ;     kkkkkkkk (k=音程周波数の下位8bit)
    lda #%11100000
    sta $4006
    ;     tttttkkk (t=再生時間, k=音程周波数の上位3bit)
    lda #%10101001
    sta $4007
    jmp moveEnemy_next

;------------------------------------------------------------
; 敵3 (潜水艦の魚雷)
;------------------------------------------------------------
moveEnemy3:
    ldy v_enemy_i + 0, x
    iny
    sty v_enemy_i + 0, x
    tya
    and #$0f
    bne moveEnemy3_notSpeedUp
    ldy v_enemy_i + 1, x
    iny
    sty v_enemy_i + 1, x
moveEnemy3_notSpeedUp:
    ; 加速しながら上昇
    lda v_enemy_y, x
    clc
    sbc v_enemy_i + 1, x
    cmp #$f8
    bcs moveEnemy3_erase
    sta v_enemy_y, x
    sta sp_enemyY0, x
    tay
    ; アニメーション
    lda v_counter
    and #%00000100
    ror
    clc
    adc #$0a
    sta sp_enemyT0, x
    ; #4a未満になったら水しぶきをあげる
    lda v_enemy_i + 2, x
    bne moveEnemy3_hitCheck
    tya
    cmp #$4a
    bcs moveEnemy3_hitCheck
    lda #$40
    sta sp_dustEY
    sta sp_dustEY + 4
    lda #%00000011 ;
    sta sp_dustEA
    sta sp_dustEA + 4
    lda v_enemy_x, x
    sbc #$04
    sta sp_dustEX
    adc #$08
    sta sp_dustEX + 4
    lda #$01
    sta v_dustE
    sta v_enemy_i + 2, x

    ; play SE1 (ノイズを使う)
    ;     --cevvvv (c=再生時間カウンタ, e=effect, v=volume)
    lda #%00011111
    sta $400C
    ;     r---ssss (r=乱数種別, s=サンプリングレート)
    lda #%01100001
    sta $400E
    ;     ttttt--- (t=再生時間)
    lda #%00111111
    sta $400F
moveEnemy3_hitCheck:
    ; ショットとの当たり判定
    lda v_shotF
    beq moveEnemy3_noHit
    lda v_shotY
    cmp v_enemy_y, x
    bcs moveEnemy3_noHit
    adc #$10
    cmp v_enemy_y, x
    bcc moveEnemy3_noHit
    lda v_shotX
    adc #$07
    cmp v_enemy_x, x
    bcc moveEnemy3_noHit
    lda v_enemy_x, x
    adc #$07
    cmp v_shotX
    bcc moveEnemy3_noHit
    jmp moveEnemy3_destruct
moveEnemy3_noHit:
    jmp moveEnemy_next
moveEnemy3_erase:
    lda #$00
    sta v_enemy_f, x
    sta sp_enemyT0, x
    sta sp_enemyY0, x
    jmp moveEnemy_next
moveEnemy3_destruct:
    ; 爆発
    lda #$00
    sta v_shotF
    sta sp_shotT
    sta sp_shotY
    lda #$ff
    sta v_enemy_f, x
    lda v_enemy_x, x
    clc
    sbc #$04
    sta v_enemy_x, x
    sta sp_enemyX0, x
    clc
    adc #$08
    sta sp_enemyX1, x
    lda v_enemy_y, x
    sta sp_enemyY1, x
    lda #$00
    sta v_enemy_i + 0, x
    lda #$01
    sta sp_enemyA0, x
    sta sp_enemyA1, x
    lda #$40
    sta sp_enemyT0, x
    lda #$50
    sta sp_enemyT1, x
    jmp moveEnemy_next

;------------------------------------------------------------
; 敵4 (右方向に進む魚)
;------------------------------------------------------------
moveEnemy4:
    lda v_enemy_i + 0, x
    bne moveEnemy4_right
    ; 移動速度を決定
    ldy v_rand_idx
    iny
    sty v_rand_idx
    lda rand_table, y
    and #$03
    bne moveEnemy4_speed_over1
    adc #$01
moveEnemy4_speed_over1:
    sta v_work
    sta v_enemy_i + 0, x
    ; 上昇開始までのフレーム数を算出
    ldy v_rand_idx
    iny
    sty v_rand_idx
    lda rand_table, y
    and #$3f
    sta v_enemy_i + 2, x
moveEnemy4_right:
    lda v_enemy_x, x
    clc
    adc v_enemy_i + 0, x
    cmp #248
    bcs moveEnemy4_erase
    sta v_enemy_x, x
    sta sp_enemyX0, x
    clc
    adc #$08
    sta sp_enemyX1, x
    jsr moveEnemy4_switch
moveEnemy4_hitCheck:
    ; ショットとの当たり判定
    lda v_shotF
    beq moveEnemy4_noHit
    lda v_shotY
    cmp v_enemy_y, x
    bcs moveEnemy4_noHit
    adc #$10
    cmp v_enemy_y, x
    bcc moveEnemy4_noHit
    lda v_shotX
    adc #$07
    cmp v_enemy_x, x
    bcc moveEnemy4_noHit
    lda v_enemy_x, x
    adc #$10
    cmp v_shotX
    bcc moveEnemy4_noHit
    jmp moveEnemy4_destruct
moveEnemy4_erase:
    lda #$00
    sta v_enemy_f, x
    sta sp_enemyT0, x
    sta sp_enemyT1, x
    sta sp_enemyY0, x
    sta sp_enemyY1, x
    ldy v_enemy_i + 1, x
    sta v_sb_exist, y
    jmp moveEnemy_next
moveEnemy4_noHit:
    jmp moveEnemy_next
moveEnemy4_destruct:
    ; 爆発
    lda #$00
    sta v_shotF
    sta sp_shotT
    sta sp_shotY
    lda #$ff
    sta v_enemy_f, x
    lda #$00
    sta v_enemy_i + 0, x
    lda #$01
    sta sp_enemyA0, x
    sta sp_enemyA1, x
    lda #$40
    sta sp_enemyT0, x
    lda #$50
    sta sp_enemyT1, x
    ldy v_enemy_i + 1, x
    lda #$00
    sta v_sb_exist, y
    jmp moveEnemy_next

moveEnemy4_switch:
    ; i+3の内容を見て動作を変える
    lda v_enemy_i + 3, x
    beq moveEnemy4_waitForJump
    cmp #$01
    beq moveEnemy4_jump
    cmp #$02
    beq moveEnemy4_fall
    rts
moveEnemy4_waitForJump:
    ; ジャンプタイミング待ち
    ldy v_enemy_i + 2, x
    dey
    sty v_enemy_i + 2, x
    bne moveEnemy4_waitForJump_end
    ; ジャンプ開始
    lda #$74
    sta sp_enemyT0, x
    lda #$76
    sta sp_enemyT1, x
    lda #$01
    sta v_enemy_i + 3, x
moveEnemy4_waitForJump_end:
    rts
moveEnemy4_jump:
    ; 一定の高さまでジャンプ
    lda v_enemy_y, x
    clc
    sbc #$02
    sta v_enemy_y, x
    sta sp_enemyY0, x
    sta sp_enemyY1, x
    and #$fe
    cmp #$4e
    bne moveEnemy4_jump_noSplash
moveEnemy4_splash:
    ; 水しぶきをあげる
    lda #$40
    sta sp_dustEY
    sta sp_dustEY + 4
    lda #%00000011 ;
    sta sp_dustEA
    sta sp_dustEA + 4
    lda v_enemy_x, x
    sbc #$04
    sta sp_dustEX
    adc #$08
    sta sp_dustEX + 4
    lda #$01
    sta v_dustE
    sta v_enemy_i + 2, x
    ; play SE1 (ノイズを使う)
    ;     --cevvvv (c=再生時間カウンタ, e=effect, v=volume)
    lda #%00011111
    sta $400C
    ;     r---ssss (r=乱数種別, s=サンプリングレート)
    lda #%01100001
    sta $400E
    ;     ttttt--- (t=再生時間)
    lda #%00111111
    sta $400F
    rts
moveEnemy4_jump_noSplash:
    cmp #$20
    bcs moveEnemy4_jump_end
    ; 一定の高さに達したので落下を始める
    lda #$78
    sta sp_enemyT0, x
    lda #$7a
    sta sp_enemyT1, x
    lda #$02
    sta v_enemy_i + 3, x
moveEnemy4_jump_end:
    rts
moveEnemy4_fall:
    ; 一定の低さまで落ちる
    lda v_enemy_y, x
    clc
    adc #$02
    sta v_enemy_y, x
    sta sp_enemyY0, x
    sta sp_enemyY1, x
    cmp #$a0
    bcc moveEnemy4_fall_end
    ; 落下から単純な進行に切り替える
    lda #$70
    sta sp_enemyT0, x
    lda #$72
    sta sp_enemyT1, x
    lda #$03
    sta v_enemy_i + 3, x
    rts
moveEnemy4_fall_end:
    and #$fe
    cmp #$4e
    bne moveEnemy4_fall_noSplash
    jmp moveEnemy4_splash
moveEnemy4_fall_noSplash:
    rts

;------------------------------------------------------------
; 敵5 (左方向に進む魚)
;------------------------------------------------------------
moveEnemy5:
    lda v_enemy_i + 0, x
    bne moveEnemy5_left
    ; 移動速度を決定
    ldy v_rand_idx
    iny
    sty v_rand_idx
    lda rand_table, y
    and #$03
    bne moveEnemy5_speed_over1
    adc #$01
moveEnemy5_speed_over1:
    sta v_work
    sta v_enemy_i + 0, x
    ; 上昇開始までのフレーム数を算出
    ldy v_rand_idx
    iny
    sty v_rand_idx
    lda rand_table, y
    and #$3f
    sta v_enemy_i + 2, x
moveEnemy5_left:
    lda v_enemy_x, x
    clc
    sbc v_enemy_i + 0, x 
    cmp #249
    bcs moveEnemy5_erase
    sta v_enemy_x, x
    sta sp_enemyX0, x
    clc
    adc #$08
    sta sp_enemyX1, x
    jsr moveEnemy5_switch
moveEnemy5_hitCheck:
    ; ショットとの当たり判定
    lda v_shotF
    beq moveEnemy5_noHit
    lda v_shotY
    cmp v_enemy_y, x
    bcs moveEnemy5_noHit
    adc #$10
    cmp v_enemy_y, x
    bcc moveEnemy5_noHit
    lda v_shotX
    adc #$07
    cmp v_enemy_x, x
    bcc moveEnemy5_noHit
    lda v_enemy_x, x
    adc #$10
    cmp v_shotX
    bcc moveEnemy5_noHit
    jmp moveEnemy5_destruct
moveEnemy5_erase:
    lda #$00
    sta v_enemy_f, x
    sta sp_enemyT0, x
    sta sp_enemyT1, x
    sta sp_enemyY0, x
    sta sp_enemyY1, x
    ldy v_enemy_i + 1, x
    sta v_sb_exist, y
    jmp moveEnemy_next
moveEnemy5_noHit:
    jmp moveEnemy_next
moveEnemy5_destruct:
    ; 爆発
    lda #$00
    sta v_shotF
    sta sp_shotT
    sta sp_shotY
    lda #$ff
    sta v_enemy_f, x
    lda #$00
    sta v_enemy_i + 0, x
    lda #$01
    sta sp_enemyA0, x
    sta sp_enemyA1, x
    lda #$40
    sta sp_enemyT0, x
    lda #$50
    sta sp_enemyT1, x
    ldy v_enemy_i + 1, x
    lda #$00
    sta v_sb_exist, y
    jmp moveEnemy_next

moveEnemy5_switch:
    ; i+3の内容を見て動作を変える
    lda v_enemy_i + 3, x
    beq moveEnemy5_waitForJump
    cmp #$01
    beq moveEnemy5_jump
    cmp #$02
    beq moveEnemy5_fall
    rts
moveEnemy5_waitForJump:
    ; ジャンプタイミング待ち
    ldy v_enemy_i + 2, x
    dey
    sty v_enemy_i + 2, x
    bne moveEnemy5_waitForJump_end
    ; ジャンプ開始
    lda #$84
    sta sp_enemyT0, x
    lda #$86
    sta sp_enemyT1, x
    lda #$01
    sta v_enemy_i + 3, x
moveEnemy5_waitForJump_end:
    rts
moveEnemy5_jump:
    ; 一定の高さまでジャンプ
    lda v_enemy_y, x
    clc
    sbc #$02
    sta v_enemy_y, x
    sta sp_enemyY0, x
    sta sp_enemyY1, x
    and #$fe
    cmp #$4e
    bne moveEnemy5_jump_noSplash
moveEnemy5_splash:
    ; 水しぶきをあげる
    lda #$40
    sta sp_dustEY
    sta sp_dustEY + 4
    lda #%00000011 ;
    sta sp_dustEA
    sta sp_dustEA + 4
    lda v_enemy_x, x
    sbc #$04
    sta sp_dustEX
    adc #$08
    sta sp_dustEX + 4
    lda #$01
    sta v_dustE
    sta v_enemy_i + 2, x
    ; play SE1 (ノイズを使う)
    ;     --cevvvv (c=再生時間カウンタ, e=effect, v=volume)
    lda #%00011111
    sta $400C
    ;     r---ssss (r=乱数種別, s=サンプリングレート)
    lda #%01100001
    sta $400E
    ;     ttttt--- (t=再生時間)
    lda #%00111111
    sta $400F
    rts
moveEnemy5_jump_noSplash:
    cmp #$20
    bcs moveEnemy5_jump_end
    ; 一定の高さに達したので落下を始める
    lda #$88
    sta sp_enemyT0, x
    lda #$8a
    sta sp_enemyT1, x
    lda #$02
    sta v_enemy_i + 3, x
moveEnemy5_jump_end:
    rts
moveEnemy5_fall:
    ; 一定の低さまで落ちる
    lda v_enemy_y, x
    clc
    adc #$02
    sta v_enemy_y, x
    sta sp_enemyY0, x
    sta sp_enemyY1, x
    cmp #$a0
    bcc moveEnemy5_fall_end
    ; 落下から単純な進行に切り替える
    lda #$80
    sta sp_enemyT0, x
    lda #$82
    sta sp_enemyT1, x
    lda #$03
    sta v_enemy_i + 3, x
    rts
moveEnemy5_fall_end:
    and #$fe
    cmp #$4e
    bne moveEnemy5_fall_noSplash
    jmp moveEnemy5_splash
moveEnemy5_fall_noSplash:
    rts

;------------------------------------------------------------
; 敵FF (爆発エフェクト)
;------------------------------------------------------------
moveEnemyFF:
    ldy v_enemy_i + 0, x
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
    sta v_enemy_i + 0, x
    and #%00011100
    lsr
    clc
    adc #$40
    sta sp_enemyT0, x
    adc #$10
    sta sp_enemyT1, x
    jmp moveEnemy_next
moveEnemyFF_erase:
    lda #$00
    sta v_enemy_f, x
    sta sp_enemyT0, x
    sta sp_enemyY0, x
    sta sp_enemyT1, x
    sta sp_enemyY1, x
    jmp moveEnemy_next
