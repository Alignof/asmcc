CFLAGS	:= -std=c11 -g -O0 -static -Wall 
LDFLAGS := -static

TARGET  := ./asmcc
SRCDIR  := ./src
OBJDIR  := ./src/obj
SOURCES := $(wildcard ./src/*.s)
OBJECTS := $(addprefix $(OBJDIR)/, $(notdir $(SOURCES:.s=.o)))

$(TARGET): $(OBJECTS)
	$(CC) -o $@ $^ $(LDFLAGS)

$(OBJDIR)/%.o: $(SRCDIR)/%.s 
	@[ -d $(OBJDIR) ]
	$(CC) $(CFLAGS) $(INCLUDE) -o $@ -c $<


install: $(OBJECTS)
	$(CC) -O2 -o $(TARGET) $^ $(LDFLAGS)

test:
	./test.sh

clean:
	rm -f cc_sakura *.o *~ tmp* *.txt *.out child* gen*
	rm -f $(OBJECTS) $(TARGET)

.PHONY: test clean install
