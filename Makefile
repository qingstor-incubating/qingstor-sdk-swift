SHELL := /bin/bash

help:
	@echo "Please use \`make <target>\` where <target> is one of"
	@echo "  all        to update, generate, build, unit and test this SDK"
	@echo "  update     to update git submodules"
	@echo "  generate   to generate service code from snips"
	@echo "  build      to compile this SDK"
	@echo "  unit       to run unit test"
	@echo "  test       to run service test"

all: update generate build unit test

update: 
	git submodule update --init
	@echo "ok"

generate:
	@if [[ ! -f "$$(which snips)" ]]; then \
		echo "ERROR: Command \"snips\" not found."; \
	fi

	snips -f="./specs/qingstor/2016-01-06/swagger/api_v2.0.json" -t="./template" -o="./Sources/QingStor"
	snips -f="./specs/qingstor/2016-01-06/swagger/api_v2.0.json" -t="./template/objc-bridge" -o="./Sources/ObjcBridge"

	rm ./Sources/QingStor/Object.swift
	rm ./Sources/ObjcBridge/ObjectObjcBridge.swift

	swiftlint autocorrect
	@echo "ok"

lint: 
	swiftlint autocorrect

build:
	pod install
	xcodebuild -workspace QingStorSDK.xcworkspace -scheme "QingStorSDK" -destination 'platform=iOS Simulator,name=iPhone 7' build | xcpretty

unit:
	pod install
	xcodebuild -workspace QingStorSDK.xcworkspace -scheme "QingStorSDKTests" -destination 'platform=iOS Simulator,name=iPhone 7' test | xcpretty

test:
	pod install
	xcodebuild -workspace QingStorSDK.xcworkspace -scheme "QingStorSDKFeatureTests" -destination 'platform=iOS Simulator,name=iPhone 7' test | xcpretty
