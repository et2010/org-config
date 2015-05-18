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

(defvar jw-packages
  '(
    ;; package jws go here
    bbdb
    boxquote
    cdlatex
    org-plus-contrib
    )
  "List of all packages to install and/or initialize. Built-in packages
which require an initialization must be listed explicitly in the list.")

(defvar jw-excluded-packages '()
  "List of packages to exclude.")

;; For each package, define a function jw/init-<package-jw>
;;
;; (defun jw/init-my-package ()
;;   "Initialize my package"
;;   )
;;

(defun jw/init-bbdb ()
  "Initialize bbdb"
  (use-package bbdb))

(defun jw/init-boxquote ()
  "Initialize boxquote"
  (use-package boxquote))

(defun jw/init-cdlatex ()
  "Initialize cdlatex"
  (use-package cdlatex
    :init (add-hook 'org-mode-hook 'turn-on-org-cdlatex)))

(defun jw/init-org-plus-contrib ()
  "Initialize org-plus-contrib"
  (use-package org-plus-contrib))

;; Often the body of an initialize function uses `use-package'
;; For more info on `use-package', see readme:
;; https://github.com/jwiegley/use-package
