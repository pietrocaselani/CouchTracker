fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
## iOS
### ios setup_certs
```
fastlane ios setup_certs
```
Setup Certificates
### ios tests
```
fastlane ios tests
```
Run CouchTrackerCore tests
### ios lint
```
fastlane ios lint
```
Run tests and linters
### ios upload_sonar
```
fastlane ios upload_sonar
```
Run tests and linters then upload metrics to sonar
### ios beta
```
fastlane ios beta
```
Release a new build

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
