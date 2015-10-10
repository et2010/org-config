;;; packages.el --- jw Layer packages File for Spacemacs
;;
;; Copyright (c) 2012-2014 Sylvain Benner
;; Copyright (c) 2014-2015 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(setq jw-packages
  '(
    bbdb
    boxquote
    cdlatex
    ledger-mode
    visual-fill-column
    zotelo
    ))

(if (eq system-type 'windows-nt)
    (push 'ssh-agency jw-packages))

(defun jw/init-bbdb ()
  "Initialize bbdb"
  (use-package bbdb
    :defer t))

(defun jw/init-boxquote ()
  "Initialize boxquote"
  (use-package boxquote
    :defer t))

(defun jw/init-cdlatex ()
  "Initialize cdlatex"
  (use-package cdlatex
    :defer t
    :init (add-hook 'org-mode-hook 'turn-on-org-cdlatex)))

(defun jw/init-ledger-mode ()
  "Initialize ledger-mode"
  (use-package ledger-mode
    :defer t))

(defun jw/init-zotelo ()
  "Initialize zotelo"
  (use-package zotelo
    :defer t))

(defun jw/init-ssh-agency ()
  "Initialize ssh-agency"
  (use-package ssh-agency
    :defer t))

(defun jw/init-visual-fill-column ()
  "Initialize visual-fill-column"
  (use-package visual-fill-column
    :init
    (add-hook 'visual-line-mode-hook 'visual-fill-column-mode)
    ;; 最好将word-wrap的值设为nil，否则中英文混排时换行都发生在英文单词结束处，非常难看。
    (add-hook 'visual-line-mode-hook
              '(lambda ()
                (set (make-local-variable 'word-wrap) nil)))))

;; Often the body of an initialize function uses `use-package'
;; For more info on `use-package', see readme:
;; https://github.com/jwiegley/use-package
