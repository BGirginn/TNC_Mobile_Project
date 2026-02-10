# Mini Katalog Uygulaması

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?style=flat-square&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.x-blue?style=flat-square&logo=dart)
![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20Android-green?style=flat-square)

Mini Katalog Uygulaması, Flutter ile geliştirilmiş, modern ve kullanıcı dostu bir e-ticaret katalog uygulamasıdır. Kullanıcıların ürünleri keşfetmesine, detaylarını incelemesine ve favorilerine eklemesine olanak tanır.

## 📱 Özellikler

*   **Premium UI Tasarımı:** Jet Black & Gold teması ile şık ve modern görünüm.
*   **Gelişmiş Navigasyon:** Özel sayfa geçiş animasyonları ve Named Route yapısı.
*   **Dinamik Filtreleme:** Kategori bazlı filtreleme ve gerçek zamanlı ürün arama.
*   **Detaylı Ürün Ekranı:** Hero animasyonları ile zenginleştirilmiş ürün detay sayfası.
*   **Favori Sistemi:** Beğenilen ürünleri yerel olarak favorilere ekleme ve yönetme.
*   **Responsive Izgara:** Farklı ekran boyutlarına uyumlu ürün listeleme.
*   **API Entegrasyonu (Simülasyon & Gerçek):** Hem yerel JSON verisi hem de `ProductsApiService` ile uzak sunucudan veri çekme altyapısı (Repository Pattern).

## 🛠 Teknoloji Yığını

*   **Flutter & Dart:** Uygulama geliştirme ve programlama dili.
*   **State Management:** `setState` ve `Repository Pattern` ile veri yönetimi.
*   **Assets:** Yerel JSON verisi ve görsel yönetimi.
*   **Networking:** `HttpClient` ile REST API istekleri.

## 📂 Proje Yapısı

Proje, temiz mimari prensiplerine uygun olarak organize edilmiştir:

```
lib/
├── config/       # API ve uygulama konfigürasyonları
├── constants/    # Renkler, metinler, stiller ve yardımcı fonksiyonlar
├── data/         # Veri kaynakları (JSON, API Servisleri, Repository)
├── models/       # Veri modelleri (Product)
├── screens/      # Uygulama ekranları (Home, List, Detail, Favorites)
└── widgets/      # Yeniden kullanılabilir UI bileşenleri (Cards, Chips, Bars)
```

## 🚀 Kurulum

1.  Projeyi klonlayın:
    ```bash
    git clone https://github.com/BGirginn/TNC_Mobile_Project.git
    ```
2.  Proje dizinine gidin:
    ```bash
    cd TNC_Mobile_Project
    ```
3.  Bağımlılıkları yükleyin:
    ```bash
    flutter pub get
    ```
4.  Uygulamayı çalıştırın:
    ```bash
    flutter run
    ```

## 📸 Ekran Görüntüleri

| Ana Sayfa | Ürün Listesi | Detay Sayfası |
|:---:|:---:|:---:|
| *(Ekran görüntüsü eklenecek)* | *(Ekran görüntüsü eklenecek)* | *(Ekran görüntüsü eklenecek)* |

## 📝 Lisans

Bu proje MIT lisansı altında lisanslanmıştır. Detaylar için `LICENSE` dosyasına bakınız.
