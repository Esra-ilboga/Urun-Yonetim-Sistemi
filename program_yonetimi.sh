#!/bin/bash

# Gerekli dosyaların tanımlanması
GEREKLI_DOSYALAR=("depo.csv" "kullanici.csv" "log.csv" "kullanici_yonetimi.sh" "program_yonetimi.sh" "rapor.sh" "urun_ekle.sh" "urun_guncelle.sh" "urun_listele.sh" "urun_sil.sh" "urun_yonetim_sistemi.sh")

# Eksik dosyaları kontrol eder ve eksik dosya varsa bunu döndürür
dosya_kontrol() {
    local eksik_dosyalar=()
    for dosya in "${GEREKLI_DOSYALAR[@]}"; do
        if [[ ! -f $dosya ]]; then
            eksik_dosyalar+=("$dosya")
        fi
    done
    echo "${eksik_dosyalar[@]}"
}

# Program yönetimi için seçenekler zenity liste penceresiyle döndürülür
SECIM=$(zenity --list --title="Program Yönetimi" \
    --column="Seçenekler" \
    "Disk Alanını Göster" "Dosyaları Yedekle" "Hata Kayıtlarını Görüntüle")

case $SECIM in
    # Gerekli dosyaların disk kullanım alan bilgisini alır ve ekrana yansıtır
    "Disk Alanını Göster")
        EKSIK_DOSYALAR=$(dosya_kontrol)
        if [[ -n $EKSIK_DOSYALAR ]]; then
            zenity --error --text="Eksik dosyalar: $EKSIK_DOSYALAR\nGerekli dosyaları oluşturun."
            exit 1
        fi
        DISK_KULLANIMI=$(df -h | awk 'NR==1 || $NF=="/"')
        zenity --info --text="Disk Alanı Kullanımı:\n$DISK_KULLANIMI"
        ;;
    # depo.csv ve kullanici.csv dosyaları yedekler adlı bir dizine kopyalanıp saklanır
    "Dosyaları Yedekle")
        YEDEK_DOSYASI="yedekler"
        mkdir -p "$YEDEK_DOSYASI"

        EKSIK_DOSYALAR=$(dosya_kontrol)
        if [[ -n $EKSIK_DOSYALAR ]]; then
            zenity --error --text="Eksik dosyalar: $EKSIK_DOSYALAR\nYedekleme yapılamadı."
            exit 1
        fi

        cp depo.csv kullanici.csv "$YEDEK_DOSYASI/"
        zenity --info --text="Dosyalar başarıyla $YEDEK_DOSYASI dizinine yedeklendi!"
        ;;
    # Hata kayıtlarının tutulduğu log.csv dosyasından hata kayıtları görüntülenir 
    "Hata Kayıtlarını Görüntüle")
        if [[ ! -f "log.csv" ]]; then
            zenity --error --text="Hata kayıt dosyası bulunamadı!"
            exit 1
        fi
        zenity --text-info --filename="log.csv" --title="Hata Kayıtları"
        ;;
    *)
	# Geçersiz bir seçim söz konusu olduğun ekranda görünecek mesaj
        zenity --error --text="Geçersiz seçim!"
        ;;
esac

