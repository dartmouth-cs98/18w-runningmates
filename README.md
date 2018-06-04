# RunningMates Front End
### Design
![swiping](swiping.gif)

![emergency contacts](ec.gif)

![edit profile](editProf.gif)

![chat](chat.gif)

### Project Description
RunningMates is a mobile application that utilizes Strava's API to compile personal fitness data to connect individuals looking for new connections with others who share their passions for running. This application uses state-of-art data analytic techniques to provide users with the best recommendations of other runners in their area, based on their skill levels and preferences. This repository contains the front end solution for the app. The front end is written in swift on XCode.


With RunningMates, users can send requests to make connections with other users in their area. If two users request to match with each other, RunningMates connects them through a chat, through which they can plan to meet up to run together.  

In addition to their name and age, users can choose to display information to potential matches such as a profile picture a bio, number of miles they run a week, and number of times they run a week. This information can be updated through the Settings page, which is linked through the Dashboard. Users can link their Strava accounts if they sign up; if they do, information about their running statistics will automatically be synced with their profile.  

Additionally, users can update preferences regarding the types of users they would like to connect with. These preferences include gender, age, proximity, number of runs each week, and average weekly mileage. RunningMates takes these preferences into account in order to display the best potential matches possible to each user.


### Dependencies

Dependencies are managed by cocoa pods.
To install cocoa pods:
`$sudo gem install cocoapods`

## Setup

* Git clone this repo into your local directory.
* Run `$pod install`
* Run `$open RunningMates.xcworkspace`
* Run the project on any iPhone simulator


## Deployment


## Authors
* Brian Francis
* Jonathan Gonzalez
* Divya Kalidindi
* Sara Topic
* Drew Waterman
* Shea Wojciehowski

## Acknowledgments
* The team acknowledges Tim Tregubov.
