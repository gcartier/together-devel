#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <sys/ioctl.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>

#define SERVER "35.185.42.205"
#define BUFLEN 1432
#define PORT 60000

int main(void)
{
  struct sockaddr_in si_other;
  int s, slen=sizeof(si_other);
  char buf[BUFLEN];
  char message[BUFLEN];
    
  if ( (s=socket(AF_INET, SOCK_DGRAM, 0)) < 0)
  {
    printf("socket() failed with error code : %d" , errno);
    exit(-1);
  }
 
  /*
  int optVal;
  int optLen = sizeof(optVal);

  getsockopt(s, SOL_SOCKET, SO_SNDBUF, &optVal, &optLen);
  printf("send buffer size = %d\n", optVal);
 
  optVal = 0;
  setsockopt(s, SOL_SOCKET, SO_SNDBUF, &optVal, &optLen);
 
  getsockopt(s, SOL_SOCKET, SO_SNDBUF, &optVal, &optLen);
  printf("send buffer size = %d\n", optVal);
  */

  int iResult;
  u_long iMode = 1;
  iResult = ioctl(s, FIONBIO, &iMode);
  if (iResult < 0)
    printf("ioctlsocket failed with error: %d\n", iResult);
  
  memset((char *) &si_other, 0, sizeof(si_other));
  si_other.sin_family = AF_INET;
  si_other.sin_port = htons(PORT);
  si_other.sin_addr.s_addr = inet_addr(SERVER);
  
  int i;
  int n;
  for (i = 0; i < 100000000; i++)
  {
    n = sendto(s, message, BUFLEN , MSG_DONTWAIT , (struct sockaddr *) &si_other, slen);
    if (n < 0)
      printf("****\n");
  }

  close(s);

  return 0;
}
