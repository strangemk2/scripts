; function remove don't change the list but make a new list
(defun summit1 (lst)
  (apply #'+ (remove nil lst)))

; recursive functions need a break point
(defun summit2 (lst)
  (if (not (null lst))
	(let ((x (car lst)))
	  (if (null x)
		(summit2 (cdr lst))
		(+ x (summit2 (cdr lst)))))
	0))
