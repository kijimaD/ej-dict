(defvar ej-dict-download-base-url
  "https://raw.githubusercontent.com/kujirahand/EJDict/master/src/")

(defvar ej-dict-alphabet-list
  ("a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z"))

(defvar ej-dict-data-directory
  "ej-dict-data")

(defun ej-dict-read (&optional query)
  "Manually input search.
If exist QUERY, use it."
  (interactive (list (read-string "Query: " (current-word))))
  (grep (concat "grep --color -Ei " "^" query " " ej-dict-data-directory "/" (substring query 0 1) ".txt")))

(defun ej-dict-auto ()
  "Context search."
  (interactive)
  (let (query)
    (cond ((region-active-p)
           (deactivate-mark t)
           (setq query (buffer-substring (region-beginning) (region-end))))
          (t
           (setq query (current-word))))
    (grep (concat "grep --color -Ei " "^" query " " ej-dict-data-directory "/" (substring query 0 1) ".txt"))))

(defun ej-dict-download-file (alphabet)
  "Download ej-dict ALPHABET file."
  (url-copy-file (concat ej-dict-download-base-url alphabet ".txt") (concat ej-dict-data-directory "/" alphabet ".txt")))

(defun ej-dict-install-dict ()
  "Install all ej-dict files."
  (make-directory "ej-dict-data")
  (dolist (alphabet ej-dict-alphabet-list)
    (ej-dict-download-file alphabet)))
