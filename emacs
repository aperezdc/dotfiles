(require 'iso-transl)

(autoload 'notmuch "~/.emacs.d/my-notmuch" "notmuch mail" t)
(menu-bar-mode -1)

(setq hippie-expand-try-functions-list '(
       try-expand-dabbrev try-expand-dabbrev-all-buffers
       try-expand-dabbrev-from-kill try-complete-file-name-partially
       try-complete-file-name try-expand-all-abbrevs try-expand-list
       try-expand-line try-complete-lisp-symbol-partially
       try-complete-lisp-symbol))
;;(global-smart-tab-mode 1)
(setq smart-tab-using-hippie-expand t)

(if (not window-system) (progn
  (set-background-color "black")
  (set-face-background 'default "black")
  (set-face-background 'region "black")
  (set-face-foreground 'default "white")
  (set-face-foreground 'region "gray60")
  (set-foreground-color "white")
  (set-cursor-color "red")))

(when (fboundp 'global-hl-line-mode)
	(global-hl-line-mode t)) ;; turn it on for all modes by default
(when (fboundp 'show-paren-mode)
	(show-paren-mode t)
	(setq show-paren-style 'parenthesis))

(setq-default indent-tabs-mode nil)
(setq browse-url-generic-program "xdg-open")
(setq browse-url-browser-function 'browse-url-generic)

;; Make Emacs kill-ring interact with the X11 clipboard in sane way.
;; (See http://www.emacswiki.org/emacs/CopyAndPaste for details)
;;
(global-set-key "\C-w" 'clipboard-kill-region)
(global-set-key "\M-w" 'clipboard-kill-ring-save)
(global-set-key "\C-y" 'clipboard-yank)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(blink-cursor-mode nil)
 '(column-number-mode t)
 '(current-language-environment "English")
 '(default-input-method nil)
 '(footnote-signature-separator "^---? $")
 '(fringe-mode (quote (nil . 0)) nil (fringe))
 '(ibus-python-shell-command-name "python2")
 '(mail-host-address "kaze")
 '(message-send-mail-function (quote message-send-mail-with-sendmail))
 '(message-tool-bar (quote message-tool-bar-gnome))
 '(mm-text-html-renderer (quote w3m-standalone))
 '(notmuch-crypto-process-mime t)
 '(notmuch-fcc-dirs "Sent/")
 '(notmuch-identities (quote ("aperez@igalia.com" "adrian@perezdecastro.org" "aperez@furi-ku.org" "the.lightman@gmail.com")))
 '(notmuch-mua-compose-in (quote new-frame))
 '(notmuch-saved-searches (quote (("inbox" . "tag:inbox") ("unread" . "tag:unread") ("logs" . "tag:unread and tag:log") ("flagged" . "tag:flagged"))))
 '(notmuch-search-oldest-first nil)
 '(notmuch-show-indent-messages-width 3)
 '(notmuch-show-indent-multipart nil)
 '(notmuch-show-logo nil)
 '(notmuch-show-part-button-default-action (quote notmuch-show-interactively-view-part))
 '(scroll-bar-mode (quote right))
 '(send-mail-function (quote sendmail-send-it))
 '(show-paren-mode t)
 '(tool-bar-mode nil)
 '(user-mail-address "aperez@igalia.com"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "white" :foreground "black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 120 :width normal :foundry "unknown" :family "PragmataPro")))))
