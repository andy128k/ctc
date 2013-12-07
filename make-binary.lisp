#-ecl
(asdf:load-system 'ctc)

(defun make-binary (&optional (filename "ctc"))
  #+sbcl
  (progn
    (setf asdf/image:*image-entry-point* 'main)
    (asdf/image:dump-image "ctc" :executable t))

  #+nil
  (sb-ext:save-lisp-and-die filename
			    #+sb-core-compression :compression #+sb-core-compression t
			    :executable t
			    :toplevel 'main
			    :purify t)
  
  #+clozure
  (ccl:save-application filename
			:prepend-kernel t
			:toplevel-function 'main)

  #+clisp
  (ext:saveinitmem filename
		   :init-function 'main
		   :executable 0
		   :quiet t
		   :norc t)

  #+ecl
  (let ((tmp (asdf:make-build :ctc
			      :type :program
			      :monolithic t
			      :move-here "./"
			      :prologue-code '(setf
					       c::*load-verbose* nil
					       c::*compile-verbose* nil))))
    (si:system (format nil "mv ~A ~A" (first tmp) filename)))

  #-(or sbcl clozure clisp ecl)
  (error "Unsupported CL implementation"))

