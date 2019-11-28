
CC = gcc
CFLAGS = -c

AS = nasm
ASFLAGS = -f elf64

OBJECTS = euler.o function.o
LD = gcc

TARGET = euler

%.o : %.c
	$(CC) $(CFLAGS) $< -o $@

%.o : %.asm
	$(AS) $(ASFLAGS) $< -o $@
  
all: $(OBJECTS)
	$(LD) -no-pie $^ -o $(TARGET)

clean:
	rm $(TARGET) $(OBJECTS)

