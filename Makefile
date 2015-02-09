clean:
	xcodebuild \
		-project Lin.xcodeproj \
		clean

test:
	xcodebuild \
		-project Lin.xcodeproj \
		-scheme LinTests \
		-configuration Debug \
		test

