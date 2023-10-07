## Flutter Reddit Clone Application
### This application is a Flutter clone of Reddit, using Firebase, Firestore, and Firebase Storage. It includes the following features:

- Login and signup with Google or as a guest
- Create and join communities
- View, upvote, downvote, and comment on posts
- Share text, link, or image based posts
- Award posts
- Delete posts
- Toggle between dark and light mode
- Responsive design for Android, iOS, and web
- Getting Started

### To get started, you will need to:

- Clone this repository.
- Create a Firebase project and enable Authentication (Google Sign In, Guest Sign In) and Firestore.
- Create Android, iOS, and web apps in your Firebase project.
- Use the FlutterFire CLI to add the Firebase project to your app.
- Run the following commands to run your app:
- flutter pub get
- flutter run
### Using the App
- Once the app is running, you can log in or sign up with Google or as a guest. Once logged in, you can browse the list of communities or create your own. To view the posts in a community, simply tap on the community name.

- To upvote or downvote a post, tap on the up or down arrow icons. To comment on a post, tap on the comment icon and enter your comment. To share a post, tap on the share icon and select the method you want to share it with.

- To award a post, tap on the award icon and select the award you want to give. To delete a post, tap on the three dots icon in the top right corner of the post and select "Delete".

### Configuring the App
You can configure the app by opening the pubspec.yaml file and editing the firebase_options section. You will need to replace the YOUR_API_KEY and YOUR_PROJECT_ID placeholders with your own Firebase API key and project ID.

You can also configure the app's appearance by opening the themes/app_theme.dart file and editing the colors and fonts.

## Contributing
If you would like to contribute to this project, please feel free to fork the repository and submit a pull request. All contributions are welcome!

