# GitRepD
GitRepD is a GitHub repository app that lets you browse through user repositories and save some information about them on your device. 

## Technologies and architecture
GitRepD is based on **iOS 15** and __Swift 5.5__ using __XCode 13.0 beta 5__. The app is **entirely native**, making it free from external dependencies and more reliable in terms of faster updates, bug fixes and future design changes.

The architecture of the app is __VIPER__ with few twists due to the **SwiftUI** nature. For example, the data model or the Entities (which is the most inner layer in clean architecture) needs to be tightly coupled with the persistence (which sits in the most outer layer). This does break the rule of clean architecture where the inner layer should know nothing about the outer layer. This is so because VIPER doesn’t translate well to SwiftUI, so some compromises had to be made.

__Combine__, __CoreData__ and __async/await__ functions has also been used.

## App Specification
The app starts off with 2-tab bars. One for repository searches and another for browsing through favorites (saved repositories). After the user searches for a repository and upon selecting one by tapping, a detailed screen appears that displays more information about the selected item (image, repository name, date created, language used, description and a URL with an option to follow it upon tap). The user can save the selected repository either by tapping on the star button at the detail screen or simply by swiping from the leading edge to the trailing from the search screen. The delete action is the same but from the other direction (if in database). The aforementioned is applicable to the favorites screen, except for the star button at the detail view.

The search screen is paginated and fetches up to 10 results at a time upon scroll to the end of the list. Alert messages and **haptic feedback** depending on the context has also been provided.

## Requirements
XCode 13 or newer.

## Installation
No external libraries are needed for installation because the entire app is built with native technologies from Apple.

What is worth to mention is that upon cloning the project, you may want to clean the build folder before initial build because the app might crash due to CoreData. In order to do that you need to go to:

__Xcode 13__ (or newer) -> Product (from the menu bar at the top) -> Clean Build Folder

Alternatively, the cmd + shift + k key combination should do the trick.

Also, if you have an older version of the app installed, you should delete it and re-install before launching the new version because the app might crash due to the older version of the CoreData database if there are any changes to the database context.

## Known issues
The empty search view’s arrow pointing to the search bar is set statically and does not accommodate the screen size of the bigger iPhone models.

The VIPER architecture is not entirely abided to, especially regarding the persistence due to a bug in SwiftUI’s @Environment wrapper. This issue, forces us to pass the database context from the view to the interactor or else it won’t work.

Due to the current design of the pagination algorithm, an alert regarding an empty query is not possible.

## Planned changes/additions
Dynamic adjustment of the position of the moving arrow pointing to the search bar at the empty search view.

To include a star button at the detail screen of the favorites/saved repositories.

To include an empty search view in the favorites/saved repositories section.

To move the database context from the views to their respective interactors upon a fix from Apple is provided.

Improve the pagination algorithm so the user could be notified of an empty query from the server.

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[MIT](https://choosealicense.com/licenses/mit/)
