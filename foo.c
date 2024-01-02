#include "types.h"
#include "user.h"

#define PROCS_NUM 5

int main()
{
    int num_of_process = 5;
    for (int i = 0; i < num_of_process; ++i)
    {
        int pid = fork();
        if (pid > 0)
            continue;
        if (pid == 0)
        {
            sleep(5000);
            long y = 0;
            while (y != 1000000)
            {
                long x = 0;
                while (x != 1000000000000)
                {
                    x++;
                }
                y++;
            }

            exit();
        }
    }
    while (wait() != -1)
        ;
    exit();
}
