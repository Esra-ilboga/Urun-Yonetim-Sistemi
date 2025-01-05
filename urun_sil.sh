#!/bin/bash

FILE="depo.csv"
LOGFILE="log.csv"
# Hata bilgilerinin olduğu dosyayı oluşturur
if [[ ! -f $LOGFILE ]]; then
    echo "Hata Numarası,Zaman Bilgisi,Hata Mesajı" > $LOGFILE
fi

# Silinmesi istenen ürün adı kullanıcıdan alınır
URUN_ADI=$(zenity --entry --title="Ürün Sil" --text="Silmek istediğiniz ürünün adını girin:")

# Ürün adının boşluk içerip içermediği kontrol edilir
if [[ "$URUN_ADI" =~ \  ]]; then
    ERROR_MSG="Hata : Ürün adı boşluk içermemelidir. ($URUN_ADI)"
    zenity --error --text="$ERROR_MSG"
    echo "$(date +%s),$(date),$ERROR_MSG" >> $LOGFILE
    exit 1
fi

# Ürün ürün bilgilerinin olduğu dosyada aratılır
LINE=$(grep -i ",$URUN_ADI," "$FILE")

# Ürün bulunamadıysa hata mesajı zenity penceresi ile yansıtılır
if [[ -z $LINE ]]; then
    ERROR_MSG="Ürün bulunamadı: $URUN_ADI"
    zenity --error --text="$ERROR_MSG"
    echo "$(date +%s),$(date),$ERROR_MSG" >> $LOGFILE
    exit 1
fi

# Ürünü silmek için kullanıcıdan onay alınır
zenity --question --text="Bu ürünü silmek istediğinizden emin misiniz?"
if [[ $? -ne 0 ]]; then
    zenity --error --text="Silme işlemi iptal edildi!"
    exit 1
fi

# progress bar ile işlem süreci gösterilir
(
    echo "0"; sleep 1
    echo "# Ürün bilgileri kontrol ediliyor..."; sleep 1
    echo "50"; sleep 1
    echo "# Ürün siliniyor..."; sleep 1
    echo "100"
) | zenity --progress --title="Ürün Silme" --percentage=0 --auto-close

# Ürün ürün bilgilerinin olduğu dosyadan silinir
sed -i "/,$URUN_ADI,/d" $FILE

zenity --info --text="Ürün başarıyla silindi!"

