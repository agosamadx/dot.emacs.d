;;; init.el --- Emacs initialization file

;;; Commentary:
;; Emacs initialization settings

;;; Code:

(prefer-coding-system 'utf-8-unix)

;;; for windows
(when window-system '(windows-nt)
      (load-file (locate-user-emacs-file "windows.el")))

;;; frame
(defvar frame-parameters
  '((width . 180)
    (height . 50)
    (tool-bar-lines . nil)))

(when (memq window-system '(x w32 mac ns))
  (set-scroll-bar-mode nil)
  (setq default-frame-alist frame-parameters))

;;; package
(require 'use-package)
(use-package package
  :config
  (progn
    (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))))

;;; setting
(setq inhibit-startup-screen t)
(setq initial-scratch-message nil)
(setq make-backup-files nil)
(setq auto-save-default nil)
(setq create-lockfiles nil)
(setq kill-whole-line t)
(setq ring-bell-function 'ignore)
(setq completion-ignore-case t)
(setq read-buffer-completion-ignore-case t)
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)
(setq-default truncate-lines t)
(custom-set-variables '(custom-file (expand-file-name "custom.el" user-emacs-directory)))

;;; func
(load-file (locate-user-emacs-file "func.el"))

;;; key bind
(global-set-key "\C-a" 'beggining-of-indented-line)
(global-set-key "\C-h" 'backward-delete-char)
(global-set-key "\C-x\C-b" 'electric-buffer-list)
(global-set-key (kbd "C-M-/") 'undo-redo)

;;; paren-mode
(show-paren-mode t)
(setq show-paren-delay 0)
(setq show-paren-style 'mixed)

;;; lsp-mode
(use-package lsp-mode
  :ensure t
  :hook ((c-mode . lsp-deferred)
         (c++-mode . lsp-deferred)
         (php-mode . lsp-deferred))
  :commands (lsp lsp-deferred)
  :config
  (progn
    (setq-default lsp-enable-indentation nil)
    (setq-default lsp-enable-on-type-formatting nil)))

;;; lsp-ui
(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode)

;;; company
(use-package company
  :ensure t
  :config
  (add-hook 'after-init-hook 'global-company-mode))

;;; flycheck
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

;;; lsp-treemacs
(use-package lsp-treemacs
  :ensure t
  :commands lsp-treemacs-errors-list)

;;; yasnippet
(use-package yasnippet
  :ensure t
  :config
  (progn
    (yas-global-mode)))

;;; ddskk
(use-package ddskk
  :ensure t
  :commands
  (skk skk-study)
  :config
  (progn
    (setq default-input-method "japanese-skk")
    (setq-default skk-isearch-start-mode 'latin)
    (add-hook 'isearch-mode-hook 'skk-isearch-mode-setup)
    (add-hook 'isearch-mode-end-hook 'skk-isearch-mode-cleanup))
  :bind (("C-\\" . skk-mode)))

(use-package php-mode
  :ensure t)

;;; c-mode
(add-hook 'c-mode-common-hook
          (lambda()
            (c-set-style "stroustrup")
            (local-set-key "\C-h" 'hungry-backspace)
            (local-set-key "\C-d" 'hungry-delete)
            (local-set-key "\C-f" 'hungry-forward-char)
            (local-set-key "\C-b" 'hungry-backward-char)))

;;; c++-mode
(setq auto-mode-alist
      (append
       '(("\\.h$" . c++-mode)
         ("\\.hpp$" . c++-mode))
       auto-mode-alist))
(add-hook 'c++-mode-hook
          (lambda()
            (c-set-offset 'innamespace 0)
            (c-set-offset 'inlambda 0)
            (c-set-offset 'arglist-intro '+)
            (c-set-offset 'arglist-close 0)
            (c-set-offset 'arglist-cont-nonempty 0)))

(provide 'init)
;;; init.el ends here
