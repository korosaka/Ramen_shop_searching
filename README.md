# [App Store](https://apps.apple.com/ca/app/worldwide-ramen-map/id1551605247#?platform=iphone)
# About
![Screen shots](https://github.com/korosaka/source_image/blob/main/ramen_map/ramen_map_screenshots.png)
Worldwide Ramen Map is a mobile iOS application to search Ramen shops with the map. Users can also create a request to add new Ramen shop to this app. The info of this app will be created by users!

# Why I created this app
One of my hobbies is going to Ramen shops where I have never visit. Moreover I wanted to create a iOS app with GoogleMap and Firebase. This is why I decided to create this app. I'm glad if this app is useful for Ramen-Manias all over the world!

# UI Design
![UI Design](https://github.com/korosaka/source_image/blob/main/ramen_map/all_ui_design.png)
# Demo Movie
# Language and Libraries
- Swift
- SwiftUI
- GoogleMaps SDK
- UserNotification
- CoreLocation
- Firebase(Authentication, Firestore, Storage)
- QGrid

# Architecture
![Architecture_Design](https://github.com/korosaka/source_image/blob/main/ramen_map/Architecture_design.png)
## Front End
This app is utilizing MVVM pattern because this pattern can be suitable for SwiftUI which doesn't need ViewController. 
Moreover,since this pattern is getting more popular, this experience will help me in future. 
## Database & Storage
This app is utilizing Firebase services to authenticate users and store data and pictures. 
Because of it, I could easily create core functions such as Login, Reviewing a shop and store pictures.
## Push Notification
To send notifications to users, this app is utilizing Firebase Cloud Messaging. When a particular event is happened, this app send API request to FCM server and some users will receive the Push Notification.
# Current Features
- Sing In/Sign Out/Sign Up
- Set profile name, icon
- Show shops' locations on map
- Show a shop info(Evaluation/Reviews/Images)
- Review a shop
- Bookmark a shop
- Send a request to add new shop
- Cancel a request
- Review users' requests (admin only)
