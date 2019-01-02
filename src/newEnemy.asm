sub_newEnemy:
    ; 敵のパターン情報を取得（追加されなくてもテーブルを回すことで出現に変化をつける）
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
    adc #$04
    and #$1f
    sta v_enemy_idx
    tax
    ; フラグが0でなければ出現をキャンセル
    lda v_enemy_f, x
    beq newEnemy_ok
    rts
newEnemy_ok:
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
    sta sp_enemyX0, x
    clc
    adc #$08
    sta sp_enemyX1, x
    adc #$08
    sta sp_enemyX2, x
    ; Y座標をランダムで決定
    ldy v_rand_idx
    iny
    sty v_rand_idx
    lda rand_table, y
    and #$07
    cmp #$00
    beq newEnemy1_cancel ; 最上位は鳥専用ゾーンなのでキャンセル
    cmp #$07
    beq newEnemy1_cancel ; 最下位は蟹専用ゾーンなのでキャンセル
    sta v_work + 1
    tay
    lda v_sb_exist, y
    beq newEnemy1_ok
    ; 同じY座標に既に潜水艦（か魚）が居るので登場をキャンセル
newEnemy1_cancel:
    lda #$00
    sta v_enemy_f, x
    rts
newEnemy1_ok:
    lda #$01
    sta v_sb_exist, y
    ; y = 深度(1~7) * 16(4shift) + $60
    lda v_work + 1
    rol
    rol
    rol
    rol
    clc
    adc #$60
    sta v_enemy_y, x
    sta sp_enemyY0, x
    sta sp_enemyY1, x
    sta sp_enemyY2, x
    ; i1 に 深度(1~7) を記憶しておく
    lda v_work + 1
    sta v_enemy_i + 1, x
    lda #$20
    sta sp_enemyT0, x
    lda #$28
    sta sp_enemyT1, x
    lda #$2a
    sta sp_enemyT2, x
    lda #$00
    sta sp_enemyA0, x
    sta sp_enemyA1, x
    sta sp_enemyA2, x
    sta v_enemy_i + 0, x
    sta v_enemy_i + 2, x
    sta v_enemy_i + 3, x
    rts

;------------------------------------------------------------
; 敵2 (左方向へ動く潜水艦)
;------------------------------------------------------------
newEnemy2:
    sta v_enemy_f, x
    lda #232
    sta v_enemy_x, x
    sta sp_enemyX0, x
    clc
    adc #$08
    sta sp_enemyX1, x
    adc #$08
    sta sp_enemyX2, x
    ; Y座標をランダムで決定
    ldy v_rand_idx
    iny
    sty v_rand_idx
    lda rand_table, y
    and #$07
    cmp #$00
    beq newEnemy2_cancel ; 最上位は鳥専用ゾーンなのでキャンセル
    cmp #$07
    beq newEnemy2_cancel ; 最下位は蟹専用ゾーンなのでキャンセル
    sta v_work + 1
    tay
    lda v_sb_exist, y
    beq newEnemy2_ok
    ; 同じY座標に既に潜水艦（か魚）が居るので登場をキャンセル
newEnemy2_cancel:
    lda #$00
    sta v_enemy_f, x
    rts
newEnemy2_ok:
    lda #$01
    sta v_sb_exist, y
    ; y = 深度(1~7) * 16(4shift) + $60
    lda v_work + 1
    rol
    rol
    rol
    rol
    clc
    adc #$60
    sta v_enemy_y, x
    sta sp_enemyY0, x
    sta sp_enemyY1, x
    sta sp_enemyY2, x
    ; i1 に 深度(1~7) を記憶しておく
    lda v_work + 1
    sta v_enemy_i + 1, x
    lda #$3a
    sta sp_enemyT0, x
    lda #$38
    sta sp_enemyT1, x
    lda #$30
    sta sp_enemyT2, x
    lda #$00
    sta sp_enemyA0, x
    sta sp_enemyA1, x
    sta sp_enemyA2, x
    sta v_enemy_i + 0, x
    sta v_enemy_i + 2, x
    sta v_enemy_i + 3, x
    rts
