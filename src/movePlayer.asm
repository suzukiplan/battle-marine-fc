sub_movePlayer:
    ; プレイヤをプカつかせる
    lda v_wave
    sta v_playerY
    sta sp_playerY
    sta sp_playerY + 4
    sta sp_playerY + 8

    lda $4016   ; A
    and #$01
    sta v_fire
    lda $4016   ; B 
    and #$01
    ora v_fire
    bne movePlayer_fire
    lda #$00
    sta v_push
    jmp movePlayer_noFire
movePlayer_fire:
    ; ショットを発射
    lda v_push
    bne movePlayer_noFire
    lda #$01
    sta v_push
    lda v_shotF
    bne movePlayer_noFire ; 発射中（連射不可）
    lda #$01
    sta v_shotF
    lda sp_playerX + 4
    sta v_shotX
    sta sp_shotX
    lda v_playerY
    clc
    adc #$0f
    sta v_shotY
    sta sp_shotY
    lda #$08
    sta sp_shotT

    ; play SE (矩形波1を使う)
    ;     ddcevvvv (d=duty, c=再生時間カウンタ, e=effect, v=volume)
    lda #%00111111
    sta $4000
    ;     csssmrrr (c=周波数変化, s=speed, m=method, r=range)
    lda #%11010010
    sta $4001
    ;     kkkkkkkk (k=音程周波数の下位8bit)
    lda #%01101000
    sta $4002
    ;     tttttkkk (t=再生時間, k=音程周波数の上位3bit)
    lda #%10001001
    sta $4003
movePlayer_noFire:

    lda $4016   ; SELECT
    lda $4016   ; START
    lda $4016   ; UP
    lda $4016   ; DOWN
    lda $4016   ; LEFT
    and #$01
    bne movePlayer_left
    lda $4016   ; RIGHT
    and #$01
    bne movePlayer_right
    rts

movePlayer_left:
    lda v_playerX
    cmp #$09
    bcc movePlayer_noMove
    clc
    adc #$fe
    sta v_playerX
    sta sp_playerX
    clc
    adc #$08
    sta sp_playerX + 4
    adc #$08
    sta sp_playerX + 8
movePlayer_noMove:
    rts

movePlayer_right:
    lda v_playerX
    cmp #$e0
    bcs movePlayer_noMove
    clc
    adc #$02
    sta v_playerX
    sta sp_playerX
    adc #$08
    sta sp_playerX + 4
    adc #$08
    sta sp_playerX + 8
    rts
