#!/bin/sh

echo "Introduce un fichero de ejemplo (con la extension): "
read nombreFichero

while ! [ -f schedsim/examples/$nombreFichero ]; do
	echo "El fichero no existe o no es un fichero regular"
	echo "Introduce un fichero de ejemplo: "
	read nombreFichero
done

echo "Introduce el numero maximo de CPUs: "
read maxCPUs

while [ $maxCPUs -gt 8 ]; do
	echo "El numero de CPUs debe ser menor que 8"
	echo "Introduce el numero maximo de CPUs: "
	read maxCPUs
done

if [ -d "resultados" ]; then
	rm -r resultados
fi

mkdir resultados
cd schedsim

COUNT=1
while [ $COUNT -le $maxCPUs ]; do	
	#FCFS
	./schedsim -i examples/$nombreFichero -s FCFS -n $COUNT
	NUM=0	
	for i in *.log		
		do mv $i ../resultados/FCFS-$i
		cd ../gantt-gplot
		./generate_gantt_chart ../resultados/FCFS-CPU_$NUM.log
		cd ../schedsim
		echo "generado FCFS de $NUM"
		NUM=$((NUM+1))
	done
	
	./schedsim -i examples/$nombreFichero -s PRIO -n $COUNT
	NUM=0	
	for i in *.log
		do mv $i ../resultados/PRIO-$i
		cd ../gantt-gplot
		./generate_gantt_chart ../resultados/PRIO-CPU_$NUM.log
		cd ../schedsim
		NUM=$((NUM+1))	
	done
	
	./schedsim -i examples/$nombreFichero -s RR -n $COUNT
	NUM=0
	for i in *.log
		do mv $i ../resultados/RR-$i
		cd ../gantt-gplot
		./generate_gantt_chart ../resultados/RR-CPU_$NUM.log
		cd ../schedsim
		NUM=$((NUM+1))	
	done
	
	./schedsim -i examples/$nombreFichero -s SJF -n $COUNT
	NUM=0
	for i in *.log
		do mv $i ../resultados/SJF-$i
		cd ../gantt-gplot
		./generate_gantt_chart ../resultados/SJF-CPU_$NUM.log
		cd ../schedsim
		NUM=$((NUM+1))	
	done
	
	COUNT=$((COUNT+1))
done
	














