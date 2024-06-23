(include "~~lib/_gambit#.scm")

;; NOTES
;; - dans thread-make-f64vector pour un type connu comme vertex,
;;   le header (+ (* len 2048) (* 29 8) 6) est une constante
;;   total-len aussi est une constante

;; - peut-etre un stack de juste vertex de sorte que les headers
;;   sont deja sette et chaque & dans la fn est juste un index
;;   et on augmente le sp en entre et le reset en sortie

(define ws (##u8vector-length '#(0)))

(define (header-get obj)
  (if (= ws 4)
      (##u32vector-ref obj -1)
      (##u64vector-ref obj -1)))

(define (header-set! obj h)
  (if (= ws 4)
      (##u32vector-set! obj -1 h)
      (##u64vector-set! obj -1 h)))

(define (make-thread-with-stack stack-len thunk)
  (let* ((pt (macro-primordial-thread))
         (thread-len (##vector-length pt))
         (total-len (max 4096 (+ thread-len stack-len)))
         (thread (make-vector total-len #f)))
    (##vector-set! thread 0 (##vector-ref pt 0))
    (header-set! thread
                 (+ (bitwise-and (header-get pt) -4)
                    (bitwise-and (header-get thread) 3)))
    (thread-init! thread thunk)
    (thread-specific-set! thread (+ thread-len 1))
    thread))

(define (thread-sp-get) (thread-specific (current-thread)))
(define (thread-sp-set! sp) (thread-specific-set! (current-thread) sp))

(define (thread-make-f64vector len)
  (let* ((t (current-thread))
         (h (+ (* len 2048) (* 29 8) 6)) ;; permanent f64vector header
         (old-sp (thread-sp-get))
         (obj
          (if (= ws 4)
              (let* ((total-len (fx+ (* len 2) 2))
                     (new-sp (fx+ old-sp total-len)))
                (thread-sp-set! new-sp)
                (##fx+ t old-sp 2))
              (let* ((total-len (fx+ len 1))
                     (new-sp (fx+ old-sp total-len)))
                (thread-sp-set! new-sp)
                (##fx+ t (* old-sp 2))))))
    (header-set! obj h)
    obj))

(define (thread-make-vertex)
  (let* ((t (current-thread))
         (old-sp (thread-specific t))
         (obj
           (let ((new-sp (fx+ old-sp 4)))
             (thread-specific-set! t new-sp)
             (##fx+ t (* old-sp 2)))))
    (header-set! obj 6382)
    obj))

#;
(define (thread-make-f64vector len)
  (let* ((t (##current-thread))
         (h (+ (* len 2048) (* 29 8) 6)) ;; permanent f64vector header
         (old-sp (thread-sp-get))
         (obj
           (let* ((total-len (fx+ len 1))
                  (new-sp (fx+ old-sp total-len)))
             (thread-sp-set! new-sp)
             (##fx+ t (* old-sp 2)))))
    (##u64vector-set! obj -1 h)
    obj))

(define t
  (make-thread-with-stack
   10000
   (lambda ()
     (println "hello!")
     (let ((sp (thread-sp-get)))
       (let* ((v1 (thread-make-f64vector 3))
              (v2 (thread-make-f64vector 3)))
         (##f64vector-set! v1 1 1.111)
         (##f64vector-set! v2 1 2.222)
         (pp (list 'v1= v1))
         (pp (list 'v2= v2))
         (thread-sp-set! sp)
         (println "after reset")
         (let ((v3 (thread-make-f64vector 3)))
           (##f64vector-set! v3 1 3.333)
           (pp (list 'v1= v1))
           (pp (list 'v2= v2))
           (pp (list 'v3= v3))
           (thread-sp-set! sp)))))))

(thread-start! t)

(thread-sleep! 1)
