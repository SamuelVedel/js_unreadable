SRC_DIR := src
OUT_DIR := bin

SRCS := $(wildcard $(SRC_DIR)/*/*/*/*.java)
#CLS := $(SRCS:$(SRC_DIR)/%.java=$(OUT_DIR)/%.class)

JC := javac
JCFLAGS := -d $(OUT_DIR)/ -cp $(SRC_DIR):$(VC_PATH)

.SUFFIXES: .java .class

.PHONY: all clean build run

all: build #run

build: .done

run:
	java -cp $(VC_PATH):$(OUT_DIR) fr.svedel.unreadable.Main $(JARGS)

$(OUT_DIR)/%.class: $(SRC_DIR)/%.java
	$(JC) $(JCFLAGS) $<

.done: $(SRCS)
	$(JC) $(JCFLAGS) $?
	touch .done

clean:
	rm -rf $(OUT_DIR)
	rm -f .done
	rm -f *~ $(SRC_DIR)/*/*/*/*~
