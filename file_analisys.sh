#!/bin/bash

meid=$(id -u) 

function ctrl_c(){
    echo "\n[!] Saliendo..."
    exit 1
}

#Ctrl+C
trap ctrl_c INT

function helpPanel(){
  echo -e "\n[+] Ingrese una de estas opciones:"
  echo -e "\tf) Buscar archivo en el sistema"
  echo -e "\tr) Ejecutar reemplazo de parametro en un archivo"
  echo -e "\ts) Conocer tamano de un archivo"

}

function find_file(){

read -p "Introduzca nombre de archivo: " file_name
file_discover=$(find / -type f -name "$file_name*" 2< /dev/null)


if [ -z "$file_discover" ]; then
    echo -e "El archivo no ha sido encontrado, por favor intentelo nuevamente"
    echo -e "Recuerde que debe tener el path completo, Ejemplo: /path/del/archivo.txt"
    exit 1

else
    while true; do
      read -p "[+] Pulse 'y' si desea ver el path en pantalla o 'n' si desea crear un archivo con la data:  " option
    
      if [ "$option" == 'y' ]; then
        echo -e "[+] El archivo que buscas se encuentra en: "
        echo -e "\n $file_discover "
        exit 0
      elif [ "$option" == 'n' ]; then
        echo $file_discover > /tmp/find_file.txt
        echo "[+] Se ha guardado la informacion en /tmp/find_file.txt"
        exit 0
      else
        echo "[!] Por favor ingresar una opcion valida, 'y' o 'n'"
      fi
    done

fi
}


function replace_word(){
    
    read -p "Ingrese el archivo que desea modificar, recuerde que debe ser el path completo:" file_change
    read -p "Que parametro quieres modificar? " old_word
    read -p "Introduzca el nuevo parametro: " new_word 
    sed -i "s/$old_word/$new_word/g" "$file_change"

}

function file_size(){
    read -p "Ingrese el archivo que desea conocer el tamano: " file
    du -sh $file

}

if [ $meid -eq 0 ]; then
    while true; do 
        read -p "Por favor ingrese una opcion valida, para ayuda ingrese h: " option

        case $option in
            f) 
                find_file
                break
                ;;
        
            r)
                replace_word
                break
                ;;
        
            s) 
                file_size
                break
                ;;
            
            h)
                helpPanel
                break
                ;;
            
            *)
                echo " "
                echo "[!] Opcion invalida. "
                echo "[+] Para ayuda ingrese h) "
                echo " "
                ;;
        esac
    done

else
    echo "[!] Debes ser usuario root o super usuario para ejecutar este script"
    exit 1

fi


