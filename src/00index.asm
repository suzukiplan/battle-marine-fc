;------------------------------------------
; 各種定義
;------------------------------------------
.setcpu     "6502"
.autoimport on

; iNES header
.segment "HEADER"
    .byte   $4E, $45, $53, $1A  ; "NES" Header
    .byte   $02                 ; PRG-BANKS
    .byte   $01                 ; CHR-BANKS
    .byte   $01                 ; Vertical Mirror
    .byte   $00                 ; 
    .byte   $00, $00, $00, $00  ; 
    .byte   $00, $00, $00, $00  ; 

.segment "STARTUP"
.proc Reset
    sei
    ldx #$ff
    txs

    ; make palette table
    lda #$3f
    sta $2006
    lda #$00
    sta $2006
    ldx #$00
    ldy #$20
copy_pal:
    lda palettes, x
    sta $2007
    inx
    dey
    bne copy_pal

    ; initialize APU
    lda #%00001111
    sta $4015

.include "01title.asm"
.include "02setup.asm"
.include "03mainloop.asm"
.include "newEnemy.asm"
.include "movePlayer.asm"
.include "moveEnemy.asm"
.endproc

string_score:
    ;        12345678901234567890123456
    .byte   "SC       00    HI       00"

palettes:
    ; BG
    .byte   $0f, $00, $10, $20 ; 白色のグラデーション (mask, dark, middle, light)
    .byte   $0f, $08, $18, $28 ; 黄色のグラデーション (mask, dark, middle, light)
    .byte   $0f, $11, $2c, $16 ; 海の背景用 (mask, 海, 水面, 土)
    .byte   $00, $00, $00, $00 ; 未使用
    ; Sprite
    .byte   $0f, $00, $10, $20 ; 白色のグラデーション (mask, dark, middle, light)
    .byte   $0f, $06, $28, $20 ; 爆発 (mask, 赤, 黄, 白)
    .byte   $0f, $18, $28, $38 ; 黄色のグラデーション (mask, dark, middle, light)
    .byte   $0f, $11, $2c, $16 ; 海のスプライト用 (mask, 海, 水面, 土)

wave_table:; 並の揺れ具合 (水面のオブジェクトは皆これをY座標にすればよい)
    .byte   $42, $42, $42, $42, $42, $42, $42, $42
    .byte   $43, $43, $43, $43, $43, $43, $43, $43
    .byte   $44, $44, $44, $44, $44, $44, $44, $44
    .byte   $43, $43, $43, $43, $43, $43, $43, $43

rand_table:; 乱数テーブル
    .byte   $72,$DD,$03,$89,$C9,$86,$DB,$30,$8E,$4F,$DC,$99,$67,$54,$13,$4C
    .byte   $A3,$CA,$D8,$28,$50,$0F,$8B,$87,$6B,$B9,$10,$CF,$EC,$40,$FD,$B6
    .byte   $F3,$AF,$70,$56,$74,$CC,$47,$60,$B4,$0C,$80,$16,$D7,$79,$61,$BC
    .byte   $C8,$11,$B0,$A8,$FE,$5A,$B5,$62,$A6,$6E,$6D,$77,$CE,$32,$4D,$55
    .byte   $9E,$09,$21,$83,$9A,$F8,$E5,$BF,$8A,$BA,$2E,$4B,$EB,$9F,$D3,$36
    .byte   $CB,$07,$44,$EE,$E4,$9D,$73,$5F,$F4,$00,$1E,$78,$3A,$EA,$D1,$BD
    .byte   $A0,$D6,$C0,$3D,$66,$19,$FB,$92,$C7,$53,$7C,$D4,$98,$E7,$C4,$AC
    .byte   $7F,$7A,$93,$B8,$0A,$8C,$A2,$06,$E8,$A5,$29,$88,$BE,$CD,$0E,$DA
    .byte   $5B,$5C,$A9,$02,$7E,$EF,$ED,$D9,$E6,$F1,$3E,$05,$45,$8D,$F6,$23
    .byte   $E3,$FC,$4A,$D2,$91,$F9,$20,$C3,$04,$68,$18,$49,$2F,$94,$2C,$2B
    .byte   $01,$2D,$27,$1D,$6A,$9B,$12,$A1,$A4,$DF,$76,$6C,$64,$69,$1C,$C6
    .byte   $08,$AD,$3F,$96,$65,$C2,$38,$5D,$7B,$E2,$97,$41,$1F,$E0,$9C,$B3
    .byte   $48,$84,$51,$8F,$22,$5E,$46,$57,$31,$37,$4E,$0D,$58,$AE,$AB,$7D
    .byte   $B2,$FF,$AA,$D0,$59,$3C,$35,$26,$34,$24,$A7,$1A,$52,$15,$95,$C1
    .byte   $17,$71,$BB,$25,$82,$75,$3B,$E1,$14,$C5,$0B,$F5,$6F,$E9,$DE,$F2
    .byte   $42,$33,$43,$B1,$F0,$90,$B7,$39,$85,$D5,$81,$1B,$63,$2A,$FA,$F7

enemy_table:; 敵出現パターンテーブル
    .byte   $01,$02,$01,$02,$01,$02,$01,$02,$01,$05,$01,$05,$04,$02,$04,$02

.org $0000
v_counter:  .byte   $00     ; 00: フレームカウンタ
v_wave:     .byte   $00     ; 01: 現在の波座標
v_gameOver: .byte   $00     ; 02: ゲームオーバーフラグ
v_playerX:  .byte   $00     ; 03: player X
v_playerY:  .byte   $00     ; 04: player Y
v_fire:     .byte   $00     ; 05: ショット発射フラグ
v_shotF:    .byte   $00     ; 06: ショットフラグ
v_shotX:    .byte   $00     ; 07: ショットX
v_shotY:    .byte   $00     ; 08: ショットY
v_dust:     .byte   $00     ; 09: 粉塵フラグ
v_enemy_f:  .byte   $00     ; 0a: enemy0 - flag & type
v_enemy_x:  .byte   $00     ; 0b: enemy0 - x
v_enemy_y:  .byte   $00     ; 0c: enemy0 - y
v_enemy_si: .byte   $00     ; 0d: enemy0 - sprite index
v_enemy1:   .byte   $00, $00, $00, $00
v_enemy2:   .byte   $00, $00, $00, $00
v_enemy3:   .byte   $00, $00, $00, $00
v_enemy4:   .byte   $00, $00, $00, $00
v_enemy5:   .byte   $00, $00, $00, $00
v_enemy6:   .byte   $00, $00, $00, $00
v_enemy7:   .byte   $00, $00, $00, $00
v_enemy_i:  .byte   $00, $00, $00, $00
v_enemy1_i: .byte   $00, $00, $00, $00
v_enemy2_i: .byte   $00, $00, $00, $00
v_enemy3_i: .byte   $00, $00, $00, $00
v_enemy4_i: .byte   $00, $00, $00, $00
v_enemy5_i: .byte   $00, $00, $00, $00
v_enemy6_i: .byte   $00, $00, $00, $00
v_enemy7_i: .byte   $00, $00, $00, $00
v_rand_idx: .byte   $00     ; 4a: 乱数index
v_enemy_idx:.byte   $00     ; 4b: 敵index
v_work:     .byte   $00, $00, $00, $00 ; 4c-4f: 汎用ワーク変数
v_sb_exist: .byte   $00, $00, $00, $00, $00, $00, $00, $00 ; 50-57: 潜水艦のY座標重複防止フラグ
v_et_idx:   .byte   $00     ; 58: 敵テーブルのインデックス
v_push:     .byte   $00     ; 59: ボタン押し込みフラグ
v_dustE:    .byte   $00     ; 5a: 敵ショットの水しぶき

.org $0300
sp_playerY: .byte   $00                 ; 00 - player0
sp_playerT: .byte   $00
sp_playerA: .byte   $00
sp_playerX: .byte   $00
sp_player1: .byte   $00, $00, $00, $00  ; 01 - player1
sp_player2: .byte   $00, $00, $00, $00  ; 02 - player2
sp_shotY:   .byte   $00                 ; 03 - player shot
sp_shotT:   .byte   $00
sp_shotA:   .byte   $00
sp_shotX:   .byte   $00
sp_dustY:   .byte   $00                 ; 04 - dust0 (player shot)
sp_dustT:   .byte   $00
sp_dustA:   .byte   $00
sp_dustX:   .byte   $00
            .byte   $00, $00, $00, $00
sp_dustEY:  .byte   $00                 ; 05 - dust1 (enemy shot)
sp_dustET:  .byte   $00
sp_dustEA:  .byte   $00
sp_dustEX:  .byte   $00
            .byte   $00, $00, $00, $00
sp_enemyY0:  .byte  $00                 ; 06 - enemy0(0)
sp_enemyT0:  .byte  $00
sp_enemyA0:  .byte  $00
sp_enemyX0:  .byte  $00
sp_enemy1_0:.byte   $00, $00, $00, $00  ; 07 - enemy1(0)
sp_enemy2_0:.byte   $00, $00, $00, $00  ; 08 - enemy2(0)
sp_enemy3_0:.byte   $00, $00, $00, $00  ; 09 - enemy3(0)
sp_enemy4_0:.byte   $00, $00, $00, $00  ; 0a - enemy4(0)
sp_enemy5_0:.byte   $00, $00, $00, $00  ; 0b - enemy5(0)
sp_enemy6_0:.byte   $00, $00, $00, $00  ; 0c - enemy6(0)
sp_enemy7_0:.byte   $00, $00, $00, $00  ; 0d - enemy7(0)
sp_enemyY1: .byte   $00                 ; 0e - enemy0(1)
sp_enemyT1: .byte   $00
sp_enemyA1: .byte   $00
sp_enemyX1: .byte   $00
            .byte   $00, $00, $00, $00  ; 0f - enemy1(1)
            .byte   $00, $00, $00, $00  ; 10 - enemy2(1)
            .byte   $00, $00, $00, $00  ; 11 - enemy3(1)
            .byte   $00, $00, $00, $00  ; 12 - enemy4(1)
            .byte   $00, $00, $00, $00  ; 13 - enemy5(1)
            .byte   $00, $00, $00, $00  ; 14 - enemy6(1)
            .byte   $00, $00, $00, $00  ; 15 - enemy7(1)
sp_enemyY2: .byte   $00                 ; 16 - enemy0(2)
sp_enemyT2: .byte   $00
sp_enemyA2: .byte   $00
sp_enemyX2: .byte   $00
            .byte   $00, $00, $00, $00  ; 17 - enemy0(2)
            .byte   $00, $00, $00, $00  ; 18 - enemy2(2)
            .byte   $00, $00, $00, $00  ; 19 - enemy3(2)
            .byte   $00, $00, $00, $00  ; 1a - enemy4(2)
            .byte   $00, $00, $00, $00  ; 1b - enemy5(2)
            .byte   $00, $00, $00, $00  ; 1c - enemy6(2)
            .byte   $00, $00, $00, $00  ; 1d - enemy7(2)

.segment "VECINFO"
    .word   $0000
    .word   Reset
    .word   $0000

; pattern table
.segment "CHARS"
    .incbin "bmarine-sprite.chr"
    .incbin "bmarine-bg.chr"
