#include "types.h"
#include "user.h"


#define LEFT(i) i
#define RIGHT(i) (i + 1) % 5

// mutex is used to make printf atomic
#define MUTEX 5
#define PROCESS_NUM 3
#define ATOMIC(x)       \
    sem_acquire(MUTEX); \
    x;                  \
    sem_release(MUTEX);

void waitUntilHungry(int i)
{
    int time = random() % 1000;
    ATOMIC(printf(1, "Philosopher %d will be thinking for %d ticks\n", i, time));
    sleep(time);
}

void eatUntilFull(int i)
{
    int time = random() % 1000;
    ATOMIC(printf(1, "Philosopher %d will be eating for %d ticks\n", i, time));
    sleep(time);
}

void init()
{
    for (int i = 0; i < 5; i++)
        sem_init(i, 1);
    sem_init(MUTEX, 1);
}

void pickup(int i)
{
    if (i % 2 == 0)
    {
        ATOMIC(printf(1, "Philosopher %d is going to pick up the left fork first\n", i));
        sem_acquire(LEFT(i));
        ATOMIC(printf(1, "Philosopher %d is going to pick up the right fork\n", i));
        sem_acquire(RIGHT(i));
    }
    else
    {
        ATOMIC(printf(1, "Philosopher %d is going to pick up the right fork first\n", i));
        sem_acquire(RIGHT(i));
        ATOMIC(printf(1, "Philosopher %d is going to pick up the left fork\n", i));
        sem_acquire(LEFT(i));
    }
    ATOMIC(printf(1, "Philosopher %d has picked up both forks\n", i));
}

void putdown(int i)
{
    sem_release(LEFT(i));
    sem_release(RIGHT(i));
    ATOMIC(printf(1, "Philosopher %d has put down both forks\n", i));
}

void philosopher(int i)
{
    while (1)
    {
        pickup(i);
        eatUntilFull(i);
        putdown(i);
        waitUntilHungry(i);
    }
}

void start()
{
    for (int i = 0; i < 5; i++)
        if (fork() == 0)
        {
            srand(getpid());
            philosopher(i);
            exit();
        }

    for (int i = 0; i < 5; i++)
        wait();
}

void waitUntilHungry1(int i)
{
    int time = random() % 1000;
    ATOMIC(printf(1, "Process %d is in remain section for %d ticks\n", i, time));
    sleep(time);
}

void eatUntilFull1(int i)
{
    int time = random() % 1000;
    ATOMIC(printf(1, "Process %d is in critical section for %d ticks\n", i, time));
    sleep(time);
}

void philosopher1(int i, int pid)
{
    while (1)
    {
        ATOMIC(printf(1, "Process %d is about to enter to the critical section\n", pid));
        sem_acquire(1);
        eatUntilFull1(pid);

        sem_release(1);
        ATOMIC(printf(1, "Process %d has left critical section\n", pid));
        waitUntilHungry1(pid);
    }
}
void init1()
{
    sem_init(1, 1);
    sem_init(MUTEX, 1);
}

void start1()
{
    for (int i = 0; i < PROCESS_NUM; i++)
        if (fork() == 0)
        {
            srand(getpid());
            philosopher1(i,getpid());
            exit();
        }


    //  int time =100;
    // if (fork() == 0)
    // {
    //     srand(getpid());
    //     ATOMIC(printf(1, "Process %d is about to enter to the critical section\n", getpid()));
    //     sem_acquire(2);
    //     time = 500;
    //     ATOMIC(printf(1, "Process %d is in critical section for %d ticks\n", getpid(), time));
    //     sleep(time);
    //     // eatUntilFull1(getpid());

    //     sem_release(1);
    //     ATOMIC(printf(1, "Process %d has left critical section\n", getpid()));
    //     time = 200;
    //     ATOMIC(printf(1, "Process %d is in remain section for %d ticks\n", getpid(), time));
    //     sleep(time);
    //     // waitUntilHungry1(getpid());

    //     exit();
    // }

    // if (fork() == 0)
    // {
    //     srand(getpid());
    //     ATOMIC(printf(1, "Process %d is about to enter to the critical section\n", getpid()));
    //     sem_acquire(3);
    //     time = 200;
    //     ATOMIC(printf(1, "Process %d is in critical section for %d ticks\n", getpid(), time));
    //     sleep(time);
    //     // eatUntilFull1(getpid());

    //     sem_release(1);
    //     ATOMIC(printf(1, "Process %d has left critical section\n", getpid()));
    //     time = 200;
    //     ATOMIC(printf(1, "Process %d is in remain section for %d ticks\n", getpid(), time));
    //     sleep(time);
    //     // waitUntilHungry1(getpid());

    //     exit();
    // }

    // if (fork() == 0)
    // {
    //     srand(getpid());
    //     ATOMIC(printf(1, "Process %d is about to enter to the critical section\n", getpid()));
    //     sem_acquire(1);
    //     time = 1000;
    //     ATOMIC(printf(1, "Process %d is in critical section for %d ticks\n", getpid(), time));
    //     sleep(time);
    //     // eatUntilFull1(getpid());

    //     sem_release(1);
    //     ATOMIC(printf(1, "Process %d has left critical section\n", getpid()));
    //     time = 200;
    //     ATOMIC(printf(1, "Process %d is in remain section for %d ticks\n", getpid(), time));
    //     sleep(time);
    //     // waitUntilHungry1(getpid());

    //     exit();
    // }

    for (int i = 0; i < PROCESS_NUM; i++)
        wait();
}

int main()
{
    init1();
    start1();
    exit();
    // init();
    // start();
    // exit();
}




















// Counting semaphores.

#include "types.h"
#include "defs.h"
#include "spinlock.h"
#include "param.h"
#include "semaphore.h"
// #include "proc.h"

struct semaphore sems[NSEMS];

void semaphore_init(struct semaphore *sem, int value, char *name)
{
  sem->value = value;
  initlock(&sem->lk, "semaphore");
  memset(sem->waiting, 0, sizeof(sem->waiting));
  memset(sem->holding, 0, sizeof(sem->holding));
  sem->wfirst = 0;
  sem->wlast = 0;
  sem->name = name;
}

// void
// semaphore_acquire(struct semaphore* sem)
// {
//   // struct proc * m= myproc();

//   acquire(&sem->lk);
//   --sem->value;
//   if(sem->value < 0){
//     sem->waiting[sem->wlast] =  myproc();
//     sem->wlast = (sem->wlast + 1) % NELEM(sem->waiting);
//     sleep(sem, &sem->lk);
//   }
//   struct proc* p = myproc();
//   for(int i = 0; i < NELEM(sem->holding); ++i){
//     if(sem->holding[i] == 0){
//       sem->holding[i] = p;
//       break;
//     }
//   }
//   release(&sem->lk);
// }

void semaphore_acquire(struct semaphore *sem, int prio)
{

  // struct proc * m= myproc();
  // myproc()->schedule_status.priority = prio;

  acquire(&sem->lk);
  --sem->value;
  if (sem->value < 0)
  {

    sem->waiting[sem->wlast] = myproc();
    sem->wlast = (sem->wlast + 1) % NELEM(sem->waiting);

    // for (int i = 0; i < sem->wlast; i++)
    // {
    //   ATOMIC(printf(1, "BEFORE-----list: %d one is process %d \n", i, sem->waiting[i]->pid));
    // }

    // for (int i = 0; i < sem->wlast - 1; i++)
    // {
    //   for (int j = i + 1; j < sem->wlast; j++)
    //   {
    //     if (sem->waiting[i]->schedule_status.priority < sem->waiting[j]->schedule_status.priority)
    //     {
    //       struct proc *temp = sem->waiting[i];
    //       sem->waiting[i] = sem->waiting[j];
    //       sem->waiting[j] = temp;
    //     }
    //   }
    // }

    // for (int i = 0; i < sem->wlast; i++)
    // {
    //   ATOMIC(printf(1, "AFTER-----list: %d one is process %d \n", i, sem->waiting[i]->pid));
    // }
    sleep(sem, &sem->lk);
  }
  struct proc *p = myproc();
  for (int i = 0; i < NELEM(sem->holding); ++i)
  {
    if (sem->holding[i] == 0)
    {
      sem->holding[i] = p;
      break;
    }
  }
  release(&sem->lk);
}

void semaphore_release(struct semaphore *sem)
{
  acquire(&sem->lk);
  ++sem->value;
  if (sem->value <= 0)
  {
    wakeupproc(sem->waiting[sem->wfirst]);
    sem->waiting[sem->wfirst] = 0;
    sem->wfirst = (sem->wfirst + 1) % NELEM(sem->waiting);
  }
  struct proc *p = myproc();
  for (int i = 0; i < NELEM(sem->holding); ++i)
  {
    if (sem->holding[i] == p)
    {
      sem->holding[i] = 0;
      break;
    }
  }
  release(&sem->lk);
}

int semaphore_holding(struct semaphore *sem)
{
  struct proc *p = myproc();
  for (int i = 0; i < NELEM(sem->waiting); ++i)
  {
    if (sem->holding[i] == p)
    {
      return 1;
    }
  }
  return 0;
}

void sem_init(int id, int value)
{
  semaphore_init(&sems[id], value, "semaphore");
}

// void
// sem_acquire(int id)
// {
//   semaphore_acquire(&sems[id]);
// }

void sem_acquire(int prio)
{
  semaphore_acquire(&sems[1], prio);
}

void sem_release(int id)
{
  semaphore_release(&sems[id]);
}
