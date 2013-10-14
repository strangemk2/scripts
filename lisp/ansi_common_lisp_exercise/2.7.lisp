(defun islist (lst)
  (if (not (null lst))
    (if (listp (car lst))
      t
      (myfun (cdr lst)))))

(islist '(1 2 3))
(islist '((1 2) 3))
(islist '(1 (2 3)))
