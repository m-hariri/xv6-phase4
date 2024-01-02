#include "types.h"
#include "user.h"
int m=0;
// mutex is used to make printf atomic
#define MUTEX 1
#define PROCESS_NUM 5

#define ATOMIC(x) sem_acquire(MUTEX,1); x; sem_release(MUTEX);
void in_remain(int i)
{
    int time = random() % 1000;
    time=400;
    ATOMIC(printf(1, "Process %d is in remain section for %d ticks\n", i, time));
    sleep(time);
}

void in_critical(int i)
{
    int time = random() % 1000;
    time=300;
    ATOMIC(printf(1, "Process %d is in critical section for %d ticks\n", i, time));
    sleep(time);
}

void process(int i, int pid)
{
    set_bjf_priority(pid, pid);
    while (m<5)
    {
        ATOMIC(printf(1, "Process %d wants to enter to the critical section\n", pid));
        sem_acquire(0,i);
        in_critical(pid);

        sem_release(0);
        ATOMIC(printf(1, "Process %d has left critical section\n", pid));
        in_remain(pid);
        m++;
    }
}
void init1()
{
    sem_init(0, 1);
    sem_init(MUTEX, 1);
}

void start1()
{
    for (int i = 0; i < PROCESS_NUM; i++)
        if (fork() == 0)
        {
            srand(getpid());
            process(i,getpid());
            exit();
        }

    for (int i = 0; i < PROCESS_NUM; i++)
        wait();
}

int main()

{
    init1();
    start1();
    exit();
}