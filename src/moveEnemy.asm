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
    cmp #$06
    bne moveEnemy_not6
    jmp moveEnemy6
moveEnemy_not6:
    cmp #$07
    bne moveEnemy_not7
    jmp moveEnemy7
moveEnemy_not7:
    cmp #$08
    bne moveEnemy_not8
    jmp moveEnemy8
moveEnemy_not8:
    cmp #$09
    bne moveEnemy_not9
    jmp moveEnemy9
moveEnemy_not9:
    cmp #$0a
    bne moveEnemy_notA
    jmp moveEnemyA
moveEnemy_notA:
    jmp moveEnemyB
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
    bcc moveEnemy3_notErase
    lda #$00
    sta v_enemy_f, x
    sta sp_enemyT0, x
    sta sp_enemyY0, x
    jmp moveEnemy_next
moveEnemy3_notErase:
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

    ; 自機との当たり判定 (xのみで行う)
    lda v_gameOver
    bne moveEnemy3_hitCheck
    lda v_playerX
    clc
    adc #24
    cmp v_enemy_x, x
    bcc moveEnemy3_hitCheck
    lda v_enemy_x, x
    adc #8
    cmp v_playerX
    bcc moveEnemy3_hitCheck
    jsr start_gameOver
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
    jmp moveEnemy4_checkGameOver
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

moveEnemy4_checkGameOver:
    ; 自機との当たり判定 (xのみで行う)
    lda v_gameOver
    bne moveEnemy4_noGameOver
    lda v_playerX
    clc
    adc #24
    cmp v_enemy_x, x
    bcc moveEnemy4_noGameOver
    lda v_enemy_x, x
    adc #16
    cmp v_playerX
    bcc moveEnemy4_noGameOver
    jsr start_gameOver
moveEnemy4_noGameOver:
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
    jmp moveEnemy5_checkGameOver
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

moveEnemy5_checkGameOver:
    ; 自機との当たり判定 (xのみで行う)
    lda v_gameOver
    bne moveEnemy5_noGameOver
    lda v_playerX
    clc
    adc #24
    cmp v_enemy_x, x
    bcc moveEnemy5_noGameOver
    lda v_enemy_x, x
    adc #16
    cmp v_playerX
    bcc moveEnemy5_noGameOver
    jsr start_gameOver
moveEnemy5_noGameOver:
    rts

;------------------------------------------------------------
; 敵6 (右方向へ動くカモメ)
;------------------------------------------------------------
moveEnemy6:
    ldy v_enemy_x, x
    iny
    tya
    cmp #248
    bcs moveEnemy6_erase
    sta v_enemy_x, x
    sta sp_enemyX0, x
    adc #$08
    sta sp_enemyX1, x
moveEnemy6_animate:
    ; アニメーション
    lda v_counter
    and #%00000100
    ror
    clc
    adc #$90
    sta sp_enemyT0, x
    adc #$04
    sta sp_enemyT1, x
    bne moveEnemy6_unkCheck
moveEnemy6_erase:
    lda #$00
    sta v_enemy_f, x
    sta sp_enemyT0, x
    sta sp_enemyT1, x
    sta sp_enemyY0, x
    sta sp_enemyY1, x
    jmp moveEnemy_next
moveEnemy6_unkCheck:
    ; 自機が射程に居る場合はうんこを発射
    lda v_enemy_x, x
    adc #16
    cmp v_playerX
    bcc moveEnemy6_noFire
    lda v_playerX
    adc #24
    cmp v_enemy_x, x
    bcc moveEnemy6_noFire
    jmp moveEnemy_newUnk
moveEnemy6_noFire:
    jmp moveEnemy_next

;------------------------------------------------------------
; 敵7 (左方向へ動くカモメ)
;------------------------------------------------------------
moveEnemy7:
    ldy v_enemy_x, x
    dey
    tya
    cmp #248
    bcs moveEnemy7_erase
    sta v_enemy_x, x
    sta sp_enemyX0, x
    adc #$08
    sta sp_enemyX1, x
moveEnemy7_animate:
    ; アニメーション
    lda v_counter
    and #%00000100
    ror
    clc
    adc #$a0
    sta sp_enemyT0, x
    adc #$04
    sta sp_enemyT1, x
    bne moveEnemy7_unkCheck
moveEnemy7_erase:
    lda #$00
    sta v_enemy_f, x
    sta sp_enemyT0, x
    sta sp_enemyT1, x
    sta sp_enemyY0, x
    sta sp_enemyY1, x
    jmp moveEnemy_next
moveEnemy7_unkCheck:
    ; 自機が射程に居る場合はうんこを発射
    lda v_enemy_x, x
    adc #16
    cmp v_playerX
    bcc moveEnemy7_noFire
    lda v_playerX
    adc #24
    cmp v_enemy_x, x
    bcc moveEnemy7_noFire
    jmp moveEnemy_newUnk
moveEnemy7_noFire:
    jmp moveEnemy_next

;------------------------------------------------------------
; 敵8 (うんこ)
;------------------------------------------------------------
moveEnemy8:
    ldy v_enemy_y, x
    iny
    tya
    cmp #$44
    bcs moveEnemy8_erase
    sta v_enemy_y, x
    sta sp_enemyY0, x
    ; 自機との当たり判定（うんこだけは毎フレーム厳密にチェック）
    lda v_gameOver
    bne moveEnemy8_noGameOver
    lda v_playerX
    clc
    adc #24
    cmp v_enemy_x, x
    bcc moveEnemy8_noGameOver
    lda v_enemy_x, x
    adc #16
    cmp v_playerX
    bcc moveEnemy8_noGameOver
    lda v_playerY
    clc
    adc #16
    cmp v_enemy_y, x
    bcc moveEnemy8_noGameOver
    lda v_enemy_y, x
    adc #16
    cmp v_playerY
    bcc moveEnemy8_noGameOver
    jsr start_gameOver
moveEnemy8_noGameOver:
    jmp moveEnemy_next
moveEnemy8_erase:
    lda #$00
    sta v_enemy_f, x
    sta sp_enemyT0, x
    sta sp_enemyY0, x
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
    jmp moveEnemy_next

;------------------------------------------------------------
; 敵9 (右方向へ動くカニ)
;------------------------------------------------------------
moveEnemy9:
    ; 行動フラグをチェック
    lda v_enemy_i + 0, x
    bne moveEnemy9_jump

    ; 待機行動 (32フレーム)
    lda v_enemy_i + 1, x
    clc
    adc #$01
    sta v_enemy_i + 1, x
    and #$1f
    bne moveEnemy9_hitCheck
    ; 待機解除 (ジャンプに遷移)
    lda #$01
    sta v_enemy_i + 0, x
    lda #$f8
    sta v_enemy_i + 1, x
    lda #$3c
    sta sp_enemyT0, x
    lda #$3e
    sta sp_enemyT1, x
moveEnemy9_hitCheck:
    ; ショットとの当たり判定
    lda v_shotF
    beq moveEnemy9_noHit
    lda v_shotY
    cmp v_enemy_y, x
    bcs moveEnemy9_noHit
    adc #$10
    cmp v_enemy_y, x
    bcc moveEnemy9_noHit
    lda v_shotX
    adc #$07
    cmp v_enemy_x, x
    bcc moveEnemy9_noHit
    lda v_enemy_x, x
    adc #$10
    cmp v_shotX
    bcc moveEnemy9_noHit
    jmp moveEnemy9_destruct
moveEnemy9_noHit:
    jmp moveEnemy_next

    ; ジャンプしながら進行
moveEnemy9_jump:
    ; X座標を更新 (カニは破壊するまで居座り続ける)
    lda v_enemy_x, x
    clc
    adc #$02
    sta v_enemy_x, x
    sta sp_enemyX0, x
    clc
    adc #$08
    sta sp_enemyX1, x
    ; Y座標を更新
    lda v_enemy_y, x
    adc v_enemy_i + 1, x
    sta v_enemy_y, x
    sta sp_enemyY0, x
    sta sp_enemyY1, x
    ; 地面に着いたら再び待機モードに戻る
    cmp #208
    bcs moveEnemy9_endJump
    ; 重力処理
    ldy v_enemy_i + 1, x
    iny
    bne moveEnemy9_notZero
    tya
    pha
    jsr moveEnemy_newKTM ; 重力0のタイミングでカニ玉を発射
    pla
    tay
moveEnemy9_notZero:
    sty v_enemy_i + 1, x
    jmp moveEnemy9_hitCheck
moveEnemy9_endJump:
    lda #$00
    sta v_enemy_i + 0, x
    sta v_enemy_i + 1, x
    lda #$2c
    sta sp_enemyT0, x
    lda #$2e
    sta sp_enemyT1, x
    jmp moveEnemy9_hitCheck

moveEnemy9_destruct:
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
    jmp moveEnemy_next

;------------------------------------------------------------
; 敵A (左方向へ動くカニ)
;------------------------------------------------------------
moveEnemyA:
    ; 行動フラグをチェック
    lda v_enemy_i + 0, x
    bne moveEnemyA_jump

    ; 待機行動 (32フレーム)
    lda v_enemy_i + 1, x
    clc
    adc #$01
    sta v_enemy_i + 1, x
    and #$1f
    bne moveEnemyA_hitCheck
    ; 待機解除 (ジャンプに遷移)
    lda #$01
    sta v_enemy_i + 0, x
    lda #$f8
    sta v_enemy_i + 1, x
    lda #$3c
    sta sp_enemyT0, x
    lda #$3e
    sta sp_enemyT1, x
moveEnemyA_hitCheck:
    ; ショットとの当たり判定
    lda v_shotF
    beq moveEnemyA_noHit
    lda v_shotY
    cmp v_enemy_y, x
    bcs moveEnemyA_noHit
    adc #$10
    cmp v_enemy_y, x
    bcc moveEnemyA_noHit
    lda v_shotX
    adc #$07
    cmp v_enemy_x, x
    bcc moveEnemyA_noHit
    lda v_enemy_x, x
    adc #$10
    cmp v_shotX
    bcc moveEnemyA_noHit
    jmp moveEnemyA_destruct
moveEnemyA_noHit:
    jmp moveEnemy_next

    ; ジャンプしながら進行
moveEnemyA_jump:
    ; X座標を更新 (カニは破壊するまで居座り続ける)
    lda v_enemy_x, x
    clc
    sbc #$02
    sta v_enemy_x, x
    sta sp_enemyX0, x
    clc
    adc #$08
    sta sp_enemyX1, x
    ; Y座標を更新
    lda v_enemy_y, x
    adc v_enemy_i + 1, x
    sta v_enemy_y, x
    sta sp_enemyY0, x
    sta sp_enemyY1, x
    ; 地面に着いたら再び待機モードに戻る
    cmp #208
    bcs moveEnemyA_endJump
    ; 重力処理
    ldy v_enemy_i + 1, x
    iny
    bne moveEnemyA_notZero
    tya
    pha
    jsr moveEnemy_newKTM ; 重力0のタイミングでカニ玉を発射
    pla
    tay
moveEnemyA_notZero:
    sty v_enemy_i + 1, x
    jmp moveEnemyA_hitCheck
moveEnemyA_endJump:
    lda #$00
    sta v_enemy_i + 0, x
    sta v_enemy_i + 1, x
    lda #$2c
    sta sp_enemyT0, x
    lda #$2e
    sta sp_enemyT1, x
    jmp moveEnemyA_hitCheck

moveEnemyA_destruct:
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
    jmp moveEnemy_next

;------------------------------------------------------------
; 敵B (カニ玉)
;------------------------------------------------------------
moveEnemyB:
    ldy v_enemy_i + 0, x
    iny
    sty v_enemy_i + 0, x
    tya
    and #$0f
    bne moveEnemyB_moveX
    ldy v_enemy_i + 1, x
    iny
    sty v_enemy_i + 1, x
moveEnemyB_moveX:
    ; 加速度が4未満の間は自機の下に来るように調整
    lda v_enemy_i + 1, x
    cmp #$04
    bcs moveEnemyB_notSpeedUp
    lda v_enemy_x, x
    adc #$04
    cmp v_playerX
    bcc moveEnemyB_toRight
    lda v_playerX
    adc #$0b
    cmp v_enemy_x, x
    bcs moveEnemyB_notSpeedUp
    ; 左へ誘導
    lda v_enemy_x, x
    sbc #$01
    sta v_enemy_x, x
    sta sp_enemyX0, x
    bne moveEnemyB_notSpeedUp
moveEnemyB_toRight:
    ; 右へ誘導
    lda v_enemy_x, x
    adc #$01
    sta v_enemy_x, x
    sta sp_enemyX0, x
moveEnemyB_notSpeedUp:
    ; 加速しながら上昇
    lda v_enemy_y, x
    clc
    sbc v_enemy_i + 1, x
    cmp #$f8
    bcc moveEnemyB_notErase
    lda #$00
    sta v_enemy_f, x
    sta sp_enemyT0, x
    sta sp_enemyY0, x
    jmp moveEnemy_next
moveEnemyB_notErase:
    sta v_enemy_y, x
    sta sp_enemyY0, x
    tay
    ; アニメーション
    lda v_counter
    and #%00000100
    ror
    clc
    adc #$7c
    sta sp_enemyT0, x
    ; #4a未満になったら水しぶきをあげる
    lda v_enemy_i + 2, x
    bne moveEnemyB_hitCheck
    tya
    cmp #$4a
    bcs moveEnemyB_hitCheck
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

    ; 自機との当たり判定 (xのみで行う)
    lda v_gameOver
    bne moveEnemyB_hitCheck
    lda v_playerX
    clc
    adc #24
    cmp v_enemy_x, x
    bcc moveEnemyB_hitCheck
    lda v_enemy_x, x
    adc #8
    cmp v_playerX
    bcc moveEnemyB_hitCheck
    jsr start_gameOver

moveEnemyB_hitCheck:
    ; ショットとの当たり判定
    lda v_shotF
    beq moveEnemyB_noHit
    lda v_shotY
    cmp v_enemy_y, x
    bcs moveEnemyB_noHit
    adc #$10
    cmp v_enemy_y, x
    bcc moveEnemyB_noHit
    lda v_shotX
    adc #$07
    cmp v_enemy_x, x
    bcc moveEnemyB_noHit
    lda v_enemy_x, x
    adc #$07
    cmp v_shotX
    bcc moveEnemyB_noHit
    jmp moveEnemyB_destruct
moveEnemyB_noHit:
    jmp moveEnemy_next
moveEnemyB_destruct:
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

    ; メダル数をインクリメント
    lda v_medal_cnt
    clc
    adc #$01
    sta v_medal_cnt

    ; 破壊カウンタをインクリメント
    lda v_dest_cnt
    adc #$01
    sta v_dest_cnt

    ; 特殊な敵追加
    and #$0f
    cmp #$08 ; 8/15のタイミングでカモメ追加を試行
    beq moveEnemyFF_addSeagull
    cmp #$0c ; 12/15のタイミングでカモメ追加を試行
    beq moveEnemyFF_addSeagull
    cmp #$0f ; 15/15のタイミングでカニ追加を試行
    beq moveEnemyFF_addClub
    bne moveEnemyFF_skipSE

moveEnemyFF_addClub:
    ; カニを追加
    tya ; yを使いたいのでスタックに退避しておく
    pha
    jsr moveEnemy_addClub
    pla
    tay
    jmp moveEnemyFF_skipSE

moveEnemyFF_addSeagull:
    ; カモメを追加
    tya ; yを使いたいのでスタックに退避しておく
    pha
    jsr moveEnemy_addSeagull
    pla
    tay

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

;------------------------------------------------------------
; うんこを発射 (xが発射元のカモメのindexでa/yを自由に使用可能)
;------------------------------------------------------------
moveEnemy_newUnk:
    ldy v_enemy_i + 2, x
    beq moveEnemy_newUnk_start
    dey
    sty v_enemy_i + 2, x
    jmp moveEnemy_next
moveEnemy_newUnk_start:
    ; 発射抑止を設定
    lda #$10
    sta v_enemy_i + 2, x
    ; インデックスを加算
    lda v_enemy_idx
    clc
    adc #$04
    and #$1f
    sta v_enemy_idx
    tay
    lda v_enemy_f, y
    beq moveEnemy_newUnk_start_ok
    jmp moveEnemy_next
moveEnemy_newUnk_start_ok:
    lda #$08
    sta v_enemy_f, y
    ; X座標 = カモメ+4
    lda v_enemy_x, x
    clc
    adc #$04
    sta v_enemy_x, y
    sta sp_enemyX0, y
    ; Y座標 = カモメ+8
    lda v_enemy_y, x
    adc #$08
    sta v_enemy_y, y
    sta sp_enemyY0, y
    ; スプライトパターン設定
    lda #$0e
    sta sp_enemyT0, y
    lda #%00100000
    sta sp_enemyA0, y
    ; play SE (矩形波2を使う)
    ;     ddcevvvv (d=duty, c=再生時間カウンタ, e=effect, v=volume)
    lda #%10111111
    sta $4004
    ;     csssmrrr (c=周波数変化, s=speed, m=method, r=range)
    lda #%11011010
    sta $4005
    ;     kkkkkkkk (k=音程周波数の下位8bit)
    lda #%01101000
    sta $4006
    ;     tttttkkk (t=再生時間, k=音程周波数の上位3bit)
    lda #%10001001
    sta $4007
    ; play SE1 (三角波を使う)
    ;     cttttttt (c=再生時間カウンタ, t=再生時間)
    lda #%00000111
    sta $4008
    ;     ssssssss (s=サンプリングレート下位8bit)
    lda #%11111111
    sta $400A
    ;     tttttsss (t=再生時間, s=サンプリングレート上位3bit)
    lda #%00001111
    sta $400B
    jmp moveEnemy_next

;------------------------------------------------------------
; カモメを追加 (方向はランダム)
;------------------------------------------------------------
moveEnemy_addSeagull:
    ; インデックスを加算
    lda v_enemy_idx
    clc
    adc #$04
    and #$1f
    sta v_enemy_idx
    tay
    lda v_enemy_f, y
    beq moveEnemy_addSeagull_ok
    rts
moveEnemy_addSeagull_ok:
    lda v_counter
    and #$01
    beq moveEnemy_addSeagull_toLeft
moveEnemy_addSeagull_toRight:
    lda #$06
    sta v_enemy_f, y
    ; X座標
    lda #$00
    sta v_enemy_x, y
    sta sp_enemyX0, y
    clc
    adc #$08
    sta sp_enemyX1, y
    ; Y座標
    lda #$12
    sta v_enemy_y, y
    sta sp_enemyY0, y
    sta sp_enemyY1, y
    ; 使用するフラグを初期化
    lda #$00
    sta v_enemy_i + 0, y
    sta v_enemy_i + 2, y
    sta sp_enemyA0, y
    sta sp_enemyA1, y
    ; スプライトパターン設定
    lda #$90
    sta sp_enemyT0, y
    lda #$94
    sta sp_enemyT1, y
    rts
moveEnemy_addSeagull_toLeft:
    lda #$07
    sta v_enemy_f, y
    ; X座標
    lda #248
    sta v_enemy_x, y
    sta sp_enemyX0, y
    clc
    adc #$08
    sta sp_enemyX1, y
    ; Y座標
    lda #$12
    sta v_enemy_y, y
    sta sp_enemyY0, y
    sta sp_enemyY1, y
    ; 使用するフラグを初期化
    lda #$00
    sta v_enemy_i + 0, y
    sta sp_enemyA0, y
    sta sp_enemyA1, y
    ; スプライトパターン設定
    lda #$a0
    sta sp_enemyT0, y
    lda #$a4
    sta sp_enemyT1, y
    rts

;------------------------------------------------------------
; カニを追加 (方向はランダム)
;------------------------------------------------------------
moveEnemy_addClub:
    ; インデックスを加算
    lda v_enemy_idx
    clc
    adc #$04
    and #$1f
    sta v_enemy_idx
    tay
    lda v_enemy_f, y
    beq moveEnemy_addClub_ok
    rts
moveEnemy_addClub_ok:
    lda v_counter
    and #$01
    beq moveEnemy_addClub_toLeft
moveEnemy_addClub_toRight:
    lda #$09
    sta v_enemy_f, y
    ; X座標
    lda #$00
    sta v_enemy_x, y
    sta sp_enemyX0, y
    clc
    adc #$08
    sta sp_enemyX1, y
    ; Y座標
    lda #208
    sta v_enemy_y, y
    sta sp_enemyY0, y
    sta sp_enemyY1, y
    ; 使用するフラグを初期化
    lda #$00
    sta v_enemy_i + 0, y
    sta v_enemy_i + 1, y
    lda #$01
    sta sp_enemyA0, y
    sta sp_enemyA1, y
    ; スプライトパターン設定
    lda #$2c
    sta sp_enemyT0, y
    lda #$2e
    sta sp_enemyT1, y
    rts
moveEnemy_addClub_toLeft:
    lda #$0a
    sta v_enemy_f, y
    ; X座標
    lda #240
    sta v_enemy_x, y
    sta sp_enemyX0, y
    clc
    adc #$08
    sta sp_enemyX1, y
    ; Y座標
    lda #208
    sta v_enemy_y, y
    sta sp_enemyY0, y
    sta sp_enemyY1, y
    ; 使用するフラグを初期化
    lda #$00
    sta v_enemy_i + 0, y
    sta v_enemy_i + 1, y
    lda #$01
    sta sp_enemyA0, y
    sta sp_enemyA1, y
    ; スプライトパターン設定
    lda #$2c
    sta sp_enemyT0, y
    lda #$2e
    sta sp_enemyT1, y
    rts

;------------------------------------------------------------
; カニ玉を発射 (xが発射元のカニのindexでa/yを自由に使用可能)
;------------------------------------------------------------
moveEnemy_newKTM:
    ; インデックスを加算
    lda v_enemy_idx
    clc
    adc #$04
    and #$1f
    sta v_enemy_idx
    tay
    lda v_enemy_f, y
    beq moveEnemy_newKTM_ok
    rts
moveEnemy_newKTM_ok:
    lda #$0b
    sta v_enemy_f, y
    ; X座標 = カニ+4
    lda v_enemy_x, x
    clc
    adc #$04
    sta v_enemy_x, y
    sta sp_enemyX0, y
    ; Y座標 = カニ-8
    lda v_enemy_y, x
    sbc #$08
    sta v_enemy_y, y
    sta sp_enemyY0, y
    ; 初期値設定
    lda #$00
    sta v_enemy_i + 0, y
    sta v_enemy_i + 1, y
    sta v_enemy_i + 2, y
    sta v_enemy_i + 3, y
    ; スプライトパターン設定
    lda #$7c
    sta sp_enemyT0, y
    lda #%00000001
    sta sp_enemyA0, y
    ; play SE (矩形波2を使う)
    ;     ddcevvvv (d=duty, c=再生時間カウンタ, e=effect, v=volume)
    lda #%11111111
    sta $4004
    ;     csssmrrr (c=周波数変化, s=speed, m=method, r=range)
    lda #%11111011
    sta $4005
    ;     kkkkkkkk (k=音程周波数の下位8bit)
    lda #%01101000
    sta $4006
    ;     tttttkkk (t=再生時間, k=音程周波数の上位3bit)
    lda #%10101001
    sta $4007
    rts
