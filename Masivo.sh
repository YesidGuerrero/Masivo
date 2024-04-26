#! /bin/sh

#Guardamos la ruta donde se ubican los archivos rinex
carpeta="/home/yesid-guerrero/Documentos/RINEX"


#Creamos un array vacio
Estaciones=()

#Recorremos la carpeta y guardamos en el array las estaciones que se encuentran para procesar
for archivo_path in "$carpeta"/*; do
	#Seleccionamos el nombre de cada archivo
	archivo=$(basename "$archivo_path")
	#echo "$archivo"
	#seleccionamos solo el nombre base del archivo es decir sin la extension
	Primeras8_letras=$(echo "$archivo" | cut -c 1-8)
	#echo "$ultimas_letras"@
	#Comparamos el nombre del archivo con los elementos del array si no existe se agrega al array
	if [[ ! " ${Estaciones[@]} " =~ " ${Primeras8_letras} " ]]; then
		# If not, add it to the array
		Estaciones+=("$Primeras8_letras")
	fi
done

#Cuenta la cantidad de estaciones en la carpeta
Cantidad_Estaciones=${#Estaciones[@]}
echo "En la carpeta se encuentran $Cantidad_Estaciones estaciones para procesar"

#terminaciones archivos
obs=".24o.gz"
nav=".24n.gz"
sal=".xtr"
ima=".png"
Carpeta_Salida=$(pwd)

#Ejecuta el comando para cada estación guardada en el arreglo
for e in "${!Estaciones[@]}";do
	Observado="${Estaciones[$e]}${obs}"
	Navegado="${Estaciones[$e]}${nav}"
	Salida="${Estaciones[$e]}${sal}"
	Imagen="${Estaciones[$e]}${ima}"
	
	Comando_a_correr="anubis :inp:rinexn $carpeta/$Navegado :inp:rinexo $carpeta/$Observado :out:xtr $Salida :qc:sec_mpx=2 :qc:sec_snr=2 :qc:sec_est=2 :qc:sec_sum=1"
	
	echo "Ejecutando Comando con: ${Estaciones[$e]}"
	$Comando_a_correr

	Comando_plotear="/home/yesid-guerrero/Documentos/Anubis/plot_Anubis-2.3-2023-03-06/plot_Anubis.pl --ifile $Carpeta_Salida/$Salida --plot=$Imagen --all --all --title=$Salida"
	echo "Ejecutando Comando con: ${Estaciones[$e]}"
	$Comando_plotear

done


