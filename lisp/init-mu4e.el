(require 'mu4e)
(global-set-key (kbd "C-x e") 'mu4e)
(setq mu4e-maildir (expand-file-name "~/Mail"))
;; don't save message to Sent Messages, GMail/IMAP will take care of this
(setq mu4e-sent-messages-behavior 'delete)

;; setup some handy shortcuts
;; (setq mu4e-maildir-shortcuts
;;       '(("/INBOX"             . ?i)
;;         ("/[Gmail].Sent Mail" . ?s)
;;         ("/[Gmail].Trash"     . ?t)))

;; allow for updating mail using 'U' in the main view:
(setq mu4e-get-mail-command "offlineimap")
(setq  mu4e-view-show-images t
       mu4e-view-image-max-width 800)
;;(setq mu4e-update-interval 300)
(setq mu4e-use-fancy-chars t)
(setq mu4e-view-show-addresses t)
;;use imagemagick, if available
(when (fboundp 'imagemagick-register-types)
  (imagemagick-register-types))

;;don't keep message buffers around
(setq message-kill-buffer-on-exit t)

;; something about ourselves
;; I don't use a signature...
(setq
 user-mail-address "nkcweikai@gmail.com"
 user-full-name  "Weikai Chen"
 ;; message-signature
 ;;  (concat
 ;;    "Foo X. Bar\n"
 ;;    "http://www.example.com\n")
 )
;;(setq mu4e-html2text-command "iconv -c -t utf-8 | pandoc -f html -t plain")

;; (use-package mu4e-alert
;;   :after mu4e
;;   :hook ((after-init . mu4e-alert-enable-mode-line-display)
;;          (after-init . mu4e-alert-enable-notifications))
;;   :config (mu4e-alert-set-default-style 'libnotify))

;;(setq send-mail-function 'smtpmail-send-it)
(setq message-send-mail-function 'smtpmail-send-it)

;;store org-mode links to messages
(require 'org-mu4e)
;; store link to message if in header view, not to header query
(setq org-mu4e-link-query-in-headers-mode nil)
(setq org-capture-templates
      `(("t" "todo" entry (file "")  ; "" => `org-default-notes-file'
         "* NEXT %?\n%U\n%a\n" :clock-resume t
         )

        ("n" "note" entry (file "")
         "* %? :NOTE:\n%U\n%a\n" :clock-resume t)
        ))

(provide 'init-mu4e)
