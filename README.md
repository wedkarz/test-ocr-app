# test-ocr-app

This small, sample application is to demonstrate OCR capable application.
Requirements for this app have been:
- iOS 12, Swift 5
- reading short text fragments (character strings)

To build this project you need to install dependencies via Cocoapods

`pod install` should generally help if pods are in place

Unfortunatelly Apple has made changes that without paid developer account you are not able to sign 3rd party frameworks (as of ios 13.3.1) 
[source: https://stackoverflow.com/questions/60096258/library-not-loaded-rpath-fblpromises-framework-fblpromises-ios-13-3-1/60211703#60211703]

