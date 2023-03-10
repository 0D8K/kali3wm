#!/usr/bin/bash

source plantillas
source tools

i3file=~/.config/i3/config


function i3_install()
{
  informacion "Actualizando apt"
  sudo apt update
  
  informacion "Instalando entorno i3"
  sudo apt install -y i3 i3blocks xorg xinit 
  
  informacion "Copiando archivo de configuración"
  mkdir -p ~/.config/i3/
  cp /etc/i3/config $i3file

  informacion "Agregando español y tecla WIN como meta"
  sed -i "1i exec_always --no-startup-id setxkbmap -layout es" $i3file

  if grep -q "\$mod" ~/.config/i3/config; then
    sed -i '/^set \$mod Mod1$/ s/Mod1/Mod4/' $i3file
  else
    sed -i 's/Mod1/\$mod/g' $i3file
    sed -i '1i set $mod Mod4' $i3file

  fi

  informacion "Quitando bordes"
sudo sed -i '1i\
# ELIMINAR NOMBRE VENTANAS PARA GAPS Y AÑADIENDO MARGEN\
# You can also use any non-zero value if you'\''d like to have a border\
for_window [class=".*"] border pixel 1\
gaps inner 9\
gaps outer 9\
# class                 border  backgr. text    indicator child_border\
client.focused_inactive #0d1010 #212121 #d9d9d9 #0d1010 #063340\
client.unfocused        #0d1010 #212121 #d9d9d9 #424242 #063340\
client.focused          #58ba44 #cecece #000000 #58ba44 #58ba44\n\n' $i3file

}

function install_optional()
{
  informacion "   Instalando... \e[32m$1\e[0m"
  
  IFS=',' read -ra comando <<< "${tools[$1]}"
  sudo apt install $1
  if ! test -z "${comando[1]}"; then
    informacion "Agregando ${comando[1]}"  
    eval ${comando[1]}
  fi

}

function package_selection
{
  if [ "$1" == "y" ]; then
    informacion "Se instalará todo"
    for package in "${!tools[@]}"; do
      install_optional $package
    done
  elif [ $# == 0 ]; then
    informacion "No se seleccionó ningún software adicional"
  else
    informacion "Se instalara lo siguiente:\n"
    for package in $@; do
      if printf '%s\n' "${!tools[@]}" | grep -q $1; then
        install_optional $package
      fi
    done
    
  fi
}


# INICIAMOS
banner "Kali3wm"
i3_install

informacion "Software opcional:"

for tool in "${!tools[@]}"; do
  IFS=',' read -ra values <<< "${tools[$tool]}"
  echo -e "\e[32m$tool\e[0m=> ${values[0]}"
done
consulta "A continuación escriba todos el software a instalar separado por coma o escriba 'y' para instalar todos:\n"
read software
package_selection $software


echo "Finalizado con éxito"
