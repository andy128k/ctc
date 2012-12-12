sbcl:
	sbcl --noinform --load make-binary.lisp --eval '(make-binary)' --eval '(quit-program)'

ccl:
	lx86cl -l make-binary.lisp -e '(make-binary)' -e '(quit-program)'

ccl64:
	lx86cl64 -l make-binary.lisp -e '(make-binary)' -e '(quit-program)'

clisp:
	clisp -q -x '(load "make-binary.lisp") (make-binary)'

ecl:
	CL_SOURCE_REGISTRY='(:source-registry (:tree (:home "quicklisp/local-projects/")) (:tree (:home "quicklisp/dists/quicklisp/software/")) :inherit-configuration)' \
		ecl \
		-eval '(require :asdf)' \
		-eval '(load "make-binary.lisp")' \
		-eval '(make-binary)' \
		-eval '(ext:quit 0)'

