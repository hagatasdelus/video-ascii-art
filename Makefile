TARGET = ascii_video_generator
SCRIPT = MakefileDiver.sh
ZIPDIR = ~/tmp

.PHONY: all clean run test install open zip

all: $(SCRIPT)
	sh ./$(SCRIPT)

clean: $(SCRIPT)
	sh ./$(SCRIPT) clean

run: $(SCRIPT)
	sh ./$(SCRIPT) run

test: $(SCRIPT)
	sh ./$(SCRIPT) test

install: $(SCRIPT)
	sh ./$(SCRIPT) install

open: $(SCRIPT)
	sh ./$(SCRIPT) open

zip: clean
	@rm -f -r $(ZIPDIR)/$(TARGET).zip $(ZIPDIR)/$(TARGET)
	@mkdir -p $(ZIPDIR)/$(TARGET)
	cp -p -r ascii_video_generator.cpp Makefile $(SCRIPT) $(ZIPDIR)/$(TARGET)/
	(cd $(ZIPDIR) ; zip -r ./$(TARGET).zip ./$(TARGET)/)
	(mv $(ZIPDIR)/$(TARGET).zip .. ; rm -f -r $(ZIPDIR)/$(TARGET))
	@echo created zip file: ../$(TARGET).zip
