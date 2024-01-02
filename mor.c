#include "types.h"
#include "user.h"

//#define PROCS_NUM 5

int main()
{
    int num_of_process=5;
    for (int i = 0; i < num_of_process; ++i)
    {
        int a=fork();
        if(a<0){
            while(wait()!=-1){

            }
        }
        else if(a==0){
            sleep(3000);
            long x=0;
            while(x!=1000000000000){
                
                x++;
            }
            exit();
        }
    }
    exit();

    /*for (int i = 0; i < num_of_process; ++i)
    {
        int pid = fork();
        if (pid > 0)
            continue;
        if (pid == 0)
        {
            sleep(5000);
            for (int j = 0; j < 100 * i; ++j)
            {
                int x = 1;
                for (long k = 0; k < 1000000000000; ++k)
                    x++;
            }
            exit();
        }
    }
    while (wait() != -1)
        ;
    exit();*/

    /*int num_of_process=5;
    for (int i = 0; i < PROCS_NUM; ++i)
    {
        int a=fork();
        if(a<0){
            while(wait()!=-1){

            }
        }
        else if(a==0){
            while(1){
                int x=0;
                x++;
            }
        }
    }*/

}
