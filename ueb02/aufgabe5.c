/**
 * @file aufgabe5.c
 * @author Gregor N. (@), Till R. (@ritterrost), Luis S. (@lsg551)
 * @brief Aufgabenbearbeitung zu Aufgabe 5 des Übungsblattes 2 vom 04.05.2021
 * @version 0.1
 * @date 10.05.2021
 * @copyright Copyright (c) 2021
 */

#include <stdio.h>
#include <unistd.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <sys/stat.h>
#include <string.h>

/**
 * @brief Entry point 
 * Aufgabe :
 * Parent erzeugt Child und teilt mit diesem via SM die pid des Kindes.
 * Child gleicht diese mit seiner ab, gibt Antwort an Parent.
 */
int main(int argc, char *argv[])
{
    int sharedMemoryId = shmget(IPC_PRIVATE, 300, S_IRUSR | S_IWUSR);
    int forkId = fork();

    if (forkId <= -1)
    { // error
        printf("Creating a child process was unsuccessful");
    }
    else if (forkId == 0)
    { // child process
        char *sharedMemory = (char *)shmat(sharedMemoryId, NULL, 0);
        // read pid sent from parent
        char ownPidFromSharedMemory = *sharedMemory;
        // get own pid
        int ownPid = getpid();
        // evaluate
        if ((int)ownPidFromSharedMemory == (int)ownPid)
        {
            sprintf(sharedMemory, "OK");
        }
        else
        {
            sprintf(sharedMemory, "FALSE");
        }
        // detach
        shmdt(sharedMemory);
    }
    else
    { // parent process
        char *sharedMemory = (char *)shmat(sharedMemoryId, NULL, 0);
        // get pid of child
        int childPid = getpid();
        // send child pid to sm
        sprintf(sharedMemory, (char *)childPid);
        // read answer
        char answer = *sharedMemory;
        // process answer
        if (strcmp(answer, "OK") == 0)
        {
            printf("Evaluation succeeded: pid are equal");
        }
        else if (strcmp(answer, "FALSE") == 0)
        {
            printf("Evaluation succeeded: pid are not equal");
        }
        else
        { // error
            printf("Unable to evaluate");
        }
        // detach
        shmdt(sharedMemory);
    }

    return 0;
}