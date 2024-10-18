PROGRAM = AsciiVideoGenerator
TARGET  = $(shell echo $(PROGRAM) | tr "[:upper:]" "[:lower:]")
INSTDIR = $(PROGRAM).app/Contents/Resources/
ARCHIVE = $(shell basename `pwd`)
CXX     = g++
CXXFLAGS = -std=c++20 $(shell pkg-config --cflags opencv4)
LIBS    = $(shell pkg-config --libs opencv4) -pthread
CCTEMPS = *.o *.s *.i *.bc
REPORTS = StaticAnalyzerReports
# CHECKER = scan-build --use-analyzer=`which $(CXX)` --view -o $(REPORTS)

MODULES = \
	$(PROGRAM)

SOURCES = $(shell for each in `echo $(MODULES)` ; do echo $${each}.cpp ; done)
OBJECTS = $(shell for each in `echo $(MODULES)` ; do echo $${each}.o ; done)

HEADERS = \

.PHONY: all clean test install zip wipe format #lint

all: $(TARGET)
	@:

$(TARGET): $(OBJECTS)
	$(CXX) -o $@ $(OBJECTS) $(LIBS)

%.o: %.cpp $(HEADERS)
	$(CXX) $(CXXFLAGS) -c $< -o $@

clean:
	@for each in `ls $(TARGET) $(CCTEMPS) 2> /dev/null` ; do echo "rm -f $${each}" ; rm -f $${each} ; done
	@if [ -e $(INSTDIR) ] ; then echo "rm -f -r $(INSTDIR)" ; rm -f -r $(INSTDIR) ; fi

test: $(TARGET)
	@if ls video.mp4 1> /dev/null 2>&1; then \
		./$(TARGET); \
	else \
		echo "Error: video*.mp4 not found in the current directory."; \
		exit 1; \
	fi

install: $(TARGET)
	@if [ ! -e $(INSTDIR) ] ; then echo "mkdir -p $(INSTDIR)" ; mkdir -p $(INSTDIR) ; fi
	cp -p $(TARGET) $(INSTDIR)

zip: clean wipe
	(cd ../ ; zip -r ./$(ARCHIVE).zip ./$(ARCHIVE)/)

# lint: clean
# 	$(CHECKER) make

wipe:
	@if [ -e $(REPORTS) ] ; then echo "rm -f -r $(REPORTS)" ; rm -f -r $(REPORTS) ; fi

format:
	@for each in $(HEADERS) $(SOURCES) ; do echo "/*** $${each} ***/" ; clang-format -style=file $${each} ; echo ; done
