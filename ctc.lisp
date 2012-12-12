(in-package :common-lisp-user)

(defun save-file (filename content)
  (if filename
      (with-open-file (out filename
			   :direction :output
			   :if-exists :supersede
			   :if-does-not-exist :create)
	(write-string content out)) 
      (write-string content *standard-output*)))

(defun quit-program ()
  #+sbcl (sb-ext:exit)
  #+clozure (ccl:quit)
  #+clisp (ext:quit)
  #+ecl (ext:quit 0))

(defmacro catch-all (&body body)
  `(handler-case
       (progn
	 ,@body)
     #+clozure (ccl:process-reset ())
     (t (se)
       (format t "~A~%" se)
       (quit-program))))

(defparameter *opt-spec*
  '((("output" #\o) :type string :documentation "Write to file instead of standard output.")
    (("lang" #\l) :type string :documentation "Output language (js, requirejs, python). JavaScript is default language.")
    (("help" #\h) :type nil :documentation "Display this help.")))

(defun print-usage-and-die (&optional error &rest params)
  (when error
    (apply #'format t error params)
    (format t "~%~%"))
  (format t "Usage: ctc [options] <file> [<file> ...]~%~%Options:~%")
  (command-line-arguments:show-option-help *opt-spec*)
  (quit-program))

(defun create-backend (lang)
  (cond
    ((or (null lang)
	 (string= lang "js")) :javascript-backend)
    ((string= lang "requirejs") :requirejs-backend)
    ((string= lang "python") :python-backend)
    (t (print-usage-and-die "Unknown language '~A'." lang))))

(defun main ()
  (catch-all

   (multiple-value-bind (options arguments)
       (command-line-arguments:compute-and-process-command-line-options *opt-spec*)

     (when (member :help options)
       (print-usage-and-die))

     (let ((backend (create-backend (second (member :lang options))))
	   (output (second (member :output options)))
	   (input (mapcar #'parse-namestring arguments)))

       (if input
	   (save-file output
		      (closure-template:compile-template backend
							 input))
	   (print-usage-and-die "No input files specified.")))))

  (quit-program))

#+ecl
(main)

