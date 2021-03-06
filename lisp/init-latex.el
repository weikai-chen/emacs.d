;; latex editor
;; packages
(require-package 'auctex)
(require-package 'reftex)
(require-package 'pdf-tools)
(require-package 'ivy-bibtex)
(require-package 'org-ref)
;; set variables

(defvar my/bib-file-location "~/Documents/Research/library.bib"
  "Where I keep my bib file.")

;;In order to get support for many of the LaTeX packages you will use in your documents,
;;you should enable document parsing as well, which can be achieved by putting
(setq TeX-parse-self t) ; Enable parse on load.
(setq TeX-auto-save t) ; Enable parse on save.

;;if you often use \include or \input, you should make AUCTeX aware of
;;the multi-file document structure. You can do this by inserting

;;(setq-default TeX-master nil)

;;  automatically insert  ‘\(...\)’ in LaTeX files by pressing $
(add-hook 'LaTeX-mode-hook
          (lambda () (set (make-variable-buffer-local 'TeX-electric-math)
                     (cons "\\(" "\\)"))))
;; The linebreaks will be inserted automatically if auto-fill-mode is enabled.
;; In this case the source is not only filled but also indented automatically
;; as you write it.

(add-hook 'LaTeX-mode-hook 'turn-on-auto-fill)


;; use PDF-Tools
(pdf-tools-install)

(setq TeX-view-program-selection '((output-pdf "pdf-tools"))
      TeX-view-program-list '(("pdf-tools" "TeX-pdf-tools-sync-view"))
      TeX-source-correlate-mode t
      TeX-source-correlate-start-server t
      )

;; Update PDF buffers after successful LaTeX runs
;;Autorevert works by polling the file-system every auto-revert-interval seconds, optionally combined with some event-based reverting via file notification. But this currently does not work reliably, such that Emacs may revert the PDF-buffer while the corresponding file is still being written to (e.g. by LaTeX), leading to a potential error.

(add-hook 'TeX-after-compilation-finished-functions
          #'TeX-revert-document-buffer)

(global-set-key (kbd "C-c C-g") 'pdf-sync-forward-search)
(setq mouse-wheel-follow-mouse t)
(setq pdf-view-resize-factor 1.10)

;; use RefTex
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)   ; with AUCTeX LaTeX mode
(setq reftex-plug-into-AUCTeX t)

;; ivy-bibtex
(require 'ivy-bibtex)
(global-set-key (kbd "C-c C-r") 'ivy-bibtex)

;; telling bibtex-completion where your bibliographies can be found
(setq bibtex-completion-bibliography my/bib-file-location)

;; specify the path of the note
(setq bibtex-completion-notes-path "~/Documents/Research/ref.org")
;;If one file per publication is preferred, bibtex-completion-notes-path should point to the directory used for storing the notes files:
;;(setq bibtex-completion-notes-path "/path/to/notes")

;; Customize layout of search results
;; first add journal and booktitle to the search fields
(setq bibtex-completion-additional-search-fields '(journal booktitle))
(setq bibtex-completion-display-formats
      '((article       . "${=has-pdf=:1}${=has-note=:1} ${=type=:3} ${year:4} ${author:36} ${title:*} ${journal:40}")
        (inbook        . "${=has-pdf=:1}${=has-note=:1} ${=type=:3} ${year:4} ${author:36} ${title:*} Chapter ${chapter:32}")
        (incollection  . "${=has-pdf=:1}${=has-note=:1} ${=type=:3} ${year:4} ${author:36} ${title:*} ${booktitle:40}")
        (inproceedings . "${=has-pdf=:1}${=has-note=:1} ${=type=:3} ${year:4} ${author:36} ${title:*} ${booktitle:40}")
        (t             . "${=has-pdf=:1}${=has-note=:1} ${=type=:3} ${year:4} ${author:36} ${title:*}")))

;; Symbols used for indicating the availability of notes and PDF files
(setq bibtex-completion-pdf-symbol "⌘")
(setq bibtex-completion-notes-symbol "✎")

;; default is to open pdf - change that to insert citation
(setq bibtex-completion-pdf-field "File")
;; the pdf should be renamed with the BibTeX key
;;(setq bibtex-completion-library-path '("~/Documents/Literature/"))
;;(setq ivy-bibtex-default-action #'ivy-bibtex-insert-citation)

;; adds an action with Evince as an external viewer bound to P,
;; in addition to the regular Emacs viewer with p
(defun bibtex-completion-open-pdf-external (keys &optional fallback-action)
  (let ((bibtex-completion-pdf-open-function
         (lambda (fpath) (start-process "zathura" "*helm-bibtex-zathura*" "/usr/bin/zathura" fpath))))
    (bibtex-completion-open-pdf keys fallback-action)))
(ivy-bibtex-ivify-action bibtex-completion-open-pdf-external ivy-bibtex-open-pdf-external)
(ivy-add-actions
 'ivy-bibtex
 '(("P" ivy-bibtex-open-pdf-external "Open PDF file in external viewer (if present)")))

;; If you store files in various formats, then you can specify a list
;; Extensions in this list are then tried sequentially until a file is found.
(setq bibtex-completion-pdf-extension '(".pdf" ".djvu"))

;; format of ciations
;; For example, people who don’t use Ebib might prefer links to the PDFs
;; instead of Ebib-links in org mode files

(setq bibtex-completion-format-citation-functions
      '((org-mode      . bibtex-completion-format-citation-org-link-to-PDF)
        (latex-mode    . bibtex-completion-format-citation-cite)
        (markdown-mode . bibtex-completion-format-citation-pandoc-citeproc)
        (default       . bibtex-completion-format-citation-default)))


;; use org-ref
(require 'org-ref)

(setq org-ref-bibliography-notes "~/Documents/Research/ref.org"
      org-ref-default-bibliography '("~/Documents/Research/library.bib")
      org-ref-pdf-directory "~/Documents/Literature/"
      org-ref-completion-library 'org-ref-ivy-cite
      )
(setq org-latex-pdf-process (list "latexmk -shell-escape -bibtex -f -pdf %f"))

;; Sometimes it is necessary to tell bibtex what dialect you are using to support the different bibtex entries that are possible in biblatex. You can do it like this globally.
(setq bibtex-dialect 'biblatex)

;; open pdf
(defun my/org-ref-open-pdf-at-point ()
  "Open the pdf for bibtex key under point if it exists."
  (interactive)
  (let* ((results (org-ref-get-bibtex-key-and-file))
         (key (car results))
         (pdf-file (car (bibtex-completion-find-pdf key))))
    (if (file-exists-p pdf-file)
        (org-open-file pdf-file)
      (message "No PDF found for %s" key))))

(setq org-ref-open-pdf-function 'my/org-ref-open-pdf-at-point)

;; This is a small utility for Web of Science/Knowledge (WOK) (http://apps.webofknowledge.com).
(require 'org-ref-wos)

(require 'doi-utils)

(provide 'init-latex)
