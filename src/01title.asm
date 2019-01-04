;------------------------------------------
; タイトル画面
;------------------------------------------
title:
    ; Screen off
    lda #$00
    sta $2000
    sta $2001

    ; 3 page
    lda #$00
    ldx #$00
title_clear_ram3:
    sta $0300, x
    inx
    bne title_clear_ram3

    ; 属性テーブルを初期化
    lda #$23
    sta $2006
    lda #$c0
    sta $2006
    lda #$ff
    ldx #$40
title_attr_setup:
    sta $2007
    dex
    bne title_attr_setup

    ; ネームテーブルを初期化
    lda #$20
    sta $2006
    lda #$00
    sta $2006
    lda #$00
    ldy #$1E
title_name_setup1:
    ldx #$20
title_name_setup2:
    sta $2007
    dex
    bne title_name_setup2
    dey
    bne title_name_setup1

    ; スコアを描画
    jsr draw_score

    ; draw title (BATTLE)
    lda #$20
    sta $2006
    lda #$80
    sta $2006
    ldy #$00
    ldx #$a0
title_tile_loop1:
    lda title_tile1, y
    sta $2007
    iny
    dex
    bne title_tile_loop1

    ; draw title (MARINE)
    lda #$21
    sta $2006
    lda #$40
    sta $2006
    ldy #$00
    ldx #$a0
title_tile_loop2:
    lda title_tile2, y
    sta $2007
    iny
    dex
    bne title_tile_loop2

    lda #$22
    sta $2006
    lda #$0b
    sta $2006
    ldy #$00
    ldx #$0a
draw_title_kaisen:
    lda string_kaisen, y
    sta $2007
    iny
    dex
    bne draw_title_kaisen

    lda #$22
    sta $2006
    lda #$ab
    sta $2006
    ldy #$00
    ldx #$0a
draw_title_push_start:
    lda string_push_start, y
    sta $2007
    iny
    dex
    bne draw_title_push_start

    lda #$23
    sta $2006
    lda #$46
    sta $2006
    ldy #$00
    ldx #$14
draw_title_copyright:
    lda string_copyright, y
    sta $2007
    iny
    dex
    bne draw_title_copyright

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
    lda #%00011000
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

    lda #$00
    sta v_push_start
title_loop:
    ; カウンタをインクリメントしておく
    lda v_push_start
    clc
    adc #$01
    and #$1f
    sta v_push_start

    ; clear joy-pad
    lda #$01
    sta $4016
    lda #$00
    sta $4016
    lda $4016   ; A
    lda $4016   ; B 
    lda $4016   ; SELECT
    lda $4016   ; START
    and #$01
    beq title_wait_vBlank
    jmp title_end
title_wait_vBlank:
    lda $2002
    bpl title_wait_vBlank ; wait for vBlank
    lda #$3
    sta $4014
    jmp title_loop
title_end:
