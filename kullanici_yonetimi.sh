#!/bin/bash

FILE="kullanici.csv"
LOGFILE="log.csv"
LOCKFILE="locked_users.csv"

# Gerekli dosyaların kontrolü ve oluşturulması
if [[ ! -f $FILE ]]; then
    echo "Kullanıcı No,Adı,Soyadı,Rol,Parola" > $FILE
fi

if [[ ! -f $LOGFILE ]]; then
    echo "Hata Numarası,Zaman Bilgisi,Hata Mesajı" > $LOGFILE
fi

if [[ ! -f $LOCKFILE ]]; then
    echo "Kullanıcı Adı,Zaman" > $LOCKFILE
fi
# Kullanıcı yönetimi için seçenek sunmayı sağlar
SECIM=$(zenity --list --title="Kullanıcı Yönetimi" \
    --column="Seçenekler" \
    "Yeni Kullanıcı Ekle" "Kullanıcıları Listele" "Kullanıcı Güncelle" "Kullanıcı Sil" \
    "Şifre Sıfırla" "Kilitli Hesapları Aç" "Hesap Kilitle")

case $SECIM in
    #Yeni kullanıcı ekleme işlemini yapar: Bilgileri alır, bir sonraki kayıt için kullanıcı noyu 1 arttırır ve bilgileri dosyaya kaydeder
    "Yeni Kullanıcı Ekle")
        VERI=$(zenity --forms --title="Yeni Kullanıcı Ekle" \
            --add-entry="Adı" \
            --add-entry="Soyadı" \
            --add-combo="Rol" --combo-values="Yönetici|Kullanıcı" \
            --add-password="Parola")
        if [[ $? -eq 0 ]]; then
            ID=$(($(tail -n +2 "$FILE" | wc -l) + 1))
            SIFRE_HASH=$(echo -n "$(echo "$VERI" | awk -F'|' '{print $4}')" | md5sum | awk '{print $1}')
            echo "$ID,$(echo "$VERI" | awk -F'|' '{print $1","$2","$3}'),$SIFRE_HASH" >> $FILE
            zenity --info --text="Kullanıcı başarıyla eklendi!"
        else
            zenity --error --text="Kullanıcı ekleme iptal edildi!"
        fi
        ;;
    # Kullanıcıları ekranda gösterir
    "Kullanıcıları Listele")
        zenity --text-info --filename=$FILE --title="Kullanıcı Listesi"
        ;;
    # Kullanıcı bilgilerini yeniden düzenlemeyi kaydetmeyi sağlar
    "Kullanıcı Güncelle")
        KULLANICI=$(zenity --entry --title="Kullanıcı Güncelle" --text="Güncellemek istediğiniz kullanıcının adı:")
        SATIR=$(grep -w "$KULLANICI" "$FILE")
        if [[ -z $SATIR ]]; then
            zenity --error --text="Kullanıcı bulunamadı!"
            exit 1
        fi
        YENI_VERI=$(zenity --forms --title="Kullanıcı Güncelle" \
            --add-entry="Yeni Adı" \
            --add-entry="Yeni Soyadı" \
            --add-combo="Yeni Rol" --combo-values="Yönetici|Kullanıcı" \
            --add-password="Yeni Parola")
        SIFRE_HASH=$(echo -n "$(echo "$YENI_VERI" | awk -F'|' '{print $4}')" | md5sum | awk '{print $1}')
        GUNCEL_SATIR=$(echo "$YENI_VERI" | awk -F'|' -v line="$SATIR" '{split(line,a,","); printf "%s,%s,%s,%s,%s", a[1], $1, $2, $3, "'"$SIFRE_HASH"'"}')
        sed -i "s|$SATIR|$GUNCEL_SATIR|" $FILE
        zenity --info --text="Kullanıcı başarıyla güncellendi!"
        ;;
    # Kullanıcı adı alınan kişiyi siler
    "Kullanıcı Sil")
        KULLANICI=$(zenity --entry --title="Kullanıcı Sil" --text="Silmek istediğiniz kullanıcının adı:")
        SATIR=$(grep -w "$KULLANICI" "$FILE")
        if [[ -z $SATIR ]]; then
            zenity --error --text="Kullanıcı bulunamadı!"
            exit 1
        fi
        zenity --question --text="Bu kullanıcıyı silmek istediğinizden emin misiniz?"
        if [[ $? -ne 0 ]]; then
            zenity --info --text="Silme işlemi iptal edildi."
            exit 1
        fi
        (
            echo "0"; sleep 1
            echo "# Kullanıcı bilgileri kontrol ediliyor..."; sleep 1
            echo "50"; sleep 1
            echo "# Kullanıcı siliniyor..."; sleep 1
            echo "100"
        ) | zenity --progress --title="Kullanıcı Silme" --percentage=0 --auto-close
        sed -i "/$KULLANICI/d" $FILE
        zenity --info --text="Kullanıcı başarıyla silindi!"
        ;;
    # Kullanıcı adı girilen kişinin şifresinin sıfırlanıp yeniden belirlenmesini sağlar
    "Şifre Sıfırla")
        KULLANICI=$(zenity --entry --title="Şifre Sıfırla" --text="Şifresini sıfırlamak istediğiniz kullanıcının adı:")
        SATIR=$(grep -w "$KULLANICI" "$FILE")
        if [[ -z $SATIR ]]; then
            zenity --error --text="Kullanıcı bulunamadı!"
            exit 1
        fi
        YENI_SIFRE=$(zenity --password --title="Yeni Şifre" --text="Yeni şifreyi girin:")
        SIFRE_HASH=$(echo -n "$YENI_SIFRE" | md5sum | awk '{print $1}')
        GUNCEL_SATIR=$(echo "$SATIR" | awk -F, -v pass="$SIFRE_HASH" 'BEGIN{OFS=","}{$5=pass; print}')
        sed -i "s|$SATIR|$GUNCEL_SATIR|" $FILE
        zenity --info --text="Şifre başarıyla sıfırlandı!"
        ;;
    # Kullanıcı adı alınan kişinin kilitli hesabını  açmayı sağlar
    "Kilitli Hesapları Aç")
        KILITLI_KULLANICILAR=$(tail -n +2 $LOCKFILE)
        if [[ -z $KILITLI_KULLANICILAR ]]; then
            zenity --info --text="Kilitli hesap bulunamadı!"
            exit 0
        fi
        KULLANICI=$(zenity --entry --title="Hesap Açma" --text="Açmak istediğiniz hesabın adını girin:")
        KILITLI_SATIR=$(grep -w "$KULLANICI" $LOCKFILE)
        if [[ -z $KILITLI_SATIR ]]; then
            zenity --error --text="$KULLANICI adlı kullanıcı kilitli hesaplar arasında bulunamadı!"
            exit 1
        fi
        sed -i "/$KULLANICI/d" $LOCKFILE
        zenity --info --text="$KULLANICI adlı hesap başarıyla açıldı!"
        ;;
    # Girilen kullanıcı adına ait hesabı kilitler
    "Hesap Kilitle")
        KULLANICI=$(zenity --entry --title="Hesap Kilitle" --text="Kilitlemek istediğiniz kullanıcının adını girin:")
        SATIR=$(grep -w "$KULLANICI" "$FILE")
        if [[ -z $SATIR ]]; then
            zenity --error --text="Kullanıcı bulunamadı!"
            exit 1
        fi
        echo "$KULLANICI,$(date)" >> $LOCKFILE
        zenity --info --text="$KULLANICI adlı hesap başarıyla kilitlendi!"
        ;;
    *)
	# Geçersiz durumunda ekrana aşağıdaki mesajı çıktı olarak verir
        zenity --error --text="Geçersiz seçim!"
        ;;
esac
