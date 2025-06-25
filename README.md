# Cryptocurrency Tracker

**Overview**

This repository contains the source code for the Crypto Tracker, an iOS app that lets users monitor their favorite cryptocurrencies. It provides features like:

*   Searching for cryptocurrencies by name or symbol
*   Viewing and tracking real-time cryptocurrency prices
*   Managing a personalized favorites list for quick access
*   Accessing detailed 24-hour statistics for any selected cryptocurrency

**Features**

*   **Search:** Quickly find cryptocurrencies with real-time updates while you type.
*   **Real-Time Prices:** View live cryptocurrency prices, symbols, daily changes, and add/remove favorites directly from the list. Auto-updates every 30 seconds.
*   **Favorites:** Keep track of frequently viewed cryptocurrencies. Favorites persist across sessions using Core Data.
*   **Details:** Dive deeper with comprehensive 24-hour statistics: current price, daily highs and lows, price changes, trading volume, and activity.

**Setup Instructions**

**Prerequisites:**

*   Xcode 16.2 
*   iOS 17.0 or later

**Steps to Get Started:**

1.  Clone the repository:

    ```bash
    git clone https://github.com/mahmoudfarag94/CryptoCurrencyTracking.git
    ```

2.  Open the project in Xcode:

    ```bash
    open Crypto Tracking.xcodeproj
    ```

3.  Build and run:

    *   add netfox as a package dependency to your Xcode project from https://github.com/kasketis/netfox.
    *   Select a simulator or connected device in Xcode.
    *   Press the Run button to launch the app.

4.  Run unit tests (optional):

    *   Execute tests by pressing Command + U in Xcode.


**Technical Details**

*   **Design Philosophy**
    *   Reusability: Base classes and components for less code duplication.
    *   Scalability: Modular architecture for future expansion.
    *   SOLID Principles: Clean separation of responsibilities for better maintenance.
*   **Architecture**
    *   Clean Architecture:
        *   Data Layer: Local storage (Core Data) and network communication (URLSession).
        *   Domain Layer: Business logic in Use Cases (e.g., fetching prices, managing favorites).
        *   Presentation Layer: View Models control app state and logic. SwiftUI Views render UI based on the view model's state.
        *   Coordinator: Manages navigation across screens.
*   **Reusability**
    *   `BaseViewModel`: Manages view states and provides standardized error/success handling.
    *   `BaseCryptoViewModel`: Extends `BaseViewModel` with specific cryptocurrency tracking functionality (updates favorites, observes changes).
    *   `CryptoListView`: A reusable SwiftUI component for displaying a list of cryptocurrencies (configurable for search results, real-time prices, or favorites).
*   **Screens**
    *   Tabs: Search, Real-Time Prices, Favorites.
    *   Details Screen: Detailed 24-hour information fetched using the `/id/ticker24h` API endpoint.

**Advantages**

*   Reusability: Base classes and components promote consistency and reduce code.
*   Scalability: Decoupled architecture allows independent layer evolution.
*   Maintainability: Clean Architecture and SOLID principles minimize technical debt.
