;; email
(require 'init-mu4e)

(global-set-key (kbd "C-c ;") 'comment-or-uncomment-region)

;; sunrize/sunset theme changer
;; from https://github.com/hadronzoo/theme-changer
;; for themes, see https://pawelbx.github.io/emacs-theme-gallery/

(setq calendar-location-name "Amherst, MA")
(setq calendar-latitude 42.37)
(setq calendar-longitude -72.52)
(require-package 'dracula-theme)
;;(require-package 'solarized-theme)
;; (require-package 'theme-changer)
;; (require 'theme-changer)
;; (change-theme 'solarized-light 'dracula)


;; If you want to use the color-theme package instead of the Emacs 24 color theme facility:

;;(setq theme-changer-mode "color-theme")
;;(change-theme 'color-theme-solarized-light 'color-theme-solarized-dark)


;; webpage
(require-package 'ox-hugo)
(with-eval-after-load 'ox
  (require 'ox-hugo))

;; slime-helper
;;(load (expand-file-name "~/quicklisp/slime-helper.el"))
;; Replace "sbcl" with the path to your implementation
;;(setq inferior-lisp-program "sbcl")
(require 'init-latex)

(require 'init-ess)

(provide 'init-local)
