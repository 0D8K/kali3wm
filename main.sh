#!/usr/bin/bash


# Array en el que el primer argumento es la descripción y en la segunda el valor que se agrega a i3 config
declare -A tools=(
  ["nitrogen"]="Fondo de pantalla,exec --no-startup-id nitrogen --restore"
  ["imwheel"]="Corrige giro de la rueda del ratón en vmware,exec --no-startup-id nitrogen --restore"
  ["numlockx"]="Bloquea los números al iniciar,exec --no-startup-id nitrogen --restore"
  ["neovim"]="Editor de texto en consola,exec --no-startup-id nitrogen --restore"
  ["tmux"]="Terminal multiplexer,exec --no-startup-id nitrogen --restore"
  ["network-manager"]="Gestor de red,exec --no-startup-id nitrogen --restore"
  ["picom"]="Software para gestión de transparencias,exec --no-startup-id nitrogen --restore"
  ["git"]="Git,exec --no-startup-id nitrogen --restore"
  ["dmenu"]="Menú minimalista,exec --no-startup-id nitrogen --restore"
  ["notify-osd"]="Notificaciones en popup,exec --no-startup-id nitrogen --restore"
  ["pcmanfm"]="Explorador de archivo,exec --no-startup-id nitrogen --restore"
  ["alsa-utils"]="Audio,exec --no-startup-id nitrogen --restore"
)


function i3_install()
{
  echo "- Actualizando apt"
  sudo apt update
  
  echo "- Instalando entorno i3"
  sudo apt install -y i3-gaps i3blocks xorg xinit 
  
  echo "- Copiando archivo de configuración"
  mkdir -p ~/.config/i3/
  cp /etc/i3/config ~/.config/i3/config
}

function install_optional()
{
  echo -e "   Instalando... \e[32m$package\e[0m"
  sudo apt install $package

  echo "Editando archivo de configuración i3"
  
  IFS=',' read -ra comando <<< "${tools[$package]}"
  echo "Agregando ${comando[1]}"  
  sed -i '1i ${comando[1]}' ~/.config/i3/config

}

function package_selection
{
  if [ "$1" == "y" ]; then
    echo -e "Se instalará todo\n"
  elif [ $# == 0 ]; then
    echo -e "No se seleccionó ningún software adicional"
  else
    echo -e "Se instalara lo siguiente:\n"
    for package in $@; do
      if printf '%s\n' "${!tools[@]}" | grep -q $package; then
        install_optional package
      fi
    done
    
  fi
}


# INICIAMOS
#install
#configure
echo -e "Software opcional:\n"

for tool in "${!tools[@]}"; do
  IFS=',' read -ra values <<< "${tools[$tool]}"
  echo -e "\e[32m$tool\e[0m=> ${values[0]}"
done
echo -e "A continuación escriba todos el software a instalar separado por coma o escriba 'y' para instalar todos:\n"
read software
package_selection $software


echo "Finalizado con éxito"
