# **Book Browse: Book Discovery Application**

Book Browse is a Flutter-based mobile application that allows users to browse and search for books. The app fetches data from an API and provides functionalities such as searching, filtering, and displaying books with information like title, author, and bookshelves. It also integrates caching to improve performance.

## **Features:**
- **Search Functionality:** 
  - Search for books based on title, author, and bookshelf.
  - Suggestions and filtering are displayed as the user types.
  - Displays relevant results as users search for books.
- **Infinite Scrolling:**
  - Fetches more books as the user scrolls down the page.
  - Loads data incrementally to improve user experience.
- **Caching with Flutter Cache Manager:** 
  - Caches books data for better performance and offline access.
  - Fetches cached data when available and refreshes from the API when needed.
- **Book Details Screen:**
  - Displays detailed information about each book, including its title, author, and image.
- **Responsive Design:** 
  - Optimized for mobile screens with a grid layout for book display.
  - App bar with search functionality that doesn’t hide content when the keyboard is visible.

---

## **Setup Instructions:**

### **1. Clone the Repository:**
Clone the project to your local machine using the following command:

```bash
git clone https://github.com/your-repository/book-browse.git
```

### **2. Install Dependencies:**
Navigate to the project directory and install the necessary dependencies:

```bash
cd book-browse
flutter pub get
```

### **3. Run the App:**
To run the application on your device or simulator/emulator, use the following command:

```bash
flutter run
```

---

## **Project Structure:**

- `lib/`: Contains all the source code for the application.
  - `models/`: Contains data models for books.
  - `services/`: Contains API service classes for fetching data from the backend.
  - `screens/`: Contains the UI for different screens in the app like `BookListScreen` and `BookDetailScreen`.
  - `widgets/`: Contains reusable custom widgets, such as `WaveDotsWidget` and `ImageWithPlaceholder`.

---

## **Key Widgets and Screens:**

- **BookListScreen:**
  - Displays the list of books.
  - Implements infinite scrolling and filtering based on search queries.
  
- **BookDetailScreen:**
  - Displays detailed information about a specific book when clicked.

- **BookSearchDelegate:**
  - Implements custom search functionality allowing users to search for books by title, author, or bookshelves.

- **WaveDotsWidget:**
  - Custom widget used for showing loading animation while fetching data.

- **ImageWithPlaceholder:**
  - A custom widget to display book images with a placeholder while the image is loading.

---

## **Caching:**
- The app uses the `flutter_cache_manager` package to cache the book data for better performance.
- Cached data is fetched if available, reducing the number of API calls and speeding up the app.
- The cached data is refreshed periodically to ensure the most up-to-date content is displayed.

---

## **Contributing:**
If you'd like to contribute to this project, please fork the repository and create a pull request with your changes. We encourage contributions to improve the app's functionality, UI, and performance.

---

## **License:**
This project is open-source and available under the MIT License. See the [LICENSE](https://pointerpointer.com/) file for more details.

---

## **Acknowledgements:**
- The app fetches book data using the API service integrated into the app.
- Uses Flutter and Dart for mobile development.
- Special thanks to [Flutter Cache Manager](https://pub.dev/packages/flutter_cache_manager) for their amazing tool.

