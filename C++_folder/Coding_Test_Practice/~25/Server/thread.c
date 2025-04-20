#include <pthread.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>


int a = 0;
pthread_mutex_t mutex;
// mutex 실행 위한 타입


void * thread1(void * arg){

    printf("arg : %d\n", (int)arg);
    while(1){

        pthread_mutex_lock(&mutex);

        printf("thread%d : a[%d]\n", (int)arg, ++a);

        pthread_mutex_unlock(&mutex);
        sleep(2);
        
    }
    return NULL;

    
}

int main(){

    pthread_t s_thread[2];
    // 스레드 핸들러

    int id1 = 77;
    int id2 = 88;

    pthread_mutex_init(&mutex,NULL);
    // mutex init

    pthread_create(&s_thread[0], NULL, thread1, (void*)id1);
    pthread_create(&s_thread[1], NULL, thread1, (void*)id2);

    pthread_join(s_thread[0], NULL);
    pthread_join(s_thread[1], NULL);
    // join을 안하면, main 프로세스가 종료됨에 따라 스레드마저 종료됨.
    // join은 각 스레드 함수 종료시까지 함수를 종료하지 않는 것을 의미함.
    // process 쪽의 wait느낌?

    //pthread_exit(&s_thread[0]); 스레드 종료

}
