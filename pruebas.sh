# Primer programa optimizador de resultados

cantidad=0
total=0
gcc -o m m.c -O0 -msse3 -lm

echo -e L'\t'D'\t'resultado'\t'clockRate


for L in 256 768 2048 3072 8192 16384 32768;
do
	for D in 1 2 10 50 90;
	do
		./m $L $D 2> /dev/null
			#cantidad=$(($cantidad + $(./m $L $D)))
			#./resultados.out $M $HILOS >> resultados.txt
			#echo " " >> resultados.txt
		#echo $L $D $cantidad >> resultados.txt
		cantidad=0
	done
done
