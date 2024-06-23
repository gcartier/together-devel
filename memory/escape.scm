(define (call-with-catcher thunk)
  (##first-argument (thunk))) ;; trick to force non-tail call to thunk

(define (unwind-to-catcher thunk)
  ;; will unwind continuation to catcher and continue with a call to thunk
  (##continuation-capture
    (lambda (cont)
      (let loop ((cont cont))
        (if cont
            (let ((creator (##continuation-creator cont)))
              (if (##eq? creator call-with-catcher)
                  (##continuation-graft cont thunk)
                (loop (##continuation-next! cont))))
          (error "not nested in a call to call-with-catcher"))))))

;; test it:

(define (deep n)
  (if (> n 0)
      (begin
        (println n)
        (if (= n 42) ;; cause an escape at 42
            (unwind-to-catcher
              (lambda ()
                (println "escaping!"))))
        (deep (- n 1))
        (println n)
        )))

(call-with-catcher (lambda () (deep 3)))

(call-with-catcher (lambda () (deep 50)))

(deep 50)

;; Output:
;;
;; $ gsc -exe escape.scm
;; $ ./escape
;; 3
;; 2
;; 1
;; 1
;; 2
;; 3
;; 50
;; 49
;; 48
;; 47
;; 46
;; 45
;; 44
;; 43
;; 42
;; escaping!
;; 50
;; 49
;; 48
;; 47
;; 46
;; 45
;; 44
;; 43
;; 42
;; *** ERROR IN deep -- not nested in a call to call-with-catcher
