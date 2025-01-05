#!/bin/bash

FILE="depo.csv"
LOGFILE="log.csv"

# Gerekli dosya kontrol edilir ve oluşturulur
if [[ ! -f $LOGFILE ]]; then
    echo "Hata Numarası,Zaman Bilgisi,Hata Mesajı" > $LOGFILE
fi

# güncellenmek istenen ürün bilgisi alınır
URUN=$(zenity --entry --title="Ürün Güncelle" --text="Güncellemek istediğiniz ürünün adını girin:")
LINE=$(grep -w "$URUN" "$FILE")

if [[ -z $LINE ]]; then
    ERROR_MSG="Ürün bulunamadı: $URUN"
    zenity --error --text="$ERROR_MSG"
    echo "$(date +%s),$(date),$ERROR_MSG" >> $LOGFILE
    exit 1
fi

# Güncellenmek istenen ürün için kullanıcıdan yeni bilgiler alınır
YENI_VERI=$(zenity --forms --title="Ürün Güncelle" \
    --add-entry="Yeni Stok Miktarı (0 veya Pozitif Olmalı)" \
    --add-entry="Yeni Birim Fiyatı (0 veya Pozitif Olmalı)" \
    --add-entry="Yeni En Az Stok Miktarı (0 veya Pozitif Olmalı)")

if [[ $? -eq 0 ]]; then
    YENI_STOK=$(echo "$YENI_VERI" | awk -F'|' '{print $1}')
    YENI_FIYAT=$(echo "$YENI_VERI" | awk -F'|' '{print $2}')
    YENI_MIN_STOK=$(echo "$YENI_VERI" | awk -F'|' '{print $3}')

    # Stok, fiyat ve min_stok bilgilerinin sıfır veya pozitif sayı olmasını sağlar 
    if ! [[ $YENI_STOK =~ ^[0-9]+$ ]] || ! [[ $YENI_FIYAT =~ ^[0-9]+(\.[0-9]+)?$ ]] || ! [[ $YENI_MIN_STOK =~ ^[0-9]+$ ]]; then
        ERROR_MSG="Hata : Stok miktarı, birim fiyatı ve minimum stok pozitif sayı olmalıdır."
        zenity --error --text="$ERROR_MSG"
        echo "$(date +%s),$(date),$ERROR_MSG" >> $LOGFILE
        exit 1
    fi

    # Güncellemek için onay bilgisi alınır
    zenity --question --text="Ürün bilgilerini güncellemek istediğinize emin misiniz?"
    if [[ $? -ne 0 ]]; then
        zenity --error --text="Güncelleme işlemi iptal edildi!"
        exit 1
    fi

    # Progress bar ile işlem süreci sağlanır
    (
        echo "0"; sleep 1
        echo "# Ürün bilgileri kontrol ediliyor..."; sleep 1
        echo "50"; sleep 1
        echo "# Ürün güncelleniyor..."; sleep 1
        echo "100"
    ) | zenity --progress --title="Ürün Güncelleme" --percentage=0 --auto-close

    # Güncellenen bilgiler ürün bilgilerini barındıran dosyaya yazılır
    YENI_SATIR=$(echo "$LINE" | awk -F',' -v stok="$YENI_STOK" -v fiyat="$YENI_FIYAT" -v minstok="$YENI_MIN_STOK" 'BEGIN{OFS=","} {$3=stok; $4=fiyat; $6=minstok; print $0}')
    sed -i "s|$LINE|$YENI_SATIR|" $FILE

    zenity --info --text="Ürün başarıyla güncellendi!"
else
    ERROR_MSG="Ürün güncelleme işlemi iptal edildi."
    zenity --error --text="$ERROR_MSG"
    echo "$(date +%s),$(date),$ERROR_MSG" >> $LOGFILE
    exit 1
fi
