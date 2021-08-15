(defvar ej-dict-download-base-url
  "https://raw.githubusercontent.com/kujirahand/EJDict/master/src/")

(defvar ej-dict-alphabet-list
  (list "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z"))

(defvar ej-dict-data-directory
  (concat (getenv "HOME") "/.emacs.d/ej-dict-data"))

(defvar ej-dict-global-timer nil)

(defvar current-word-highlight-mode nil)

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
    (setq query (downcase query))
    (cond ((string-match "[a-z]" (substring query 0 1))
           (grep (concat "grep --color -Ei " "^" query " " ej-dict-data-directory "/" (substring query 0 1) ".txt")))
          (t
           (grep (concat "grep --color -Eir " query " " ej-dict-data-directory "/"))))))

(defun ej-dict-download-file (alphabet)
  "Download ej-dict ALPHABET file."
  (url-copy-file (concat ej-dict-download-base-url alphabet ".txt") (concat ej-dict-data-directory "/" alphabet ".txt")))

(defun ej-dict-install-dict ()
  "Install all ej-dict files."
  (interactive)
  (make-directory ej-dict-data-directory)
  (dolist (alphabet ej-dict-alphabet-list)
    (ej-dict-download-file alphabet)))

(defun ej-dict-cancel-timer ()
  "Cancel search timer."
  (when (timerp ej-dict-global-timer)
    (cancel-timer ej-dict-global-timer)
    (setq ej-dict-global-timer nil)))

;;;###autoload
(define-minor-mode ej-dict-mode
  "ej-dict Minor Mode."
  :group 'ej-dict
  (if ej-dict-mode
      (progn (unless ej-dict-global-timer
               (setq ej-dict-global-timer
                     (run-with-idle-timer 0.2
                                          :repeat 'ej-dict-auto))))
    (ej-dict-cancel-timer)))

(provide 'ej-dict)
;;; ej-dict.el ends here
