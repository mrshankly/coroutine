.DEFAULT_GOAL = all

DEPDIR := .dependencies
DEP    := $(addprefix $(DEPDIR)/,$(subst /,-,$(OBJ:.o=.dep)))

TARGET := $(if $(MCU),-mmcu=$(MCU),)

CFLAGS  += -std=c11 -pedantic -Wall -Wextra
CFLAGS  += -MMD -MP -MF $(DEPDIR)/$(subst /,-,$*).dep
ASFLAGS += -mN -mY
ASFLAGS += -MP -MD $(DEPDIR)/$(subst /,-,$*).dep

.SUFFIXES:
.SECONDARY:
.PHONY: all debug clean

all: CFLAGS += -Os
all: LDFLAGS += -s
all: $(BIN) $(LIB)

debug: CFLAGS += -O0 -g
debug: ASFLAGS += -g
debug: $(BIN) $(LIB)

clean:
	rm -f $(BIN) $(LIB) $(OBJ)
	rm -rf $(DEPDIR)

$(BIN): $(OBJ)
	$(CC) $(TARGET) -minrt -o $@ $^ $(LDFLAGS)

$(LIB): $(OBJ)
	$(AR) rcs $@ $^

%.o: %.c $(DEPDIR)/sentinel
	$(CC) $(TARGET) -c $(CFLAGS) -o $@ $<

%.o: %.s $(DEPDIR)/sentinel
	$(AS) $(TARGET) $(ASFLAGS) -o $@ $<

$(DEPDIR)/sentinel:
	@mkdir -p $(@D)
	@touch $@

-include $(DEP)
