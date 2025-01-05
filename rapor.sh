#!/bin/bash

FILE="depo.csv"
# Ürün bilgilerinin olduğu dosyanın varlığı kontrol edilir
if [[ ! -f $FILE ]]; then
    zenity --error --text="Ürün listesi bulunamadı!"
    exit 1
fi

# Kullanıcıya rapor işlemleri için sunulan seçenekler zenity ile listelenir
CHOICE=$(zenity --list --title="Rapor İşlemleri" \
    --column="Seçenekler" \
    "Stokta Azalan Ürünler" "Stokların minimum stoklara oranı" "Stokların Toplam Değerleri")

# Minimum stok miktarının altında kalan stoklara sahip ürünler zenity ile gösterilir
if [[ "$CHOICE" == "Stokta Azalan Ürünler" ]]; then
    awk -F, '$3 < $6 && NR > 1 {print $0, $1}' "$FILE" > /tmp/low_stock.csv
    zenity --text-info --filename=/tmp/low_stock.csv --title="Stokta Azalan Ürünler"

# Stokların minimum stok değerlerine oranı zenity ile gösterilir
elif [[ "$CHOICE" == "Stokların minimum stoklara oranı" ]]; then
    awk -F, 'NR > 1 {
        if ($6 == 0) {
            oran = "Tanımsız";
        } else {
            oran = $3 / $6;
        }
        printf "%-20s %-20s %-10s %-10s\n", $1, $2, $3, oran;
    }' "$FILE" > /tmp/stock_ratios.csv
    zenity --text-info --filename=/tmp/stock_ratios.csv --title="Stokların minimum stoklara oranı"

# Ürün stokları ile fiyatların çarpımı ile ürünlerin toplam değerleri hesaplanır ve zenity ile gösterilir
elif [[ "$CHOICE" == "Stokların Toplam Değerleri" ]]; then
    awk -F, 'NR > 1 {
        toplam_deger = $3 * $4;
        printf "%-20s %-20s %-10s %-10s\n", $1, $2, $3, toplam_deger;
    }' "$FILE" > /tmp/stock_values.csv
    zenity --text-info --filename=/tmp/stock_values.csv --title="Stokların Toplam Değerleri"

# Yanlış bir seçim söz konusu olursa hata gösterir
else
    zenity --error --text="Geçersiz seçim!"
fi
