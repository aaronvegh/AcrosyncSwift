# AcrosyncSwift

This is an iOS framework for using the [Acrosync Library](https://github.com/gilbertchen/acrosync-library), an implementation of the Rsync protocol available with a mixed RPL/commercial license.

### What it does
AcrosyncSwift is an iOS framework that you can include in your app, which will allow you to use the features of [Rsync](https://rsync.samba.org) programmatically. Because it relies on Acrosync, it's available under a different open source license, as well as commercially. 

The framework is written in Objective-C++ in order to interface with the underlying C++ code. However, this work is readily available to Swift developers; the included `AcrosyncSwiftExample` project demonstrates an implementation written in Swift 5.

### Features

* Allows connections to Rsync running on remote servers via SSH or the Rsync Daemon
* For Rsyncd connections, supports syncing based on modules, using username/password authentication
* For SSH connections, supports password auth as well as private key authentication. You should really use SSH with private keys.
* Control the speed of the connection in upload or download
* Perform uploads and downloads
* Includes progress monitoring and a callack for completing the operation


### Installation

*Via [Cocoapods](https://cocoapods.org):*
(Sorry, not currently working; I can't get my Podfile to lint.)

`pod install 'AcrosyncSwift'`

*Manually:*

1. Clone the repo and open the `AcrosyncSwift.xcodeproj` file
2. Build/Archive the `AcrosyncSwift` build target.
3. Grab the `AcrosyncSwift.framework` out of the Build Products, and drag it into your project's `Frameworks` folder.
4. There is no step 4!

### Usage

Run the `AcrosyncSwiftExample` app in your simulator. It implements a simple form to test the features of the framework. The source code provides an implementation of `AcrosyncWrapper.swift` that should get you going.

### License
The underlying Acrosync library is licensed under the Reciprocal Public License. If this license does not work for you, a commercial license is available for a one-time fee or on a subscription basis. Contact [software2015@acrosync.com](mailto:software2015@acrosync.com) for licensing details.

The code in this repository, outside of the underlying Acrosync library, is released in the public domain.

### Improvements, PRs Welcome!