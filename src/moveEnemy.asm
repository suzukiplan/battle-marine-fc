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
    jmp moveEnemy2
moveEnemy_next:
    txa
    clc
    adc #$08
    and #$3f
    bne moveEnemy_loop
    rts

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
    beq moveEnemyh1_noHit
    lda v_shotY
    cmp v_enemy_y, x
    bcs moveEnemyh1_noHit
    adc #$10
    cmp v_enemy_y, x
    bcc moveEnemyh1_noHit
    lda v_shotX
    adc #$07
    cmp v_enemy_x, x
    bcc moveEnemyh1_noHit
    lda v_enemy_x, x
    adc #$17
    cmp v_shotX
    bcc moveEnemyh1_noHit
    ; TODO: 爆発
    lda #$00
    sta v_shotF
    sta sp_shotT
    sta sp_shotY
moveEnemy1_erase:
    ldy v_enemy_si, x
    lda #$00
    sta v_enemy_f, x
    sta sp_enemyT, y
    sta sp_enemyT + 4, y
    sta sp_enemyT + 8, y
    ldy v_enemy_i1, x
    sta v_sb_exist, y
moveEnemyh1_noHit:
    jmp moveEnemy_next

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
    beq moveEnemyh2_noHit
    lda v_shotY
    cmp v_enemy_y, x
    bcs moveEnemyh2_noHit
    adc #$10
    cmp v_enemy_y, x
    bcc moveEnemyh2_noHit
    lda v_shotX
    adc #$07
    cmp v_enemy_x, x
    bcc moveEnemyh2_noHit
    lda v_enemy_x, x
    adc #$17
    cmp v_shotX
    bcc moveEnemyh2_noHit
    ; TODO: 爆発
    lda #$00
    sta v_shotF
    sta sp_shotT
    sta sp_shotY
moveEnemy2_erase:
    ldy v_enemy_si, x
    lda #$00
    sta v_enemy_f, x
    sta sp_enemyT, y
    sta sp_enemyT + 4, y
    sta sp_enemyT + 8, y
    ldy v_enemy_i1, x
    sta v_sb_exist, y
moveEnemyh2_noHit:
    jmp moveEnemy_next
