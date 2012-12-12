(in-package :asdf)

(asdf:defsystem "ctc"
    :depends-on (:command-line-arguments :closure-template)
    :components ((:file "ctc")))

