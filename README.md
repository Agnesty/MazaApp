# 📱 MazaApp

**MazaApp** is an iOS application built with **UIKit (Swift)** as part of my personal portfolio.  
This project demonstrates my skills in **modular architecture, API integration, data management**, and creating an **intuitive, interactive user experience** in iOS development.  

---

## ✨ Key Features

### 🔑 Authentication
- Sign In & Sign Up functionality using **Realm** for user storage.  
- **UserDefaults** used for login state persistence.  
- Fully **reactive** data handling with **RxSwift**.  

### 🏠 Home Page
- Displays products from a **local Mockoon API** using **RxSwift**.  
- **Search feature** with search history stored in **SQLite**.  
- Planned **infinite scroll** implementation:  
  - Initial display: 5 products  
  - Load more: 5 products per scroll, up to 50 items  
- ⚠️ **Note:** To fetch data correctly, you need to run the included **Mockoon response file**. Without it, no data will appear in the app.  

### 📊 Trending Page
- Fetches and displays dynamic data from **local Mockoon API** using **Combine**.  
- Users can **favorite products**, saved using **CoreData**.  
- Reactive updates ensure UI stays in sync with data.  
- ⚠️ **Note:** Requires the **Mockoon response file** to be running locally for data to appear.  

### 🎥 Live Video Page
- Streams popular videos via **Pexels API** with a TikTok-style interface.  
- Built using **RxSwift** for reactive data handling.  
- Still under development, improvements ongoing.  

### 🐱 Pokemon Page
- Integrates **Pokemon API** using **RxSwift**.  
- Supports **search**, planned **infinite scroll** and **filtering**.  
- Demonstrates reactive API data fetching and display.  

### ⚙️ Profile Page
- Displays user data stored in **Realm** during Sign Up.  
- Supports **Log Out** functionality.  

---

## 🛠️ Technologies Used

- **Language:** Swift  
- **UI Framework:** UIKit  
- **Architecture:** MVVM  
- **Reactive Programming:** RxSwift & Combine  
- **Persistence:** Realm, CoreData, UserDefaults, SQLite  
- **Layout:** SnapKit  
- **API Integration:** Pexels API, Pokemon API, Mockoon local API  

---

## 🗂 Mockoon API
- The project uses a **local Mockoon API** for HomePage and TrendingPage.  
- To run the API:  
  1. Open **Mockoon** app.  
  2. Import the provided file: `Mockoon/MazaApp_Products.json`.  
  3. Start the local server on **localhost:3002**.  
- Without running this local API, **no data will appear** in the app. 

---

## 🔒 API Keys

The file **Config.plist** is not included in the repository due to sensitive information.  
To run the project:  

1. Create a **Config.plist** file in the **Resources/** folder.  
2. Add your API keys (e.g., Pexels API).  

**Example Config.plist format:**  

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>PexelsAPIKey</key>
    <string>YOUR_API_KEY_HERE</string>
</dict>
</plist>
