#!/bin/bash
FILE="depo.csv"
#Ürün bilgilerinin ekleneceğinin dosyanın var olup olmadığı kontrol edilir
if [[ ! -f $FILE ]]; then
    zenity --error --text="Ürün listesi bulunamadı!"
    exit 1
fi
#ürün bilgilerinin olduğu dosya zenity penceresine gönderilir ve ekrana yansır
zenity --text-info --filename=$FILE --title="Ürün Listesi"
