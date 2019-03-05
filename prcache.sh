# Primer programa optimizador de resultados


gcc -o m_papi -Ipapi_bin/include m_papi.c -Lpapi_bin/lib -O0 -msse3 -lm -lpapi
mkdir papiStat$1
for medida in PAPI_L1_TCM PAPI_L2_TCM PAPI_L3_TCM PAPI_L2_TCA PAPI_L3_TCA PAPI_LD_INS PAPI_SR_INS;
do
	echo -e L'\t'D'\t'resultado'\t'R'\t'$medida'\t'fallo | tee papiStat$1/rPapi_$medida.csv


	for L in 256 768 2048 3072 8192 16384 32768;
	do
		for D in 1 5 12 51 93;
		do
			for N in {1..10};
			do
				./m_papi $L $D $medida 2> /dev/null | tee -a papiStat$1/rPapi_$medida.csv
		  done
		done
	done
done
