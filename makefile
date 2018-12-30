IMAGES = bmarine-sprite.chr bmarine-bg.chr
SOURCES = \
	src/03mainloop.asm\
	src/02setup.asm\
	src/01title.asm\
	src/00index.asm

all: bmarine.nes
	open bmarine.nes

bmarine.nes: $(IMAGES) bmarine.o
	ld65 -o bmarine.nes --config memory-map.cfg --obj bmarine.o

bmarine-sprite.chr: bmarine-sprite.bmp
	bmp2chr bmarine-sprite.bmp bmarine-sprite.chr

bmarine-bg.chr: bmarine-bg.bmp
	bmp2chr bmarine-bg.bmp bmarine-bg.chr

bmarine.o: $(SOURCES)
	cl65 -t none -o bmarine.o -c src/00index.asm

clean:
	@rm -rf *.chr
	@rm -rf *.o
	@rm -rf *.nes
