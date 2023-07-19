(define ctest
  (c-lambda () void
#<<c-end

#ifdef USE_setitimer
    printf("USE_setitimer\n");
#endif
#ifdef USE_dos_setvect_1Ch
    printf("USE_dos_setvect_1Ch\n");
#endif
#ifdef USE_DosStartTimer
    printf("USE_DosStartTimer\n");
#endif
#ifdef USE_VInstall
    printf("USE_VInstall\n");
#endif
#ifdef USE_CreateThread
    printf("USE_CreateThread\n");
#endif

#ifdef CALL_HANDLER_AT_EVERY_POLL
    printf("CALL_HANDLER_AT_EVERY_POLL\n");
#endif

#ifdef ___HEARTBEAT_USING_POLL_COUNTDOWN
    printf("___HEARTBEAT_USING_POLL_COUNTDOWN\n");
#endif

#ifdef ___POLL
    printf("___POLL\n");
#endif

c-end
))

(ctest)
