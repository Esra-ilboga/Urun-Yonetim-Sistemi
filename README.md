# Ürün Yönetim Sistemi
   Bu proje, Linux(Ubuntu) işletim sisteminde Zenity kullanılarak Bash betikleriyle geliştirilen kapsamlı bir Ürün (Envanter) Yönetim Sistemidir. Sistem, ürün ekleme, silme, güncelleme ve listeleme gibi temel envanter yönetimi işlemlerini kullanıcı dostu bir arayüzle sunar. Ayrıca, kullanıcı şifre sıfırlama, yeni kullanıcı ekleme ve mevcut kullanıcıları listeleme gibi kullanıcı yönetimi işlemleri de gerçekleştirilir. Bunun yanı sıra, rapor oluşturma, hata kayıtlarını tutma ve program yönetimi gibi ek özellikler sayesinde sistem, hem operasyonel verimliliği artırır hem de hataların izlenebilirliğini sağlar.
## 🔗 Link
Projenin [Github linki](https://github.com/Esra-ilboga/Urun-Yonetim-Sistemi.git) 
## Zenity Kontrol ve Kurulum
+ Zenity'nin yüklü olup olmadığını ve sistemdeki konumunu kontrol etmek.
```bash
  $ which zenity
```
+ Zenity kurulu ise Zenity'nin hangi sürümünün kurulu olduğunu öğrenmek.
```bash
  $ zenity --version
```
+ Zenity uygulaması hakkında bilgi içeren bir pencere açarak Zenity sürümü, geliştiriciler ve açıklamalara erişmek.
```bash
  $ zenity --about
```
+ Zenity kurulu değilse, kurulum için şu komut kullanılabilir:
```bash
  $ sudo apt-get install zenity
```
## Youtube Video Bağlantısı
Projeyi kısaca açıkladığım youtube videosuna erişmek için [YotubeLinki](https://youtu.be/hh039DD1n4U) yazan yere tıklayınız.
## **Ürün Yönetimi Sistemi Özellikleri**

Bu sistem, aşağıdaki ana modülleri ve işlevleri içermektedir:

---

### **1. Ürün Yönetimi**
Ürünler ile ilgili aşağıdaki işlemleri gerçekleştirebilirsiniz:

- **Ürün Ekleme:** Yeni ürünler sisteme eklenebilir.
- **Ürün Listeleme:** Mevcut ürünler listelenebilir.
- **Ürün Güncelleme:** Var olan ürünlerin bilgileri güncellenebilir.
- **Ürün Silme:** İstenmeyen ürünler sistemden silinebilir.

---

### **2. Kullanıcı Yönetimi**
Kullanıcılar ile ilgili işlemler şu şekildedir:

- **Yeni Kullanıcı Ekleme:** Sisteme yeni kullanıcılar eklenebilir.
- **Kullanıcı Bilgilerini Güncelleme:** Mevcut kullanıcıların bilgileri güncellenebilir.
- **Kullanıcı Silme:** Kullanıcılar sistemden silinebilir.
- **Kilitli Hesapları Açma ve Şifre Sıfırlama:** Kilitlenmiş hesaplar açılabilir ve şifreler sıfırlanabilir.
- **Yönetici Yetkileriyle Hesap Yönetimi:** Yönetici, tüm kullanıcı hesapları üzerinde yönetim yapabilir.

---

### **3. Raporlama**
Sistem, çeşitli raporlama işlevlerine sahiptir:

- **Stokta Azalan Ürünler:** Stokları azalan ürünler listelenebilir.
- **Minimum Stok Oranı Hesaplama:** Ürünlerin minimum stok seviyelerine oranlar hesaplanabilir.
- **Toplam Stok Değeri Hesaplama:** Tüm ürünlerin stok değerleri hesaplanabilir.

---

### **4. Program Yönetimi**
Program yönetimi için aşağıdaki işlevler mevcuttur:

- **Disk Alanı Bilgisi:** Sistem, kullanılan ve boş disk alanı bilgilerini gösterir.
- **Dosya Yedekleme:** Sistemdeki dosyalar yedeklenebilir.
- **Hata Loglarının Görüntülenmesi:** Sistem hataları kaydedilir ve görüntülenebilir.

---

### **Notlar**
- Program çalıştırıldığında, gerekli dosyalar **otomatik olarak oluşturulacaktır**. Bu dosyalar şunlardır:
  - `depo.csv` - Ürünler ve stok bilgileri.
  - `kullanici.csv` - Kullanıcı bilgileri.
  - `log.csv` - Hata ve işlem logları.
  - `locked_users.csv` - Kilitli kullanıcılar bilgisi.

## Giris Ekranı
![image](https://github.com/user-attachments/assets/a2ec4880-9a03-4014-afd0-18b01f661dbf)
</br>
## Seçenek Ekranı
![image](https://github.com/user-attachments/assets/c3164a8b-6e38-4ee7-bbf6-d3a295a96a62)
</br>
## Ürün İşlemleri
![image](https://github.com/user-attachments/assets/b4a6dac4-41d6-463e-a6f5-313881ad4c11)
![image](https://github.com/user-attachments/assets/05663d44-935a-418d-9288-403089b6ae70)
</br>
## Rapor İşlemleri
![image](https://github.com/user-attachments/assets/f78f0140-58a9-455b-9aaa-4b0d88e68a14)
![image](https://github.com/user-attachments/assets/e03dcc68-3ae2-41fb-aac3-abf72a41017a)
</br>
## Kullanıcı Yönetimi
![image](https://github.com/user-attachments/assets/2fc84e3d-5b0a-49fb-9197-73951d555ee6)
![image](https://github.com/user-attachments/assets/f159c3b9-77e7-40a3-acf5-3baea1ac509d)
</br>
## Program Yönetimi
![image](https://github.com/user-attachments/assets/d29a87a9-5afb-4894-bd51-32ce4ca43ee9)
</br>
## Çıkış
![image](https://github.com/user-attachments/assets/5770c8f9-ea11-4278-ba28-dee307084004)
</br>




# **Görseller**

---

## **Giriş Ekranı**
![Giriş Ekranı](https://github.com/user-attachments/assets/a2ec4880-9a03-4014-afd0-18b01f661dbf)

---

## **Seçenek Ekranı**
![Seçenek Ekranı](https://github.com/user-attachments/assets/c3164a8b-6e38-4ee7-bbf6-d3a295a96a62)

---

## **Ürün İşlemleri**
![Ürün İşlemleri 1](https://github.com/user-attachments/assets/b4a6dac4-41d6-463e-a6f5-313881ad4c11)
![Ürün İşlemleri 2](https://github.com/user-attachments/assets/05663d44-935a-418d-9288-403089b6ae70)

---

## **Rapor İşlemleri**
![Rapor İşlemleri 1](https://github.com/user-attachments/assets/f78f0140-58a9-455b-9aaa-4b0d88e68a14)
![Rapor İşlemleri 2](https://github.com/user-attachments/assets/e03dcc68-3ae2-41fb-aac3-abf72a41017a)

---

## **Kullanıcı Yönetimi**
![Kullanıcı Yönetimi 1](https://github.com/user-attachments/assets/2fc84e3d-5b0a-49fb-9197-73951d555ee6)
![Kullanıcı Yönetimi 2](https://github.com/user-attachments/assets/f159c3b9-77e7-40a3-acf5-3baea1ac509d)

---

## **Program Yönetimi**
![Program Yönetimi](https://github.com/user-attachments/assets/d29a87a9-5afb-4894-bd51-32ce4ca43ee9)

---

## **Çıkış**
![Çıkış](https://github.com/user-attachments/assets/5770c8f9-ea11-4278-ba28-dee307084004)




