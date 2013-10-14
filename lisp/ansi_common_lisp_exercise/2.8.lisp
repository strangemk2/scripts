(defun point_recursive (n)
  (if (> n 0)
    (progn
      (format t ".")
      (point_recursive (- n 1)))))

(defun point_iterator (n)
  (do ((i n (- i 1)))
    ((= i 0))
    (format t ".")))

(defun time_recursive (lst)
  (if (not (null lst))
    (+ 1 (time_recursive (cdr lst)))
    0))

(point_recursive 10)
(point_iterator 10)

(time_recursive '(1 2 3))
