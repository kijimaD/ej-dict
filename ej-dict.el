(defvar ej-dict-alphabet-list
  ("a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z"))

(defvar ej-dict-download-base-url
  "https://raw.githubusercontent.com/kujirahand/EJDict/master/src/")

(defvar ej-dict-data-directory
  "ej-dict-data")

(defun ej-dict-search (&optional query)
  (interactive (list (read-string "Query: " (current-word))))
  (grep (concat "grep --color -E " "^" query " ./text")))

(defun ej-dict-download-file (alphabet)
  (url-copy-file (concat ej-dict-download-base-url alphabet ".txt") (concat ej-dict-data-directory "/" alphabet ".txt")))

(defun ej-dict-install-dict ()
  (make-directory "ej-dict-data")
  (dolist (alphabet ej-dict-alphabet-list)
    (ej-dict-download-file alphabet)))

(ej-dict-install-dict)
