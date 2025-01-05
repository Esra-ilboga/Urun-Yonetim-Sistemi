#!/bin/bash

FILE="depo.csv"
LOGFILE="log.csv"

# Gerekli dosyaları oluşturma işlemi gerçekleştirilir
if [[ ! -f $FILE ]]; then
    echo "Ürün No,Ürün Adı,Stok Miktarı,Birim Fiyatı,Kategori,Sınır Stok" > $FILE
fi

if [[ ! -f $LOGFILE ]]; then
    echo "Hata Numarası,Zaman Bilgisi,Hata Mesajı" > $LOGFILE
fi

# Ürün hakkında gerekli bilgilerin kullanıcıdan  alınması gerçekleştirilir
DATA=$(zenity --forms --title="Ürün Ekle" \
    --add-entry="Ürün Adı (Boşluk Olmamalı)" \
    --add-entry="Stok Miktarı (0 veya Pozitif Olmalı)" \
    --add-entry="Birim Fiyatı (0 veya Pozitif Olmalı)" \
    --add-entry="Kategori (Boşluk Olmamalı)"\
    --add-entry="Gerekli En Az Stok Miktarı(0 veya Pozitif Olmalı)")

if [[ $? -eq 0 ]]; then
    # Kullanıcıdan alınan bilgiler doğrulanır
    URUN_ADI=$(echo "$DATA" | awk -F'|' '{print $1}')
    STOK=$(echo "$DATA" | awk -F'|' '{print $2}')
    FIYAT=$(echo "$DATA" | awk -F'|' '{print $3}')
    KATEGORI=$(echo "$DATA" | awk -F'|' '{print $4}')
    MIN_STOK=$(echo "$DATA" | awk -F'|' '{print $5}')

    # Stok, fiyat ve olması gereken minimum stok miktarının 0 veya daha büyük değerler alması sağlanır
    if ! [[ $STOK =~ ^[0-9]+$ ]] || ! [[ $FIYAT =~ ^[0-9]+(\.[0-9]+)?$ ]] || ! [[ $MIN_STOK =~ ^[0-9]+$ ]]; then
        ERROR_MSG="Hata : Stok miktarı, minimum stok miktarı ve fiyat pozitif sayı olmalıdır."
        zenity --error --text="$ERROR_MSG"
        echo "$(date +%s),$(date),$ERROR_MSG" >> $LOGFILE
        exit 1
    fi

    # Ürün adı ve ürün kategorisinde boşluk olmaması sağlanır
    if [[ "$URUN_ADI" =~ \  ]] || [[ "$KATEGORI" =~ \  ]]; then
        ERROR_MSG="Hata : Ürün adı ve kategori boşluk içermemelidir."
        zenity --error --text="$ERROR_MSG"
        echo "$(date +%s),$(date),$ERROR_MSG" >> $LOGFILE
        exit 1
    fi

    # Kullanıcıdan alınan yeni ürünün var olup olmama durum kontrolü sağlanır
    if grep -q ",$URUN_ADI," "$FILE"; then
        ERROR_MSG="Böyle bir ürün bulunmakta. Başka bir ürün bilgisi girin lütfen!"
        zenity --error --text="$ERROR_MSG"
        echo "$(date +%s),$(date),$ERROR_MSG" >> $LOGFILE
        exit 1
    fi
    # Ürün eklenirken işlem onayı alınır
    zenity --question --text="Ürünü eklemek istediğinize emin misiniz?"
    if [[ $? -ne 0 ]]; then
        zenity --error --text="Ürün ekleme işlemi iptal edildi!"
        exit 1
    fi
    #progress bar ile işlem süreci
    (
        echo "0"; sleep 1
        echo "# Ürün bilgileri kontrol ediliyor..."; sleep 1
        echo "50"; sleep 1
        echo "# Ürün ekleniyor..."; sleep 1
        echo "100"
    ) | zenity --progress --title="Ürün Ekleme" --percentage=0 --auto-close

    # Ürünün ve bilgilerinin dosyaya eklenmesi sağlanır
    ID=$(($(tail -n +2 "$FILE" | wc -l) + 1))
    echo "$ID,$URUN_ADI,$STOK,$FIYAT,$KATEGORI,$MIN_STOK" >> $FILE

    zenity --info --text="Ürün başarıyla eklendi!"
else
    ERROR_MSG="Ürün ekleme işlemi iptal edildi."
    zenity --error --text="$ERROR_MSG"
    echo "$(date +%s),$(date),$ERROR_MSG" >> $LOGFILE
    exit 1
fi
