DEVICE     = atmega328p
CLOCK      = 8000000
PROGRAMMER = avrisp2
FUSES      = -U lfuse:w:0xe2:m -U hfuse:w:0xd9:m -U efuse:w:0xff:m
FILENAME   = main
SRC        = $(wildcard src/*.c)
OBJECTS    = $(patsubst src/%.c, src/%.o, $(SRC))


AVRDUDE = avrdude -c $(PROGRAMMER) -p $(DEVICE)
COMPILE = avr-gcc $(CFLAGS) $(WARNINGS) -DF_CPU=$(CLOCK) -mmcu=$(DEVICE)
CFLAGS = -Os -flto -mrelax -std=gnu11 -ffreestanding
WARNINGS = -Wparentheses -Wall -Wextra -Wuninitialized -Wmaybe-uninitialized

all:	main.hex

.c.o:
	$(COMPILE) -c $< -o $@

.S.o:
	$(COMPILE) -x assembler-with-cpp -c $< -o $@

.c.s:
	$(COMPILE) -S $< -o $@

flash:	main.hex
	$(AVRDUDE) -U flash:w:main.hex:i

fuse:
	$(AVRDUDE) $(FUSES)

clean:
	rm -f main.hex main.elf $(OBJECTS)

main.elf: $(OBJECTS)
	$(COMPILE) -o main.elf $(OBJECTS)

main.hex: main.elf
	@rm -f main.hex
	avr-objcopy -j .text -j .data -O ihex main.elf main.hex
	avr-size --format=avr --mcu=$(DEVICE) main.elf

disasm:	main.elf
	@avr-objdump -d main.elf

cpp:
	$(COMPILE) -E main.c

