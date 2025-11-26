## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

***

# 📱 flutter_calculator_namphuong
## Basic Calculator Application with Dark Mode Interface (Flutter/Dart)

This project is a mobile calculator application developed using Flutter and Dart. It features a prominent **Dark Mode** interface designed to accurately emulate the appearance of a modern calculator application on mobile devices.

---

## 📸 Application Screenshots

<div align="center">

<img src="screenshot\monitor_main.png" alt="Screenshot of the calculator application with dark mode interface" width="100"/>
<img src="screenshot\addition.png" alt="Addition operation" width="100"/>
<img src="screenshot\subtraction.png" alt="Subtraction operation" width="100"/>
<img src="screenshot\multiplication.png" alt="Multiplication operation" width="100"/>
<img src="screenshot\decimal_division.png" alt="Division operation" width="100"/>
<img src="screenshot\error.png" alt="Error state" width="100"/>
<img src="screenshot\negative_subtraction.png" alt="Negative subtraction operation" width="100"/>
<img src="screenshot\parentheses.png" alt="Parentheses usage" width="100"/>
</div>

---
## 📸 New Application Screenshots
<img src="screenshot\New_basic.png" width="100"/>
<img src="screenshot\New_scientific.png" width="100"/>
<img src="screenshot\New_darkmode.png" width="100"/>
<img src="screenshot\New_history.png" width="100"/>
<img src="screenshot\New_setting.png" width="100"/>

---
## ⚙️ How to Run the Project

To run this project on your machine, you need to have the Flutter SDK installed.

### Prerequisites

* **Flutter SDK:** The latest stable version.
* **Device/Emulator:** A configured Android or iOS device/emulator, or web browser.
* **IDE:** Visual Studio Code (VS Code) or Android Studio.

### Step-by-Step Instructions

1.  **Clone the Repository:** Download the project to your local machine using Git.
    ```bash
    git clone [https://github.com/phuongprox/flutter_caculator_namphuong.git](https://github.com/phuongprox/flutter_caculator_namphuong.git)
    ```

2.  **Navigate to the Project Directory:**
    ```bash
    cd flutter_caculator_namphuong
    ```

3.  **Get Dependencies:** Download the necessary packages.
    ```bash
    flutter pub get
    ```

4.  **Run the Application:** Launch the application on your connected device or emulator.
    ```bash
    flutter run
    ```
    *Alternatively, use the **Run/Debug** option in your IDE (VS Code/Android Studio).*

---

## ✨ Key Features

The project was developed focusing on accurate UI emulation while integrating all the essential functionalities of a standard calculator.

### User Interface (UI) Features

* **Standard Dark Mode:** Dark-themed interface with deep gray and black tones, accurately mimicking the original image design.
* **4x5 Layout:** Uses a `GridView` or `Column`/`Row` structure to ensure perfect alignment of the buttons.
* **Distinct Button Design:**
    * The **'C'** (Clear) button features a Dark Red color.
    * Basic operator buttons (**+, -, ×, ÷**) use a Dark Olive Green tone.
    * The **'='** (Equals) button is highlighted in a vibrant Dark Green.

### Functional (Logic) Features

* **Basic Arithmetic Operations:** Supports Addition (`+`), Subtraction (`-`), Multiplication (`×`), and Division (`÷`).
* **Clear Functionality:** The **'C'** button clears the entire expression.
* **Advanced Features:** Supports **Percentage** (`%`) calculation, **Sign Change** (`+/-`), and **Parentheses** (`()`) usage.

🚀 Advanced Features Update
This project has been upgraded from a basic calculator to a professional scientific tool. The core changes focus on introducing advanced mathematical logic, complex state management, and full UI responsiveness.

### Functionality & Logic Upgrades
The following features were successfully added and tested:
* Mode Switching: Introduced full support for Scientific Mode with a dynamic 6-column layout.
* Scientific Functions: Implemented robust handling for trigonometric ($\sin$, $\cos$, $\tan$), logarithmic ($\ln$, $\log$), power, and root functions, including support for constants ($\pi$, $e$).
* Expression Parsing: The calculation core was refactored to handle complex, multi-level expressions, ensuring correct operator precedence (PEMDAS) and parenthesis nesting.
* Angle Mode: Added user-controlled switching between Degrees (DEG) and Radians (RAD) for accurate scientific calculations.
* Memory Functions: Full implementation of M+, M-, MR, and MC memory management capabilities.
### UI/UX and System Architecture
* Persistent History: Calculation history is now stored and retrieved using shared_preferences, persisting the last 50 calculations across sessions.
* Provider State Management: The entire application logic was migrated to the Provider pattern, separating concerns into dedicated CalculatorProvider, ThemeProvider, and HistoryProvider services.
* Dynamic Theming: The application now supports persistent Dark/Light Theme switching based on user settings.
* Responsive UI Refactoring: The button grid logic was refactored to dynamically switch and correctly render both the 4-column (Basic) and the complex 6-column (Scientific) layouts without visual overlap or shifting.
* Comprehensive Testing: Implemented extensive Unit Tests and Integration Tests to guarantee calculation accuracy and system stability.
