#!/usr/bin/env bash

crearUser() {
	read -p "Nombre de usuario: "  user
	
	if ! id "$user" &> /dev/null; then
		read -p "Comentario: " comment
		read -p "Directorio del usuario: " dir
		read -p "Nombre del directorio del usuario: " userdir
		
		while true; do
		read -s -p "Contraseña: " psswd
		echo ""
		if [[ ${#psswd} -ge 10 && "${psswd}" == *[A-Z]* && "${psswd}" == *[a-z]* && "${psswd}" == *[0-9]* ]]; then
			echo "Vuelva a escribir la contraseña: "
			read -s passwd2
			if test "$psswd" == "$passwd2"; then
				break
			else
				echo "Las contraseñas no coinciden"
			fi
		else
			echo "Contraseña inválida: debe contener al menos 10 caracteres, una mayúscula, una minúscula y un número"
		fi
		done

		useradd "$user" -c "$comment" -m -d "$dir/$userdir" -s /bin/bash
		echo "$user:$psswd" | chpasswd
		chown "$user" "$dir/$userdir"
		echo "Usuario creado con éxito. Los valores del usuario fueron asignados por defecto, para más modificaciones consulte man usermod"
	else
		echo "Usuario existente"
	fi
}


borrarUser() {
	read -p "Usuario que desea eliminar: " user
	if ! id "$user" &> /dev/null; then
		echo "El usuario no existe"
	else
		deluser "$user"
		read -p "¿Desea eliminar la carpeta del usuario? [y/n] " opcion
		if test "$opcion" == "y"; then
			read -p "Introduzca la ruta a la carpeta del usuario: " dir
			rm -r "$dir"
		fi
	fi	
}		

select op in "crear" "borrar" "salir"; do
	if [ "$op" = "crear" ] ; then
		crearUser; exit
	elif [ "$op" = "borrar" ]; then
		borrarUser; exit
	elif [ "$op" = "salir" ]; then
		exit
	fi
done
