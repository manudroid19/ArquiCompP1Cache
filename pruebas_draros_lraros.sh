# Primer programa optimizador de resultados

cantidad=0
total=0
gcc -o m m.c -O0 -msse3 -lm

echo -e L'\t'D'\t'resultado'\t'R


for L in 256 768 2048 3072 4096 8192 12000 16384 20000 24000 28000 32768;
do
	for D in 1 5 10 17 23 39 51 76 93 98;
	do
		for N in {1..5};
		do
			./m $L $D 2> /dev/null
			#cantidad=$(($cantidad + $(./m $L $D)))
			#./resultados.out $M $HILOS >> resultados.txt
			#echo " " >> resultados.txt
		#echo $L $D $cantidad >> resultados.txt
	  done
	done
done
