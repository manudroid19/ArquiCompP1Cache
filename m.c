#include <stdio.h>
#include <stdlib.h>
#include <pmmintrin.h>
#include <time.h>
#include <unistd.h>
#include <float.h>
#include <math.h>

#define S1 512
#define S2 4096
#define N 3
void start_counter();
double get_counter();
double mhz();
double geometricMean(double arr[], int n);



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
	 	printf("%.1f\t", rate);
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


  double S[N];
  int E[R];
  for(int i=0;i<R;i++){
    E[i]=D*i;
  }
  double mejores[3]={DBL_MAX,DBL_MAX,DBL_MAX};
  for(int i=0;i<N;i++){
    S[i]=0;
    start_counter();
    for(int j=0;j<R;j++){
      S[i]=S[i]+A[E[j]];
    }
    double ck=get_counter()/R;
    fprintf(stderr, "ck[%d]=%lf\n",i,ck);
    if(ck<mejores[0]){
      mejores[2]=mejores[1];
      mejores[1]=mejores[0];
      mejores[0]=ck;
    }else if(ck<mejores[1]){
      mejores[2]=mejores[1];
      mejores[1]=ck;
    }else if(ck<mejores[2]){
      mejores[2]=ck;
    }
  }
  double gm = geometricMean(mejores,3);
  printf("%d\t%d\t%lf\t",L,D, gm);
  mhz(1,1);
  printf("%d\n",R);

  for(int i=0;i<N;i++){
    fprintf(stderr, "S[%d]=%lf\n",i,S[i]);
  }
	//printf("\n Clocks=%1.10lf \n",ck);

	

	_mm_free(A);
	return EXIT_SUCCESS;
}
double geometricMean(double arr[], int n) {
    // declare product variable and
    // initialize it to 1.
    double product = 1;

    // Compute the product of all the
    // elements in the array.
    for (int i = 0; i < n; i++)
        product = product * arr[i];

    // compute geometric mean through formula
    // pow(product, 1/n) and return the value
    // to main function.
    double gm = pow(product, (double)1 / n);
    return gm;
}
