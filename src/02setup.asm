;------------------------------------------
; ゲーム開始前の初期化処理
;------------------------------------------
setup:
    ; Screen off
    lda #$00
    sta $2000
    sta $2001

    ; zero page ($00〜$7fのみクリア ※$80〜$ffは永続値なのでクリアしない)
    lda #$00
    ldx #$00
    ldy #$80
setup_clear_ram0:
    sta $0000, x
    inx
    dey
    bne setup_clear_ram0

    lda #$00
    ldx #$00
setup_clear_ram:
    sta $0100, x
    sta $0200, x
    sta $0300, x
    sta $0400, x
    sta $0500, x
    sta $0600, x
    sta $0700, x
    inx
    bne setup_clear_ram

    ; GET READYタイマーを設定
    lda #$80
    sta v_ready_timer

    ; プレイヤの座標初期化
    lda #$74
    sta v_playerX
    sta sp_playerX
    clc
    adc #$08
    sta sp_playerX + 4
    clc
    adc #$08
    sta sp_playerX + 8
    lda wave_table
    sta v_playerY
    sta sp_playerY
    sta sp_playerY + 4
    sta sp_playerY + 8
    lda #$02
    sta sp_playerT
    lda #$04
    sta sp_playerT + 4
    lda #$06
    sta sp_playerT + 8
    ;     VHP---CC
    lda #%00100000
    sta sp_playerA
    sta sp_playerA + 4
    sta sp_playerA + 8

    ; 属性テーブルを初期化
    lda #$23
    sta $2006
    lda #$c0
    sta $2006

    lda #%01010000
    ldx #$10
setup_attr_table1:
    sta $2007
    dex
    bne setup_attr_table1

    lda #%10101010
    ldx #$30
setup_attr_table2:
    sta $2007
    dex
    bne setup_attr_table2

    ; ネームテーブルを初期化
    lda #$20
    sta $2006
    lda #$00
    sta $2006

    ; 空を描画
    ldx #$20
    lda #$00
setup_draw_bg1_1:
    ldy #$0a
setup_draw_bg1_2:
    sta $2007
    dey
    bne setup_draw_bg1_2
    dex
    bne setup_draw_bg1_1

    ; 海面を描画
    ldx #$20
    lda #$0a
setup_draw_bg2:
    sta $2007
    dex
    bne setup_draw_bg2

    ; 海中を描画
    lda #$0b
    ldx #$11
setup_draw_bg3_1:
    ldy #$20
setup_draw_bg3_2:
    sta $2007
    dey
    bne setup_draw_bg3_2
    dex
    bne setup_draw_bg3_1

    ; 地表を描画
    ldx #$10
setup_draw_bg4:
    lda #$0c
    sta $2007
    lda #$0d
    sta $2007
    dex
    bne setup_draw_bg4
    ; 地中を描画
    ldx #$10
setup_draw_bg5:
    lda #$0e
    sta $2007
    lda #$0f
    sta $2007
    dex
    bne setup_draw_bg5

    ; スコアを描画
    jsr draw_score

    ; scroll setting
    lda #$00
    sta $2005
    sta $2005

    ; screen on
    ; bit7: nmi interrupt
    ; bit6: PPU type (0=master, 1=slave)
    ; bit5: size of sprite (0=8x8, 1=8x16)
    ; bit4: BG chr table (0=$0000, 1=$1000)
    ; bit3: sprite chr table (0=$0000, 1=$1000)
    ; bit2: address addition (0=+1, 1=+32)
    ; bit1~0: main screen (0=$2000, 1=$2400, 2=$2800, 3=$2c00)
    ;     76543210
    lda #%00110000
    sta $2000
    ; bit7: red
    ; bit6: green
    ; bit5: blue
    ; bit4: sprite
    ; bit3: BG
    ; bit2: visible left-top 8x sprite
    ; bit1: visible left-top 8x BG
    ; bit0: color (0=full, 1=mono)
    lda #%00011110
    sta $2001
