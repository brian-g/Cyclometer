# Cyclometer
Cyclometer is an app that utilizes Bluetooth LE (BLE) devices attached to your bicycle. It is meant to replace the old school bike computers or *cyclometers*. The current set of sensors that it will be designed to work with include:

* BLE Heart Rate monitors
* BLE Cycling cadence sensor
* BLE Cycling speed sensor
* GPS current location
* GPS speed if BLE speed sensors are not available
* GPS altitude 

The app itself does not require logins to services to work and will support simple GPX file export of ride data.

**This app is a work-in-progress.**

## Why Cyclometer
Cyclometer is designed by a biking enthusiast out of frustration for other generic apps that are more useful for running. The dashboard has clear legible text that can be seen in the sun and even when the screen is dimmed. All in all Cyclometer has the following innovative features:

* Clear and legible dashboard
* Battery saving features such as auto-dimming and adaptive GPS precision
* Automatic wheel sizing for greater precision and ease of use
* Ability to estimate distances for your routes
* No backend service means no one gets your data except for you

### Clear and legible dashboard
The design is meant to be as minimal as possible. This has the following benefits:

* Easy to read at a glance
* Battery efficient

### Battery saving features

* Dashboard minimalism
* Automatic dimming of screen
* Adaptive GPS precision

### Automatic wheel sizing
The automatic wheel sizing uses the GPS to figure out the precise size of the wheel being used. This algorithm will account for small changes in the size of the wheel due to air pressure and weight of the rider. After determine the wheel size, the GPS will be turned into adaptive mode and will only be used to track the route taken. 

The GPS is only used for speed and distance when the BLE cycling speed sensor is not available. 