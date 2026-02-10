# Mini Katalog Uygulaması

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?style=flat-square&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.x-blue?style=flat-square&logo=dart)
![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20Android-green?style=flat-square)

Mini Katalog Uygulaması, Flutter ile geliştirilmiş, modern ve kullanıcı dostu bir e-ticaret katalog uygulamasıdır. Kullanıcıların ürünleri keşfetmesine, detaylarını incelemesine ve favorilerine eklemesine olanak tanır.

## 📱 Features

*   **Premium UI Design:** Jet Black & Gold teması ile şık ve modern görünüm.
*   **Advanced Navigation:** Özel sayfa geçiş animasyonları ve Named Route yapısı.
*   **Dynamic Filtering:** Kategori bazlı filtreleme ve gerçek zamanlı ürün arama.
*   **Product Detail Screen:** Hero animasyonları ile zenginleştirilmiş ürün detay sayfası.
*   **Favorites System:** Beğenilen ürünleri yerel olarak favorilere ekleme ve yönetme.
*   **Responsive Grid:** Farklı ekran boyutlarına uyumlu ürün listeleme.
*   **API Integration (Simulation & Real):** Hem yerel JSON verisi hem de `ProductsApiService` ile uzak sunucudan veri çekme altyapısı (Repository Pattern).

## 🛠 Tech Stack

*   **Flutter & Dart:** Mobile Application Development Framework
*   **State Management:** `setState` & `Repository Pattern`
*   **Assets:** Local JSON Data & Asset Management
*   **Networking:** `HttpClient` & REST API Integration
*   **Architecture:** Clean Architecture Principles

## 📂 Project Structure

Proje, temiz mimari prensiplerine uygun olarak organize edilmiştir:

```
lib/
├── config/       # API & App Configuration
├── constants/    # Colors, Strings, Styles & Helpers
├── data/         # Data Sources (JSON, API Services, Repository)
├── models/       # Data Models (Product)
├── screens/      # Application Screens (Home, List, Detail, Favorites)
└── widgets/      # Reusable UI Components (Cards, Chips, Bars)
```

## 🚀 Installation

1.  Clone the repository:
    ```bash
    git clone https://github.com/BGirginn/TNC_Mobile_Project.git
    ```
2.  Navigate to the project directory:
    ```bash
    cd TNC_Mobile_Project
    ```
3.  Install dependencies:
    ```bash
    flutter pub get
    ```
4.  Run the application:
    ```bash
    flutter run
    ```

## 📸 Screenshots

| Home Screen | Product List | Detail Screen |
|:---:|:---:|:---:|
| *(Screenshots to be added)* | *(Screenshots to be added)* | *(Screenshots to be added)* |

## 📝 License

Bu proje MIT lisansı altında lisanslanmıştır. Detaylar için `LICENSE` dosyasına bakınız.
