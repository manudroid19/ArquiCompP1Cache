# Primer programa optimizador de resultados

cantidad=0
total=0
gcc -o m m.c -O0 -msse3 -lm

echo -e L'\t'D'\t'resultado'\t'R


for L in 256 768 2048 3072 8192 16384 32768;
do
	for D in 1 5 12 51 93;
	do
		for N in {1..100};
		do
			./m $L $D 2> /dev/null
			#cantidad=$(($cantidad + $(./m $L $D)))
			#./resultados.out $M $HILOS >> resultados.txt
			#echo " " >> resultados.txt
		#echo $L $D $cantidad >> resultados.txt
	  done
	done
done
