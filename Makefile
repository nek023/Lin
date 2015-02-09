PROJECT=Lin.xcodeproj
SCHEME=LinTests

clean:
	xcodebuild \
		-project ${PROJECT} \
		clean

test:
	xcodebuild \
		-project ${PROJECT} \
		-scheme ${SCHEME} \
		-configuration Debug \
		test

