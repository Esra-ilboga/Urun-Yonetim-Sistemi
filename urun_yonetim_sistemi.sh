#!/bin/bash

#dosya_islemleri ile verileirn saklanacağı gerekli dosyalar kontrol edilir yoksa oluşturulur
dosya_islemleri(){
   for file in depo.csv kullanici.csv log.csv; do
      if [[ ! -f $file ]]; then
         touch $file
         case $file in
            "depo.csv")
               echo "Ürün No,Ürün Adı,Stok Miktarı,Birim Fiyatı,Kategori,Sınır Stok" > $file
               ;;
            "kullanici.csv")
               echo "Kullanıcı No,Adı,Soyadı,Rol,Parola" > $file
               echo "2,admin,admin,Yönetici,$(echo -n 'admin' | md5sum | awk '{print $1}')" >> $file
               ;;
            "log.csv")
               echo "Hata Numarası,Zaman Bilgisi,Kullanıcı Bilgisi,Ürün Bilgisi,Hata Mesajı" > $file
               ;;
         esac
      fi
   done
}

# Kullanıcıya 3 deneme hakkı veren kullanıcı adı ve şifre ile giriş sağlayan zenity penceresi oluşturulur
giris(){
   local girisdeneme=0
   local max_girisdeneme=3
   while [[ $girisdeneme -lt $max_girisdeneme ]]; do
      KULLANICIADI=$(zenity --entry --title="Giriş Ekranı" --text="Kullanıcı Adı:")
      if [[ -z $KULLANICIADI ]]; then
         exit 0
      fi
      SIFRE=$(zenity --password --title="Giriş Ekranı")
      if [[ -z $SIFRE ]]; then
         exit 0
      fi

      if [[ -z $KULLANICIADI || -z $SIFRE ]]; then
         zenity --error --text="Kullanıcı adı veya şifre boş bırakılamaz!"
         continue
      fi

      SIFRE_HASH=$(echo -n "$SIFRE" | md5sum | awk '{print $1}')
      KULLANICI_KAYDI=$(grep -w "$KULLANICIADI" kullanici.csv)

      if [[ -z $KULLANICI_KAYDI ]]; then
         zenity --error --text="Böyle bir kullanıcı bulunamadı!"
      else
         STORED_HASH=$(echo "$KULLANICI_KAYDI" | awk -F, '{print $5}')
         ROLE=$(echo "$KULLANICI_KAYDI" | awk -F, '{print $4}')

         if [[ $SIFRE_HASH == $STORED_HASH ]]; then
            zenity --info --text="Başarıyla giriş yaptınız! Hoşgeldiniz, $KULLANICIADI!"
            GECERLI_KULLANICI="$KULLANICIADI"
            GECERLI_ROL="$ROLE"
            return 0
         else
            zenity --error --text="Hatalı Şifre!"
         fi
      fi
      girisdeneme=$((girisdeneme + 1))
      zenity --warning --text="Kalan deneme: $((max_girisdeneme - girisdeneme))"
   done

   zenity --error --text="Tanınan giriş denemesi aşıldı! Çıkılıyor!"
   exit 1
}

# Giriş yaptıktan sonra işlemlerin ve buna göre seçimlerin olduğu ana menü ekranı oluşturulur
main_menu(){
   while true; do
      SECIM=$(zenity --list --title="Ürün Yönetim Sistemi" \
         --column="Seçenekler" \
         "Ürün Ekle" "Ürün Listele" "Ürün Güncelle" "Ürün Sil" \
         "Rapor Al" "Kullanıcı Yönetimi" "Program Yönetimi" "Çıkış" )
      if [[ -z $SECIM ]]; then
         exit 0
      fi

      case $SECIM in
         "Ürün Ekle")
            if [[ $GECERLI_ROL == "Yönetici" ]]; then
               ./urun_ekle.sh
            else
               zenity --error --text="Bu işlemi yapmak için yetkiniz bulunmamakta!"
            fi
            ;;
         "Ürün Listele") ./urun_listele.sh ;;
         "Ürün Güncelle")
            if [[ $GECERLI_ROL == "Yönetici" ]]; then
               ./urun_guncelle.sh
            else
               zenity --error --text="Bu işlemi yapmak için yetkiniz bulunmamakta!"
            fi
            ;;
         "Ürün Sil")
            if [[ $GECERLI_ROL == "Yönetici" ]]; then
               ./urun_sil.sh
            else
               zenity --error --text="Bu işlemi yapmak için yetkiniz bulunmamakta!"
            fi
            ;;
         "Rapor Al") ./rapor.sh ;;
         "Kullanıcı Yönetimi")
            if [[ $GECERLI_ROL == "Yönetici" ]]; then
               ./kullanici_yonetimi.sh
            else
               zenity --error --text="Bu işlemi yapmak için yetkiniz bulunmamakta!"
            fi
            ;;
         "Program Yönetimi") ./program_yonetimi.sh ;;
         "Çıkış")
	    if zenity --question --title="Çıkış" --text="Sistemi kapatmak istediğinizden emin misiniz?"; then
                zenity --info --text="Sistemden çıkılıyor."
                exit 0
            else
                zenity --info --text="Çıkış iptal edildi."
            fi
            ;;
         *) zenity --error --text="Geçersiz seçim!" ;;
      esac
   done
}

# Çalışma akışı bu sırayla sağlanır
dosya_islemleri
giris
main_menu
