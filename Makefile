.PHONY: install generate setup clean clean-submodule-changes module

install:
	mise exec -- tuist install

generate:
	mise exec -- tuist generate

setup: install generate

clean:
	tuist clean
	rm -rf Derived
	rm -rf Projects/*/Derived
	rm -rf Projects/*/*/Derived
	rm -rf Scripts/GenerateModule/.build
	$(MAKE) clean-submodule-changes
	find . -name '*.xcodeproj' -type d -prune -exec rm -rf {} +
	find . -name '*.xcworkspace' -type d -prune -exec rm -rf {} +

clean-submodule-changes:
	swift run --package-path Scripts/GenerateModule clean-generated-module-changes

module:
	swift run --package-path Scripts/GenerateModule generate-module
