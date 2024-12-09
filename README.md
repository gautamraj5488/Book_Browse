# **Book Browse: Book Discovery Application**

Book Browse is a Flutter-based mobile application that allows users to browse and search for books. The app fetches data from an API and provides functionalities such as searching, filtering, and displaying books with information like title, author, and bookshelves. It also integrates caching to improve performance and offer a seamless experience, even when offline.

---

## **Features**
- **Search Functionality:** 
  - Search for books by title, author, or bookshelf.
  - Displays dynamic search suggestions and real-time filtering as the user types.
  - Optimized for accuracy and responsiveness.

- **Infinite Scrolling:** 
  - Dynamically loads more books as the user scrolls.
  - Efficient data handling ensures smooth and responsive performance.

- **Caching with Flutter Cache Manager:** 
  - Reduces redundant API calls by storing book data locally.
  - Provides offline access to previously viewed content.

- **Responsive Design:**
  - Ensures compatibility with various device sizes.
  - The grid layout displays book thumbnails neatly for better accessibility.

- **Book Details Screen:**
  - Shows book-specific information, such as the title, author, genre, and more.

- **Issue Reporting:**
  - Shake the device to report an issue.
  - A dialog appears where users can describe their issue.
  - If the message is left empty, an error message is displayed asking to "Write your issue."

---

## **Code Structure**

The project follows a clean and modular code structure, adhering to the best practices of Flutter development. Here's a brief overview:

### **Project Directories**
- **`lib/`:** Main source code folder.
  - **`models/`:** 
    - Contains classes to define data models (e.g., `Book`).
    - These models map API responses into Flutter-friendly structures.
  - **`services/`:** 
    - Houses service classes responsible for API interactions.
    - Includes methods for fetching book data and handling errors.
  - **`screens/`:** 
    - Includes different UI screens such as:
      - `BookListScreen`: Displays a scrollable list of books with filters.
      - `BookDetailScreen`: Shows detailed information for selected books.
      - `SplashScreen`: The first screen of the app, showing the logo.
  - **`widgets/`:** 
    - Custom widgets for reusable UI components:
      - `BookCard`: Displays a single book with its details.
      - `ErrorMessage`: Display error messages.
      - `LoadingIndicator`: Display loading indicator when waiting for data.
      - `WaveDotsWidget`: A wave animation used for loading indicators.
      - `ImageWithPlaceholder`: Smoothly transitions between placeholder and loaded images.
      - `ShimmerWidget`: Enhances user experience with shimmer effects.
  - **`utils/`:**
    - Contains utility files for constants, themes, and helper functions.
    - **`shake_manager.dart`**: Handles shake detection for reporting issues.

---

## **Key Design Decisions**
- **Separation of Concerns:**
  - Each folder in the `lib/` directory has a specific responsibility, ensuring scalability and readability.

- **Responsive and Adaptive UI:**
  - The app uses media queries and layout builders to ensure compatibility with different screen sizes.
  - Provides an optimal viewing experience on both small and large screens.

- **Custom Widgets:**
  - Reusable widgets like `WaveDotsWidget` and `ImageWithPlaceholder` improve code modularity.
  - These components add to the aesthetic and functional appeal of the app.

- **Caching:** 
  - Offline-first design improves usability and reduces the need for continuous API calls.

---

## **Setup Instructions**

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/gautamraj5488/Book_Browse.git
   ```

2. **Install Dependencies:**
   ```bash
   cd book-browse
   flutter pub get
   ```

3. **Run the App:**
   ```bash
   flutter run
   ```

---

## **How It Works**
1. **Fetching Data:**
   - The `services/` directory handles all API interactions. Data is fetched and stored in models defined in the `models/` directory.

2. **Displaying Books:**
   - The `screens/BookListScreen` displays books in a grid layout. Infinite scrolling loads additional books as users navigate through the app.

3. **Search:**
   - You can search books by the title, author, or bookshelf.

4. **Offline Mode:**
   - Cached data is retrieved using the `flutter_cache_manager` package, reducing API usage and improving app performance.

5. **Issue Reporting:**
   - Users can shake the device to trigger the issue reporting dialog.
   - The dialog requests a description of the issue. If the input is empty, a "Write something here" error message is shown to prompt the user to fill in the message.

---

## **Contribution Guidelines**

We welcome contributions to enhance the app’s features or fix issues. Please:
1. Fork the repository.
2. Commit your changes.
3. Submit a pull request with a detailed description of the update.

---

## **License**
This project is licensed under the MIT License.

---