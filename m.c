#include <stdio.h>
#include <stdlib.h>
#include <pmmintrin.h>
#include <time.h>
#include <unistd.h>

#define S1 512
#define S2 4096

void start_counter();
double get_counter();
double mhz();


/* Initialize the cycle counter */


 static unsigned cyc_hi = 0;
 static unsigned cyc_lo = 0;


 /* Set *hi and *lo to the high and low order bits of the cycle counter.
 Implementation requires assembly code to use the rdtsc instruction. */
 void access_counter(unsigned *hi, unsigned *lo){
 	asm("rdtsc; movl %%edx,%0; movl %%eax,%1" /* Read cycle counter */
 	: "=r" (*hi), "=r" (*lo) /* and move results to */
 	: /* No input */ /* the two outputs */
 	: "%edx", "%eax");
}

 /* Record the current value of the cycle counter. */
 void start_counter(){
 	access_counter(&cyc_hi, &cyc_lo);
 }

 /* Return the number of cycles since the last call to start_counter. */
 double get_counter(){
 	unsigned ncyc_hi, ncyc_lo;
 	unsigned hi, lo, borrow;
 	double result;

 	/* Get cycle counter */
 	access_counter(&ncyc_hi, &ncyc_lo);

	 /* Do double precision subtraction */
	 lo = ncyc_lo - cyc_lo;
	 borrow = lo > ncyc_lo;
	 hi = ncyc_hi - cyc_hi - borrow;
	 result = (double) hi * (1 << 30) * 4 + lo;
	 if (result < 0) {
	 fprintf(stderr, "Error: counter returns neg value: %.0f\n", result);
	 }
	 return result;
 }

double mhz(int verbose, int sleeptime){
	 double rate;

	 start_counter();
	 sleep(sleeptime);
	 rate = get_counter() / (1e6*sleeptime);
	 if (verbose)
	 	printf("\n Processor clock rate = %.1f MHz\n", rate);
	 return rate;
 }




int main(int argc, char** argv ){
  int L,D;
  if(argc > 1){
    L = atoi(argv[1]);
    D = atoi(argv[2]);
  }else
    exit(0);
  int R= (L*64-8+16*D)/(8*D);
	double *A=_mm_malloc(((R-1)*D+1)*sizeof(double),64);

  srand ( time ( NULL));
  for(int i=0;i<(R-1)*D+1;i++)
    A[i]=(double)rand()/RAND_MAX+1.0;


  double S[10];
  int E[R];
  for(int i=0;i<R;i++){
    E[i]=D*i;
  }
	start_counter();

  for(int i=0;i<10;i++){
    S[i]=0;
    for(int j=0;j<R;j++){
      S[i]=S[i]+A[E[i]];
    }
  }

	double ck=get_counter();
  for(int i=0;i<10;i++){
    printf("S[%d]=%lf\n",i,S[i]);
  }
	printf("\n Clocks=%1.10lf \n",ck);

	/* Esta rutina imprime a frecuencia de reloxo estimada coas rutinas start_counter/get_counter */
	mhz(1,1);


	_mm_free(A);
	return EXIT_SUCCESS;
}
