
# Project Blueprint: Tradición Lojana Delivery App

## Overview

This document outlines the plan for developing a Flutter application for "Tradición Lojana," a food delivery service. The app will feature a menu, categories, and an ordering system.

## Style and Design

*   **Colors:** The primary color will be a vibrant yellow (`#FFC107`), with a light gray for the background (`#F5F5F5`).
*   **Typography:** We will use the `google_fonts` package to use the 'Poppins' font for a modern and clean look.
*   **Iconography:** The app will use Material Design icons.
*   **Layout:** The layout will be a single-column scrollable view with a bottom navigation bar.

## Features

### Implemented Features

*   **Splash Screen:**
    *   **UI:** A dedicated splash screen (`lib/splash_screen.dart`) with a background image, the restaurant's logo, name, and slogan.
    *   **Navigation:** Buttons to navigate to a "Tutorial" (not yet implemented) and to the main application (`/home`).
    *   **Routing:** The main application file (`lib/main.dart`) is configured to show the splash screen as the initial route.
*   **Home Screen:**
    *   **Custom App Bar:** A yellow, curved app bar with the restaurant's logo, name ("Tradición Lojana"), and slogan ("Como comer en casa").
    *   **Category Filter:** A horizontal scrolling list of food categories (Snacks, Mariscos, Pizzas, etc.) with icons.
    *   **Menu List:** A vertical list of food items, each displayed in a card with:
        *   An image of the food item.
        *   The name of the item (e.g., "Hamburguesa especial").
        *   Estimated preparation time.
        *   Price.
        *   A "Pedir" (Order) button that navigates to the Detail Screen.
    *   **Bottom Navigation Bar:** A navigation bar with icons for "Home", "Menu", "Orders", and "Search".
*   **Detail Screen:**
    *   **UI:** A dedicated screen (`lib/detail_screen.dart`) that displays the details of a selected food item.
    *   **Content:** Shows the item's image, name, price, and estimated preparation time.
    *   **Interaction:** Includes a text field for adding "Observaciones" (Observations) and a final "Pedir" button.
    *   **Navigation:** The screen is accessed by tapping the "Pedir" button on a menu item from the home screen.
*   **Dynamic Category Filtering:**
    *   **Data Model:** A `FoodItem` class structures the menu item data.
    *   **Mock Data:** A list of `FoodItem` objects serves as a mock database.
    *   **State Management:** The app tracks the selected category and updates the UI accordingly.

### Future Features

*   Tutorial Screen
*   Shopping Cart
*   User Authentication
*   Order Tracking
