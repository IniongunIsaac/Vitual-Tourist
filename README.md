# Vitual-Tourist
An iPhone app that downloads and stores images from Flickr. The app allows users to drop pins on a map, as if they were stops on a tour. Users will then be able to download pictures for the location and persist both the pictures, and the association of the pictures with the pin.

## Core Technology:

* Offline persistence using Core Data.
* Network Requests with URLSession.
* MapKit
* UICollectionView

### How to run(installation):

* Clone this repository.
* Cd into the root directory.
* Run `pod install` (you may need to install Cocoapods if you do not already have it installed. See `https://cocoapods.org/` for installation guide.)
* Open `xcworkspace` project using Xcode.
* Build and run the project on the XCode Simulator or any physically connected iOS device.

### Note:

The application was built using:

* XCode 11.3.1
* iOS 13.2 SDK
* Swift 5.1
* macOS Catalina 10.15.1

### Screenshots
![Travel Locations Map Screen](https://github.com/IniongunIsaac/Vitual-Tourist/blob/master/Virtual%20Tourist/Screenshots/travel_locations_map_screen.png)
![Photo Album Screen](https://github.com/IniongunIsaac/Vitual-Tourist/blob/master/Virtual%20Tourist/Screenshots/photo_album_screen.png)
