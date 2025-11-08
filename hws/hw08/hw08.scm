(define (ascending? s) 
    (cond ((null? s) #f)
          ((null? (cdr s)) #t)
          (else 
            (if (< (car s) (car (cdr s)))
                (ascending? (cdr s))
                #f))))

(define (my-filter pred s)
    (cond ((null? s) s)
          ((pred (car s)) (cons (car s) (my-filter pred (cdr s))))
          (else (my-filter pred (cdr s)))))

(define (interleave lst1 lst2)
    (cond ((null? lst1) lst2)
          ((null? lst2) lst1)
          (else (cons (car lst1) (interleave lst2 (cdr lst1))))))

(define (no-repeats s)
    (begin 
        (define (search-add x s)
            (cond ((null? s) (cons x nil))
                  ((= x (car s)) s)
                  (else (cons (car s) (search-add x (cdr s))))))
        (define (delete-repeat s s_tar)
            (if (null? s)
                s_tar
                (delete-repeat (cdr s) (search-add (car s) s_tar))))
        (delete-repeat s nil)))
