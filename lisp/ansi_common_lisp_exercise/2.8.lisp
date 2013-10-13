; 接受一个列表，并返回 a 在列表里所出现的次数。

(defun atimes_recursive (lst)
  (if (not (null lst))
	(if (eql 'a (car lst))
	  (+ 1 (atimes_recursive (cdr lst)))
	  (atimes_recursive (cdr lst)))
	0))

(defun atimes_iterator (lst)
  (let ((n 0))
	(dolist (obj lst)
	  (if (eql 'a obj)
		(setf n (+ n 1))))
	n))

(atimes_recursive '(a b c a a b d a))
(atimes_iterator '(a b c a a b d a))
