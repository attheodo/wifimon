prefix ?= /usr/local
bindir = $(prefix)/bin

build:
	swift build -c release --disable-sandbox

install: build
	install -d "$(bindir)"
	install ".build/release/wifimon" "$(bindir)"

uninstall:
	rm -rf "$(bindir)/wifimon"

clean:
	rm -rf .build