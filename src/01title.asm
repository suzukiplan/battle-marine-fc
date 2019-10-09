;------------------------------------------
; タイトル画面
;------------------------------------------
title:
    ; Screen off
    lda #$00
    sta $2000
    sta $2001

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
    lda #$8c
    sta $2006
    ldy #$00
    ldx #$08
draw_1player:
    lda string_1player, y
    sta $2007
    iny
    dex
    bne draw_1player

    lda #$22
    sta $2006
    lda #$cc
    sta $2006
    ldy #$00
    ldx #$09
draw_2players:
    lda string_2players, y
    sta $2007
    iny
    dex
    bne draw_2players

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
    jsr title_draw_cursor
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

title_loop:
    lda $2002
    bpl title_loop ; wait for vBlank
    ; clear joy-pad
    lda #$01
    sta $4016
    lda #$00
    sta $4016
    lda $4016   ; A
    lda $4016   ; B 
    lda $4016   ; SELECT
    and #$01
    beq title_loop2
    lda v_play_mode_s
    bne title_loop2_1
    jsr title_change_play_mode
    jmp title_loop2_1
title_loop2:
    lda #$00
    sta v_play_mode_s
title_loop2_1:
    lda $4016   ; START
    and #$01
    beq title_loop3
    jmp title_end
title_loop3:
    lda #$3
    sta $4014
    ; scroll setting
    lda #$00
    sta $2005
    sta $2005
    jmp title_loop

title_draw_cursor:
    ldx v_play_mode
    beq title_draw_cursor_1P
    jmp title_draw_cursor_2P
title_draw_cursor_1P:
    ; 1 PLAYER
    lda #$22
    sta $2006
    lda #$8b
    sta $2006
    lda #$3E
    sta $2007
    ; 2 PLAYERS
    lda #$22
    sta $2006
    lda #$cb
    sta $2006
    lda #$00
    sta $2007
    rts
title_draw_cursor_2P:
    ; 1 PLAYER
    lda #$22
    sta $2006
    lda #$8b
    sta $2006
    lda #$00
    sta $2007
    ; 2 PLAYERS
    lda #$22
    sta $2006
    lda #$cb
    sta $2006
    lda #$3E
    sta $2007
    rts

title_change_play_mode:
    lda #$01
    sta v_play_mode_s
    lda v_play_mode
    beq title_change_play_mode_2P
    lda #$00
    sta v_play_mode
    jsr title_draw_cursor
    rts
title_change_play_mode_2P:
    lda #$01
    sta v_play_mode
    jsr title_draw_cursor
    rts

title_end:
    ; scroll setting
    lda #$00
    sta $2005
    sta $2005
title_end_wait:
    lda $2002
    bpl title_end_wait ; wait for vBlank

