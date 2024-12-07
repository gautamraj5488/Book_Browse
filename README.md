# **Book Browse: Book Discovery Application**

Book Browse is a Flutter-based mobile application that allows users to browse and search for books. The app fetches data from an API and provides functionalities such as searching, filtering, and displaying books with information like title, author, and bookshelves. It also integrates caching to improve performance and offer a seamless experience, even when offline.

## **Features:**
- **Search Functionality:** 
  - Search for books based on title, author, and bookshelf.
  - Displays search suggestions and filtering options as the user types.
  - Real-time search results are shown as users input their queries.
- **Infinite Scrolling:**
  - Fetches additional books as the user scrolls down the page.
  - Data is loaded incrementally to enhance performance and minimize wait times.
- **Caching with Flutter Cache Manager:** 
  - Utilizes caching to store books' data, reducing the number of API calls.
  - If cached data is available, it is displayed to the user, improving app load times.
  - Refreshes data from the API when necessary, ensuring content stays up to date.
- **Book Details Screen:**
  - Displays detailed information about each book, such as its title, author, genre, and cover image.
- **Responsive Design:** 
  - Optimized for various mobile screen sizes, ensuring a smooth experience on phones and tablets.
  - Grid layout used for book display, providing an organized view of the books.
  - App bar with search functionality that remains visible even when the keyboard is active.

---

## **Setup Instructions:**

### **1. Clone the Repository:**
Clone the project to your local machine using the following command:

```bash
git clone https://github.com/gautamraj5488/Book_Browse
```

### **2. Install Dependencies:**
Navigate to the project directory and install the necessary dependencies by running:

```bash
cd book-browse
flutter pub get
```

### **3. Run the App:**
To run the application on your device or emulator, use:

```bash
flutter run
```

---

## **Project Structure:**

- `lib/`: Contains all the source code for the application.
  - `models/`: Contains data models, including `Book` model.
  - `services/`: API service classes for fetching book data from the backend.
  - `screens/`: UI code for different screens in the app, such as `BookListScreen` and `BookDetailScreen`.
  - `widgets/`: Custom reusable widgets, such as `WaveDotsWidget` and `ImageWithPlaceholder`.

---

## **Key Widgets and Screens:**

- **BookListScreen:**
  - Displays a list of books, implemented with infinite scrolling and search filtering.
  
- **BookDetailScreen:**
  - Shows detailed information about a specific book, such as a summary, author details, and related books.

- **BookSearchDelegate:**
  - Custom widget that handles search functionality, enabling users to search for books by title, author, and bookshelves.

- **WaveDotsWidget:**
  - A custom loading widget that displays an animation of dots moving in a wave-like pattern while data is being fetched.

- **ImageWithPlaceholder:**
  - Displays book images with a placeholder that’s shown while the image is loading. This ensures smooth visual transitions.

---

## **Caching:**
- The app uses the `flutter_cache_manager` package to cache the books' data, improving both app speed and offline access.
- Cached data is retrieved when available, reducing the need for repetitive API calls.
- Cached data is updated periodically to ensure that the user always sees the most recent content.

---

## **Contributing:**
If you'd like to contribute to this project, please fork the repository and create a pull request with your changes. We encourage contributions to improve the app's functionality, UI, and performance. All contributions are welcome!

---

## **License:**
This project is open-source and available under the MIT License. See the [LICENSE](https://pointerpointer.com/) file for more details.

---

## **Acknowledgements:**
- The app fetches book data using an API service integrated into the app.
- Built with Flutter and Dart for efficient mobile development.
- Special thanks to [Flutter Cache Manager](https://pub.dev/packages/flutter_cache_manager) for providing a reliable caching solution.
