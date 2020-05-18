(define-module (clojure)
  #:use-module (guix licenses)
  #:use-module (guix packages)
  #:use-module (guix build-system gnu)
  #:use-module (guix download)
  #:use-module (gnu packages readline)
  #:use-module (gnu packages java))

(define-public clojure-tools
  (package
    (name "clojure-tools")
    (version "1.10.1.536")
    (source (origin
              (method url-fetch)
              (uri
               (string-append
                "https://download.clojure.org/install/clojure-tools-" version ".tar.gz"))
              (sha256
               (base32
                "06bibxymmkmdcdhprni4nrlmbfapjsas35c0v7fpa0kmxg6v1idp"))))
    (build-system gnu-build-system)
    (propagated-inputs
     `(("openjdk" ,openjdk11)
       ("rlwrap" ,rlwrap)))
    (arguments
     `(#:tests? #f
       #:phases (modify-phases %standard-phases
                  (replace 'configure
                    (lambda _
                      (substitute*
                       "clojure"
                       (("PREFIX") %output))))
                  (delete 'build)
                  (replace 'install
                    (lambda _
                      (mkdir-p (string-append %output "/libexec"))
                      (mkdir-p (string-append %output "/bin"))
                      (copy-file "clojure"
                                 (string-append %output "/bin/clojure"))
                      (copy-file "clj"
                                 (string-append %output "/bin/clj"))
                      (copy-file (string-append "clojure-tools-" ,version ".jar")
                                 (string-append %output "/libexec/clojure-tools-" ,version ".jar")))))))
    (synopsis "Clojure")
    (description "Clojure deps and cli")
    (home-page "https://www.clojure.org/deps_and_cli")
    (license epl1.0)))
