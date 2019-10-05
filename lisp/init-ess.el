;;; ess setting
(require-package 'ess)
(require-package 'ess-smart-underscore)
(require 'ess-site)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((R . t)))
(add-hook 'org-babel-after-execute-hook 'org-display-inline-images)
(provide 'init-ess)
