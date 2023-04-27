;;;; papierorgel-projekt.asd

(asdf:defsystem #:papierorgel-projekt
  :description "Eigener Code für Nutzung der Papierorgel"
  :author "Orm Finnendahl <orm.finnendahl@selma.hfmdk-frankfurt.de"
  :depends-on (#:cl-orgelctl #:ats-cuda)
  :license  "Proprietär"
  :version "0.0.1"
  :serial t
  :components ((:file "init")))
