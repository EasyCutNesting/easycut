(defun CheckSelfIntersectShape (ename / LWP:_intersect LWP:_unique LWP:_pts
										obj parts n i j closed tol
										o1 o2 raw pts res)



	(defun LWP:_intersect (o1 o2 / r)

		(setq r
			(vl-catch-all-apply
				'vla-IntersectWith
				(list o1 o2 acExtendNone)
			)
		)
		(if (vl-catch-all-error-p r)
			nil
			r
		)
	)
	;
	;
	(defun LWP:_unique (lst tol / p out)

		(foreach p lst
			(if (not
					(vl-some
						'(lambda (q) (equal p q tol))
						out
					)
				)
				(setq out (cons p out))
			)
		)

		(reverse out)
	)
	;
	;
	(defun LWP:_pts (v / LWP:_unwrap
						 l out)

		(defun LWP:_unwrap (v)
			(cond
				((null v) nil)
				;; error ActiveX
				((vl-catch-all-error-p v) nil)
				;; Variant wrapper
				((= (type v) 'VARIANT)
					(LWP:_unwrap (vlax-variant-value v)))
					;; SAFEARRAY
				((= (type v) 'SAFEARRAY)
					(if (and v
						(>= (vlax-safearray-get-u-bound v 1)
							(vlax-safearray-get-l-bound v 1)))
						(vlax-safearray->list v)
						nil
					)
				)
				;; already list
				((listp v) v)
				(T nil)
			)
		)
		;
		; Main +++++
		;
		(setq l (LWP:_unwrap v))
		(if (and l (listp l))
			(progn
				(while (and l (>= (length l) 3))
					(setq out
						(cons
							(list (car l) (cadr l) (caddr l))
							out
						)
					)
					(setq l (cdddr l))
				)
				(reverse out)
			)
			nil
		)
	)	
	;
	; Main
	;
	(setq tol 1e-8)

	(setq obj (vlax-ename->vla-object ename))
	(setq closed (= :vlax-true (vla-get-Closed obj)))

	;; explode in memory
	(setq parts (vlax-safearray->list (vlax-variant-value (vla-Explode obj))))
	(setq n (length parts))
	(setq i 0)

	(while (< i n)

		(setq j (+ i 2))

		(while (< j n)

			(setq o1 (nth i parts))
			(setq o2 (nth j parts))

			;; skip adiacenti
			(if (not
				(or (= (abs (- i j)) 1)
					(and closed
						(= (min i j) 0)
						(= (max i j) (1- n)))))

					(progn

						;; safe intersect
						(setq raw (LWP:_intersect o1 o2))
						;; safe unwrap → points
						(setq pts (LWP:_pts raw))
						;; accumulate
						(if pts
							(foreach p pts
								(setq res (cons p res))
							)
						)
					)
			)
			(setq j (1+ j))
		)

		(setq i (1+ i))
	)
	;; cleanup
	(foreach o parts (vla-delete o))
	;; final unique
	(LWP:_unique res tol)
)
;

