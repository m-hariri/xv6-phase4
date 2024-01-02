#include "types.h"
#include "user.h"

void help()
{
    printf(1, "Commands and Arguments:\n");
    printf(1, "  1 : print\n");
    printf(1, "  2 <pid> <new_queue> : set_queue \n");
    printf(1, "  3 <pid> <priority_ratio> <arrival_time_ratio> <executed_cycle_ratio> : set_process_bjf \n");
    printf(1, "  4 <priority_ratio> <arrival_time_ratio> <executed_cycle_ratio> : set_system_bjf \n");
    printf(1, "  5  <pid> <priority> : set_priority_bjf\n");
}

int main(int argc, char *argv[])
{
    if (argc < 2)
    {
        help();
        exit();
    }
    if (!strcmp(argv[1], "1"))
    {
        print_process_info();
    }
    else if (!strcmp(argv[1], "2"))
    {
        if (argc < 4)
        {
            help();
            exit();
        }
        int pid = atoi(argv[2]);
        int newQ = atoi(argv[3]);
        if (newQ < 1 || newQ > 3)
        {
            printf(1, "Invalid queue\n");
            exit();
        }
        change_scheduling_queue(pid, newQ);
    }
    else if (!strcmp(argv[1], "3"))
    {
        if (argc < 6)
        {
            help();
            exit();
        }
        int pid  = atoi(argv[2]);
        int priority_ratio=atoi(argv[3]);
        int arrival_time_ratio= atoi(argv[4]);
        int executed_cycle_ratio=atoi(argv[5]);
        set_bjf_params_process(pid, priority_ratio, arrival_time_ratio, executed_cycle_ratio);
    }
    else if (!strcmp(argv[1], "4"))
    {
        if (argc < 5)
        {
            help();
            exit();
        }
        int priority_ratio=atoi(argv[2]);
        int arrival_time_ratio= atoi(argv[3]);
        int executed_cycle_ratio=atoi(argv[4]);
        set_bjf_params_system(priority_ratio, arrival_time_ratio, executed_cycle_ratio);
    }
    else if (!strcmp(argv[1], "5"))
    {
        if (argc < 4)
        {
            help();
            exit();
        }
        int pid =atoi(argv[2]);
        int priority=atoi(argv[3]);
        set_bjf_priority(pid, priority);
    }
    else
        help();
    exit();
}
