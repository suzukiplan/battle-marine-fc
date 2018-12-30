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

.include "01title.asm"
.include "02setup.asm"
.include "03mainloop.asm"
.endproc

palettes:
    ; BG
    .byte   $0f, $00, $10, $20 ; 白色のグラデーション (mask, dark, middle, light)
    .byte   $0f, $08, $18, $28 ; 黄色のグラデーション (mask, dark, middle, light)
    .byte   $0f, $11, $2c, $16 ; 海の背景用 (mask, 海, 水面, 土)
    .byte   $00, $00, $00, $00 ; 未使用
    ; Sprite
    .byte   $0f, $00, $10, $20 ; 白色のグラデーション (mask, dark, middle, light)
    .byte   $00, $00, $00, $00 ; 未使用
    .byte   $00, $00, $00, $00 ; 未使用
    .byte   $00, $00, $00, $00 ; 未使用

playerY_table:
    .byte   $42, $42, $42, $42, $42, $42, $42, $42
    .byte   $43, $43, $43, $43, $43, $43, $43, $43
    .byte   $44, $44, $44, $44, $44, $44, $44, $44
    .byte   $43, $43, $43, $43, $43, $43, $43, $43

.org $0000
v_counter:  .byte   $00     ; 00: フレームカウンタ
v_playerX:  .byte   $00     ; 01: player X
v_playerY:  .byte   $00     ; 02: player Y

.org $0300
sp_playerY: .byte   $00                 ; 00 - player0
sp_playerT: .byte   $00
sp_playerA: .byte   $00
sp_playerX: .byte   $00
sp_player1: .byte   $00, $00, $00, $00  ; 01 - player1
sp_player2: .byte   $00, $00, $00, $00  ; 02 - player2

.segment "VECINFO"
    .word   $0000
    .word   Reset
    .word   $0000

; pattern table
.segment "CHARS"
    .incbin "bmarine-sprite.chr"
    .incbin "bmarine-bg.chr"
