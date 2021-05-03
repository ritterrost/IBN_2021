#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <cassert>
#define NUM_THREADS 3

void *TaskCode(void *argument){
    int tid; tid = *((int *) argument);
    int* next_argument = ((int*) argument) + 1; 
    *next_argument = *((int *) argument); 
    printf("It's me, dude! I am number %d!\n", tid);
    return NULL;
}

int main(int argc, char *argv[]){
    pthread_t threads[NUM_THREADS];
    int thread_args[NUM_THREADS + 1]; int rc, i;

    for (i=0; i<NUM_THREADS; ++i){
        thread_args[i] = i;
        printf("In main: creating thread %d\n", i);
        rc = pthread_create(&threads[i], NULL, TaskCode, (void*) &thread_args[i]);
        assert(0 == rc);
    }
    
        for(i = 0; i<NUM_THREADS; ++i){
        rc = pthread_join (threads[i], NULL);
        assert (0 == rc);
    }
   
    for (int i = 1; i<NUM_THREADS+1; ++i){
        int s = thread_args[0];
        assert(thread_args[i] == s  && "the assertion failed!"); 
    }

    exit(EXIT_SUCCESS);
}



