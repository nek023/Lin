test:
	xcodebuild \
		-project Lin.xcodeproj \
		-sdk macosx \
		-scheme LinTests \
		-configuration Debug \
		clean test

