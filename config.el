;;; config.el --- JW Layer configuration File for Spacemacs
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

;; (require 'bbdb)
;; (require 'bbdb-com)
(require 'ob)
(require 'org)
;; (require 'org-checklist)
(require 'org-crypt)
;; (require 'org-id)
;; (require 'org-mime)
;; (require 'org-protocol)
;; (require 'ox-ascii)
;; (require 'ox-html)
;; (require 'ox-latex)

;;;; Hooks
(add-hook 'message-mode-hook
          '(lambda () (setq fill-column 72))
          'append)

(add-hook 'message-mode-hook 'orgstruct++-mode 'append)
(add-hook 'message-mode-hook 'turn-on-auto-fill 'append)
(add-hook 'message-mode-hook 'bbdb-define-all-aliases 'append)
(add-hook 'message-mode-hook 'orgtbl-mode 'append)
(add-hook 'message-mode-hook 'turn-on-flyspell 'append)

(add-hook 'org-after-todo-state-change-hook 'jw/mark-next-parent-tasks-todo 'append)
(add-hook 'org-clock-in-hook 'jw/mark-next-parent-tasks-todo 'append)

;; Always hilight the current agenda line
(add-hook 'org-agenda-mode-hook
          '(lambda () (hl-line-mode 1))
          'append)

(add-hook 'org-agenda-mode-hook
          '(lambda () (org-defkey org-agenda-mode-map "F" 'jw/restrict-to-file-or-follow))
          'append)

(add-hook 'org-agenda-mode-hook
          '(lambda () (org-defkey org-agenda-mode-map "N" 'jw/narrow-to-subtree))
          'append)

(add-hook 'org-agenda-mode-hook
          '(lambda () (org-defkey org-agenda-mode-map "P" 'jw/narrow-to-project))
          'append)

(add-hook 'org-agenda-mode-hook
          '(lambda () (org-defkey org-agenda-mode-map "U" 'jw/narrow-up-one-level))
          'append)

(add-hook 'org-agenda-mode-hook
          '(lambda () (org-defkey org-agenda-mode-map "V" 'jw/view-next-project))
          'append)

(add-hook 'org-agenda-mode-hook
          '(lambda () (org-defkey org-agenda-mode-map "W" (lambda () (interactive) (setq jw/hide-scheduled-and-waiting-next-tasks t) (jw/widen))))
          'append)

(add-hook 'org-agenda-mode-hook
          '(lambda () (org-defkey org-agenda-mode-map "\C-c\C-x<" 'jw/set-agenda-restriction-lock))
          'append)

(add-hook 'org-babel-after-execute-hook 'jw/display-inline-images 'append)
(add-hook 'org-clock-out-hook 'jw/clock-out-maybe 'append)
(add-hook 'org-clock-out-hook 'jw/remove-empty-drawer-on-clock-out 'append)
(add-hook 'org-export-before-parsing-hook 'jw/auto-tex-cmd 'append)
(add-hook 'org-export-before-parsing-hook 'jw/auto-tex-parameters 'append)
; Rebuild the reminders everytime the agenda is displayed
(add-hook 'org-finalize-agenda-hook 'jw/org-agenda-to-appt 'append)
(add-hook 'org-insert-heading-hook 'jw/insert-heading-inactive-timestamp 'append)

(add-hook 'org-mode-hook 'turn-on-visual-line-mode 'append)

(add-hook 'org-mode-hook
          (lambda ()
            (local-set-key (kbd "C-c M-o") 'jw/mail-subtree))
          'append)

;; Disable keys in org-mode
;;    C-c [
;;    C-c ]
;;    C-c ;
;;    C-c C-x C-q  cancelling the clock (we never want this)
(add-hook 'org-mode-hook
          (lambda ()
             ;; Undefine C-c [ and C-c ] since this breaks my
             ;; org-agenda files when directories are include It
             ;; expands the files in the directories individually
             (org-defkey org-mode-map "\C-c[" 'undefined)
             (org-defkey org-mode-map "\C-c]" 'undefined)
             ;; (org-defkey org-mode-map "\C-c;" 'undefined)
             (org-defkey org-mode-map "\C-c\C-x\C-q" 'undefined))
          'append)

;; flyspell mode for spell checking everywhere
;; (add-hook 'org-mode-hook 'turn-on-flyspell 'append)

;; Enable abbrev-mode
(add-hook 'org-mode-hook (lambda () (abbrev-mode 1)))

(add-to-list 'Info-default-directory-list "~/git/org-mode/doc")
(add-to-list 'auto-mode-alist '("\\.\\(org\\|org_archive\\|txt\\)$" . org-mode))
;; (add-to-list 'load-path (expand-file-name "~/.emacs.d"))
;; (add-to-list 'load-path (expand-file-name "~/git/org-mode/contrib/lisp"))
; Use fundamental mode when editing plantuml blocks with C-c '
(add-to-list 'org-src-lang-modes (quote ("plantuml" . fundamental)))


; Activate appointments so we get notifications
(appt-activate t)

;; (custom-set-faces
;;   ;; custom-set-faces was added by Custom.
;;   ;; If you edit it by hand, you could mess it up, so be careful.
;;   ;; Your init file should contain only one such instance.
;;   ;; If there is more than one, they won't work right.
;;  '(org-mode-line-clock ((t (:foreground "red" :box (:line-width -1 :style released-button)))) t))

;;;; Abbrevs
(define-abbrev org-mode-abbrev-table "sact" "" 'skel-org-block-plantuml-activity)
(define-abbrev org-mode-abbrev-table "sblk" "" 'skel-org-block)
(define-abbrev org-mode-abbrev-table "sditaa" "" 'skel-org-block-ditaa)
(define-abbrev org-mode-abbrev-table "sdot" "" 'skel-org-block-dot)
(define-abbrev org-mode-abbrev-table "selisp" "" 'skel-org-block-elisp)
(define-abbrev org-mode-abbrev-table "sfor" "" 'skel-org-block-plantuml-activity-for)
(define-abbrev org-mode-abbrev-table "sif" "" 'skel-org-block-plantuml-activity-if)
(define-abbrev org-mode-abbrev-table "splantuml" "" 'skel-org-block-plantuml)
(define-abbrev org-mode-abbrev-table "sseq" "" 'skel-org-block-plantuml-sequence)

;;;; Skeletons
;; sblk - Generic block #+begin_FOO .. #+end_FOO
(define-skeleton skel-org-block
  "Insert an org block, querying for type."
  "Type: "
  "#+begin_" str "\n"
  _ - \n
  "#+end_" str "\n")

;; sditaa - Ditaa source block
(define-skeleton skel-org-block-ditaa
  "Insert a org ditaa block, querying for filename."
  "File (no extension): "
  "#+begin_src ditaa :file " str ".png :cache yes\n"
  _ - \n
  "#+end_src\n")

;; sdot - Graphviz DOT block
(define-skeleton skel-org-block-dot
  "Insert a org graphviz dot block, querying for filename."
  "File (no extension): "
  "#+begin_src dot :file " str ".png :cache yes :cmdline -Kdot -Tpng\n"
  "graph G {\n"
  _ - \n
  "}\n"
  "#+end_src\n")

;; selisp - Emacs Lisp source block
(define-skeleton skel-org-block-elisp
  "Insert a org emacs-lisp block"
  ""
  "#+begin_src emacs-lisp\n"
  _ - \n
  "#+end_src\n")

;; splantuml - PlantUML Source block
(define-skeleton skel-org-block-plantuml
  "Insert a org plantuml block, querying for filename."
  "File (no extension): "
  "#+begin_src plantuml :file " str ".png :cache yes\n"
  _ - \n
  "#+end_src\n")

(define-skeleton skel-org-block-plantuml-activity
  "Insert a org plantuml block, querying for filename."
  "File (no extension): "
  "#+begin_src plantuml :file " str "-act.png :cache yes :tangle " str "-act.txt\n"
  (jw/plantuml-reset-counters)
  "@startuml\n"
  "skinparam activity {\n"
  "BackgroundColor<<New>> Cyan\n"
  "}\n\n"
  "title " str " - \n"
  "note left: " str "\n"
  "(*) --> \"" str "\"\n"
  "--> (*)\n"
  _ - \n
  "@enduml\n"
  "#+end_src\n")

(define-skeleton skel-org-block-plantuml-activity-for
  "Insert a org plantuml block activity for statement"
  "Loop for each: "
  "--> ==LOOP" (setq loopn (jw/plantuml-loop)) "==\n"
  "note left: Loop" loopn ": For each " str "\n"
  "--> ==ENDLOOP" loopn "==\n"
  "note left: Loop" loopn ": End for each " str "\n" )

(define-skeleton skel-org-block-plantuml-activity-if
  "Insert a org plantuml block activity if statement"
  ""
  "if \"\" then\n"
  "  -> [condition] ==IF" (setq ifn (jw/plantuml-if)) "==\n"
  "  --> ==IF" ifn "M1==\n"
  "  -left-> ==IF" ifn "M2==\n"
  "else\n"
  "end if\n"
  "--> ==IF" ifn "M2==")

(define-skeleton skel-org-block-plantuml-sequence
  "Insert a org plantuml activity diagram block, querying for filename."
  "File appends (no extension): "
  "#+begin_src plantuml :file " str "-seq.png :cache yes :tangle " str "-seq.txt\n"
  "@startuml\n"
  "title " str " - \n"
  "actor CSR as \"Customer Service Representative\"\n"
  "participant CSMO as \"CSM Online\"\n"
  "participant CSMU as \"CSM Unix\"\n"
  "participant NRIS\n"
  "actor Customer"
  _ - \n
  "@enduml\n"
  "#+end_src\n")

(defmacro jw/agenda-sort-test (fn a b)
  "Test for agenda sort"
  `(cond
    ;; if both match leave them unsorted
    ((and (apply ,fn (list ,a))
          (apply ,fn (list ,b)))
     (setq result nil))
    ;; if a matches put a first
    ((apply ,fn (list ,a))
     (setq result -1))
    ;; otherwise if b matches put b first
    ((apply ,fn (list ,b))
     (setq result 1))
    ;; if none match leave them unsorted
    (t nil)))

(defmacro jw/agenda-sort-test-num (fn compfn a b)
  `(cond
    ((apply ,fn (list ,a))
     (setq num-a (string-to-number (match-string 1 ,a)))
     (if (apply ,fn (list ,b))
         (progn
           (setq num-b (string-to-number (match-string 1 ,b)))
           (setq result (if (apply ,compfn (list num-a num-b))
                            -1
                          1)))
       (setq result -1)))
    ((apply ,fn (list ,b))
     (setq result 1))
    (t nil)))

(defvar jw/hide-scheduled-and-waiting-next-tasks t)
(defvar jw/insert-inactive-timestamp t)
(defvar jw/organization-task-id "4005a7cf-fcd9-472d-8a2b-53a19d486439")
(defvar jw/plantuml-if-count 0)
(defvar jw/project-list nil)

(org-babel-do-load-languages
 (quote org-babel-load-languages)
 (quote ((R . t)
         (ditaa . t)
         (dot . t)
         (emacs-lisp . t)
         (gnuplot . t)
         (latex . t)
         (org . t)
         (plantuml . t)
         (python . t)
         (sh . t)
         ;; (clojure . t)
         ;; (ledger . t)
         ;; (ruby . t)
         )))

;; Resume clocking task when emacs is restarted
(org-clock-persistence-insinuate)

; Encrypt all entries before saving
(org-crypt-use-before-save-magic)

(run-at-time "00:59" 3600 'org-save-all-org-buffers)
(run-at-time "06:00" 86400 '(lambda () (setq org-habit-show-habits t)))
; If we leave Emacs running overnight - reset the appointments one minute after midnight
(run-at-time "24:01" nil 'jw/org-agenda-to-appt)

(setq jw/keep-clock-running nil)

(setq org-agenda-auto-exclude-function 'jw/org-auto-exclude-function)

(setq org-agenda-clock-consistency-checks
      (quote (:max-duration "4:00"
              :min-duration 0
              :max-gap 0
              :gap-ok-around ("4:00"))))

;; Agenda clock report parameters
(setq org-agenda-clockreport-parameter-plist
      (quote (:link t :maxlevel 5 :fileskip0 t :compact t :narrow 80)))

;; Agenda sorting functions
(setq org-agenda-cmp-user-defined 'jw/agenda-sort)

;; Compact the block agenda view
(setq org-agenda-compact-blocks t)

;; Custom agenda command definitions
(setq org-agenda-custom-commands
      (quote (("N" "Notes" tags "NOTE"
               ((org-agenda-overriding-header "Notes")
                (org-tags-match-list-sublevels t)))
              ("h" "Habits" tags-todo "STYLE=\"habit\""
               ((org-agenda-overriding-header "Habits")
                (org-agenda-sorting-strategy
                 '(todo-state-down effort-up category-keep))))
              (" " "Agenda"
               ((agenda "" nil)
                (tags "REFILE"
                      ((org-agenda-overriding-header "Tasks to Refile")
                       (org-tags-match-list-sublevels nil)))
                (tags-todo "-CANCELLED/!"
                           ((org-agenda-overriding-header "Stuck Projects")
                            (org-agenda-skip-function 'jw/skip-non-stuck-projects)
                            (org-agenda-sorting-strategy
                             '(category-keep))))
                (tags-todo "-HOLD-CANCELLED/!"
                           ((org-agenda-overriding-header "Projects")
                            (org-agenda-skip-function 'jw/skip-non-projects)
                            (org-tags-match-list-sublevels 'indented)
                            (org-agenda-sorting-strategy
                             '(category-keep))))
                (tags-todo "-CANCELLED/!NEXT"
                           ((org-agenda-overriding-header (concat "Project Next Tasks"
                                                                  (if jw/hide-scheduled-and-waiting-next-tasks
                                                                      ""
                                                                    " (including WAITING and SCHEDULED tasks)")))
                            (org-agenda-skip-function 'jw/skip-projects-and-habits-and-single-tasks)
                            (org-tags-match-list-sublevels t)
                            (org-agenda-todo-ignore-scheduled jw/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-todo-ignore-deadlines jw/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-todo-ignore-with-date jw/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-sorting-strategy
                             '(todo-state-down effort-up category-keep))))
                (tags-todo "-REFILE-CANCELLED-WAITING-HOLD/!"
                           ((org-agenda-overriding-header (concat "Project Subtasks"
                                                                  (if jw/hide-scheduled-and-waiting-next-tasks
                                                                      ""
                                                                    " (including WAITING and SCHEDULED tasks)")))
                            (org-agenda-skip-function 'jw/skip-non-project-tasks)
                            (org-agenda-todo-ignore-scheduled jw/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-todo-ignore-deadlines jw/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-todo-ignore-with-date jw/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-sorting-strategy
                             '(category-keep))))
                (tags-todo "-REFILE-CANCELLED-WAITING-HOLD/!"
                           ((org-agenda-overriding-header (concat "Standalone Tasks"
                                                                  (if jw/hide-scheduled-and-waiting-next-tasks
                                                                      ""
                                                                    " (including WAITING and SCHEDULED tasks)")))
                            (org-agenda-skip-function 'jw/skip-project-tasks)
                            (org-agenda-todo-ignore-scheduled jw/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-todo-ignore-deadlines jw/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-todo-ignore-with-date jw/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-sorting-strategy
                             '(category-keep))))
                (tags-todo "-CANCELLED+WAITING|HOLD/!"
                           ((org-agenda-overriding-header (concat "Waiting and Postponed Tasks"
                                                                  (if jw/hide-scheduled-and-waiting-next-tasks
                                                                      ""
                                                                    " (including WAITING and SCHEDULED tasks)")))
                            (org-agenda-skip-function 'jw/skip-non-tasks)
                            (org-tags-match-list-sublevels nil)
                            (org-agenda-todo-ignore-scheduled jw/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-todo-ignore-deadlines jw/hide-scheduled-and-waiting-next-tasks)))
                (tags "-REFILE/"
                      ((org-agenda-overriding-header "Tasks to Archive")
                       (org-agenda-skip-function 'jw/skip-non-archivable-tasks)
                       (org-tags-match-list-sublevels nil))))
               nil))))

(setq org-agenda-diary-file "~/git/org/diary.org")

;; Do not dim blocked tasks
(setq org-agenda-dim-blocked-tasks nil)

(setq org-agenda-files (quote ("~/git/org"
                               "~/git/org/learn"
                               "~/git/org/research")))

(setq org-agenda-include-diary nil)

(setq org-agenda-insert-diary-extract-time t)

;; Agenda log mode items to display (closed and state changes by default)
(setq org-agenda-log-mode-items (quote (closed state)))

(setq org-agenda-persistent-filter t)

;; Show all future entries for repeating tasks
(setq org-agenda-repeating-timestamp-show-all t)

;; Limit restriction lock highlighting to the headline only
(setq org-agenda-restriction-lock-highlight-subtree nil)

;; Show all agenda dates - even if they are empty
(setq org-agenda-show-all-dates t)

(setq org-agenda-skip-additional-timestamps-same-entry t)

;; Remove completed deadline tasks from the agenda view
(setq org-agenda-skip-deadline-if-done t)

;; Remove completed scheduled tasks from the agenda view
(setq org-agenda-skip-scheduled-if-done t)

;; Remove completed items from search results
(setq org-agenda-skip-timestamp-if-done t)

;; Sorting order for tasks on the agenda
(setq org-agenda-sorting-strategy
      (quote ((agenda habit-down time-up user-defined-up effort-up category-keep)
              (todo category-up effort-up)
              (tags category-up effort-up)
              (search category-up))))

(setq org-agenda-span 'day)

;; Start the weekly agenda on Monday
(setq org-agenda-start-on-weekday 1)

;; Use sticky agenda's so they persist
(setq org-agenda-sticky t)

;; Display tags farther right
(setq org-agenda-tags-column -102)

;; For tag searches ignore tasks with scheduled and deadline dates
(setq org-agenda-tags-todo-honor-ignore-options t)

;; Include agenda archive files when searching for things
(setq org-agenda-text-search-extra-files (quote (agenda-archives)))

;; Enable display of the time grid so we can see the marker for the current time
(setq org-agenda-time-grid (quote ((daily today remove-match)
                                   #("----------------" 0 16 (org-heading t))
                                   (0900 1100 1300 1500 1700))))

;; Keep tasks with deadlines on the global todo lists
(setq org-agenda-todo-ignore-deadlines nil)

;; Keep tasks with scheduled dates on the global todo lists
(setq org-agenda-todo-ignore-scheduled nil)

;; Keep tasks with timestamps on the global todo lists
(setq org-agenda-todo-ignore-timestamp nil)

;; Keep tasks with dates on the global todo lists
(setq org-agenda-todo-ignore-with-date nil)

; Overwrite the current window with the agenda
(setq org-agenda-window-setup 'current-window)

(setq org-alphabetical-lists t)

(setq org-archive-location "%s_archive::* Archived Tasks")

(setq org-archive-mark-done nil)

; Make babel results blocks lowercase
(setq org-babel-results-keyword "results")

(setq org-blank-before-new-entry (quote ((heading)
                                         (plain-list-item . auto))))

(setq org-bullets-bullet-list '("◎" "○" "◇" "☆"))

;; Capture templates for: TODO tasks, Notes, appointments, phone calls, meetings, and org-protocol
(setq org-capture-templates
      (quote (("t" "todo" entry (file "~/git/org/refile.org")
               "* TODO %?\n%U\n%a\n" :clock-in t :clock-resume t)
              ("r" "respond" entry (file "~/git/org/refile.org")
               "* NEXT Respond to %:from on %:subject\nSCHEDULED: %t\n%U\n%a\n" :clock-in t :clock-resume t :immediate-finish t)
              ("n" "note" entry (file "~/git/org/refile.org")
               "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume t)
              ("j" "Journal" entry (file+datetree "~/git/org/diary.org")
               "* %?\n%U\n" :clock-in t :clock-resume t)
              ("w" "org-protocol" entry (file "~/git/org/refile.org")
               "* TODO Review %c\n%U\n" :immediate-finish t)
              ("m" "Meeting" entry (file "~/git/org/refile.org")
               "* MEETING with %? :MEETING:\n%U" :clock-in t :clock-resume t)
              ("p" "Phone call" entry (file "~/git/org/refile.org")
               "* PHONE %? :PHONE:\n%U" :clock-in t :clock-resume t)
              ("h" "Habit" entry (file "~/git/org/refile.org")
               "* NEXT %?\n%U\n%a\nSCHEDULED: %(format-time-string \"<%Y-%m-%d %a .+1d/3d>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n"))))

(setq org-catch-invisible-edits 'error)

;; Enable auto clock resolution for finding open clocks
(setq org-clock-auto-clock-resolution (quote when-no-clock-is-running))

;; Show lot of clocking history so it's easy to pick items off the C-F11 list
(setq org-clock-history-length 23)

;; Resume clocking task on clock-in if the clock is open
(setq org-clock-in-resume t)

;; Change tasks to NEXT when clocking in
(setq org-clock-in-switch-to-state 'jw/clock-in-to-next)

;; Save clock data and state changes and notes in the LOGBOOK drawer
(setq org-clock-into-drawer t)

;; Sometimes I change tasks I'm clocking quickly - this removes clocked tasks with 0:00 duration
(setq org-clock-out-remove-zero-time-clocks t)

;; Sometimes I change tasks I'm clocking quickly - this removes clocked tasks with 0:00 duration
(setq org-clock-out-remove-zero-time-clocks t)

;; Clock out when moving task to a done state
(setq org-clock-out-when-done t)

;; Save the running clock and all clock history when exiting Emacs, load it on startup
(setq org-clock-persist t)

;; Do not prompt to resume an active clock
(setq org-clock-persist-query-resume nil)

;; Include current clocking task in clock reports
(setq org-clock-report-include-clocking-task t)

;; (setq org-clock-sound "/usr/local/lib/tngchime.wav")

(setq org-clone-delete-id t)

;; Set default column view headings: Task Effort Clock_Summary
(setq org-columns-default-format "%80ITEM(Task) %10Effort(Effort){:} %10CLOCKSUM")

;; Do not prompt to confirm evaluation
;; This may be dangerous - make sure you understand the consequences
;; of setting this -- see the docstring for details
(setq org-confirm-babel-evaluate nil)

(setq org-crypt-disable-auto-save nil)

(setq org-crypt-key "F0B66B40")         ; GPG key to use for encryption

(setq org-cycle-include-plain-lists t)

(setq org-cycle-separator-lines 0)

(setq org-deadline-warning-days 30)

(setq org-default-notes-file "~/git/org/refile.org")

(setq org-directory "~/git/org")

(setq org-ditaa-jar-path "~/git/org-mode/contrib/scripts/ditaa.jar")

;; Separate drawers for clocking and logs
(setq org-drawers (quote ("PROPERTIES" "LOGBOOK")))

(setq org-edit-src-content-indentation 0)

(setq org-emphasis-alist (quote (("*" bold "<b>" "</b>")
                                 ("/" italic "<i>" "</i>")
                                 ("_" underline "<span style=\"text-decoration:underline;\">" "</span>")
                                 ("=" org-code "<code>" "</code>" verbatim)
                                 ("~" org-verbatim "<code>" "</code>" verbatim))))

(setq org-enforce-todo-dependencies t)

(setq org-export-allow-BIND t)

(setq org-export-coding-system 'utf-8)

; experimenting with docbook exports - not finished
(setq org-export-docbook-xsl-fo-proc-command "fop %s %s")
(setq org-export-docbook-xslt-proc-command "xsltproc --output %s /usr/share/xml/docbook/stylesheet/nwalsh/fo/docbook.xsl %s")

; Increase default number of headings to export
(setq org-export-headline-levels 6)

; Do not generate internal css formatting for HTML exports
(setq org-export-htmlize-output-type (quote css))

; Export with LaTeX fragments
(setq org-export-with-LaTeX-fragments t)

; Do not use sub or superscripts - I currently don't need this functionality in my documents
(setq org-export-with-sub-superscripts nil)

(setq org-export-with-timestamps nil)

(setq org-fast-tag-selection-single-key (quote expert)) ; Allow setting single tags without the menu

(setq org-file-apps (quote ((auto-mode . emacs)
                            ("\\.mm\\'" . system)
                            ("\\.x?html?\\'" . system)
                            ("\\.pdf\\'" . system))))

; global Effort estimate values
; global STYLE property values for completion
(setq org-global-properties (quote (("Effort_ALL" . "0:15 0:30 0:45 1:00 2:00 3:00 4:00 5:00 6:00 0:00")
                                    ("STYLE_ALL" . "habit"))))

; position the habit graph on the agenda to the right of the default
(setq org-habit-graph-column 50)

(setq org-hide-leading-stars nil)

; Use org.css from the norang website for export document stylesheets
(setq org-html-head-extra "<link rel=\"stylesheet\" href=\"http://doc.norang.ca/org.css\" type=\"text/css\" />")
(setq org-html-head-include-default-style nil)

; Inline images in HTML instead of producting links to the image
(setq org-html-inline-images t)

(setq org-html-xml-declaration (quote (("html" . "")
                                       ("was-html" . "<?xml version=\"1.0\" encoding=\"%s\"?>")
                                       ("php" . "<?php echo \"<?xml version=\\\"1.0\\\" encoding=\\\"%s\\\" ?>\"; ?>"))))

(setq org-id-link-to-org-use-id 'create-if-interactive-and-no-custom-id)

(setq org-id-method (quote uuidgen))

;; ; Use IDO for both buffer and file completion and ido-everywhere to t
;; (setq org-completion-use-ido t)
;; (setq ido-everywhere t)
;; (setq ido-max-directory-size 100000)
;; (ido-mode (quote both))
;; ; Use the current window when visiting files and buffers with ido
;; (setq ido-default-file-method 'selected-window)
;; (setq ido-default-buffer-method 'selected-window)
; Use the current window for indirect buffer display
(setq org-indirect-buffer-display 'current-window)


(setq org-insert-heading-respect-content nil)

(setq org-latex-listings t)

;; Specify default packages to be included in every tex file, whether pdflatex or xelatex
(setq org-latex-packages-alist
      '(("" "graphicx" t)
        ("" "longtable" nil)
        ("" "float" nil)
        ("" "sinuitx" nil)
        ("" "booktabs" nil)))

(setq org-link-frame-setup (quote ((vm . vm-visit-folder)
                                   (gnus . org-gnus-no-new-news)
                                   (file . find-file))))

(setq org-link-mailto-program (quote (compose-mail "%a" "%s")))

(setq org-list-demote-modify-bullet (quote (("+" . "-")
                                            ("*" . "-")
                                            ("1." . "-")
                                            ("1)" . "-")
                                            ("A)" . "-")
                                            ("B)" . "-")
                                            ("a)" . "-")
                                            ("b)" . "-")
                                            ("A." . "-")
                                            ("B." . "-")
                                            ("a." . "-")
                                            ("b." . "-"))))

(setq org-log-done (quote time))

(setq org-log-into-drawer t)

(setq org-log-state-notes-insert-after-drawers nil)

; Enable habit tracking (and a bunch of other modules)
(setq org-modules (quote (org-bbdb
                          org-bibtex
                          org-crypt
                          org-gnus
                          org-id
                          org-info
                          org-jsinfo
                          org-habit
                          org-inlinetask
                          org-irc
                          org-mew
                          org-mhe
                          org-protocol
                          org-rmail
                          org-vm
                          org-wl
                          org-w3m)))

(setq org-odd-levels-only nil)

; Targets complete directly with IDO
(setq org-outline-path-complete-in-steps nil)

(setq org-plantuml-jar-path "~/java/plantuml.8024.jar")

(setq org-protocol-default-template-key "w")

;; ;; List of projects
;; ;; norang       - http://www.norang.ca/
;; ;; doc          - http://doc.norang.ca/
;; ;; org-mode-doc - http://doc.norang.ca/org-mode.html and associated files
;; ;; org          - miscellaneous todo lists for publishing
;; (setq org-publish-project-alist
;;       ;
;;       ; http://www.norang.ca/  (norang website)
;;       ; norang-org are the org-files that generate the content
;;       ; norang-extra are images and css files that need to be included
;;       ; norang is the top-level project that gets published
;;       (quote (("norang-org"
;;                :base-directory "~/git/www.norang.ca"
;;                :publishing-directory "/ssh:www-data@www:~/www.norang.ca/htdocs"
;;                :recursive t
;;                :table-of-contents nil
;;                :base-extension "org"
;;                :publishing-function org-html-publish-to-html
;;                :style-include-default nil
;;                :section-numbers nil
;;                :table-of-contents nil
;;                :html-head "<link rel=\"stylesheet\" href=\"norang.css\" type=\"text/css\" />"
;;                :author-info nil
;;                :creator-info nil)
;;               ("norang-extra"
;;                :base-directory "~/git/www.norang.ca/"
;;                :publishing-directory "/ssh:www-data@www:~/www.norang.ca/htdocs"
;;                :base-extension "css\\|pdf\\|png\\|jpg\\|gif"
;;                :publishing-function org-publish-attachment
;;                :recursive t
;;                :author nil)
;;               ("norang"
;;                :components ("norang-org" "norang-extra"))
;;               ;
;;               ; http://doc.norang.ca/  (norang website)
;;               ; doc-org are the org-files that generate the content
;;               ; doc-extra are images and css files that need to be included
;;               ; doc is the top-level project that gets published
;;               ("doc-org"
;;                :base-directory "~/git/doc.norang.ca/"
;;                :publishing-directory "/ssh:www-data@www:~/doc.norang.ca/htdocs"
;;                :recursive nil
;;                :section-numbers nil
;;                :table-of-contents nil
;;                :base-extension "org"
;;                :publishing-function (org-html-publish-to-html org-org-publish-to-org)
;;                :style-include-default nil
;;                :html-head "<link rel=\"stylesheet\" href=\"/org.css\" type=\"text/css\" />"
;;                :author-info nil
;;                :creator-info nil)
;;               ("doc-extra"
;;                :base-directory "~/git/doc.norang.ca/"
;;                :publishing-directory "/ssh:www-data@www:~/doc.norang.ca/htdocs"
;;                :base-extension "css\\|pdf\\|png\\|jpg\\|gif"
;;                :publishing-function org-publish-attachment
;;                :recursive nil
;;                :author nil)
;;               ("doc"
;;                :components ("doc-org" "doc-extra"))
;;               ("doc-private-org"
;;                :base-directory "~/git/doc.norang.ca/private"
;;                :publishing-directory "/ssh:www-data@www:~/doc.norang.ca/htdocs/private"
;;                :recursive nil
;;                :section-numbers nil
;;                :table-of-contents nil
;;                :base-extension "org"
;;                :publishing-function (org-html-publish-to-html org-org-publish-to-org)
;;                :style-include-default nil
;;                :html-head "<link rel=\"stylesheet\" href=\"/org.css\" type=\"text/css\" />"
;;                :auto-sitemap t
;;                :sitemap-filename "index.html"
;;                :sitemap-title "Norang Private Documents"
;;                :sitemap-style "tree"
;;                :author-info nil
;;                :creator-info nil)
;;               ("doc-private-extra"
;;                :base-directory "~/git/doc.norang.ca/private"
;;                :publishing-directory "/ssh:www-data@www:~/doc.norang.ca/htdocs/private"
;;                :base-extension "css\\|pdf\\|png\\|jpg\\|gif"
;;                :publishing-function org-publish-attachment
;;                :recursive nil
;;                :author nil)
;;               ("doc-private"
;;                :components ("doc-private-org" "doc-private-extra"))
;;               ;; 
;;               ;; Miscellaneous pages for other websites
;;               ;; org are the org-files that generate the content
;;               ("org-org"
;;                :base-directory "~/git/org/"
;;                :publishing-directory "/ssh:www-data@www:~/org"
;;                :recursive t
;;                :section-numbers nil
;;                :table-of-contents nil
;;                :base-extension "org"
;;                :publishing-function org-html-publish-to-html
;;                :style-include-default nil
;;                :html-head "<link rel=\"stylesheet\" href=\"/org.css\" type=\"text/css\" />"
;;                :author-info nil
;;                :creator-info nil)
;;               ;; 
;;               ;; http://doc.norang.ca/  (norang website)
;;               ;; org-mode-doc-org this document
;;               ;; org-mode-doc-extra are images and css files that need to be included
;;               ;; org-mode-doc is the top-level project that gets published
;;               ;; This uses the same target directory as the 'doc' project
;;               ("org-mode-doc-org"
;;                :base-directory "~/git/org-mode-doc/"
;;                :publishing-directory "/ssh:www-data@www:~/doc.norang.ca/htdocs"
;;                :recursive t
;;                :section-numbers nil
;;                :table-of-contents nil
;;                :base-extension "org"
;;                :publishing-function (org-html-publish-to-html)
;;                :plain-source t
;;                :htmlized-source t
;;                :style-include-default nil
;;                :html-head "<link rel=\"stylesheet\" href=\"/org.css\" type=\"text/css\" />"
;;                :author-info nil
;;                :creator-info nil)
;;               ("org-mode-doc-extra"
;;                :base-directory "~/git/org-mode-doc/"
;;                :publishing-directory "/ssh:www-data@www:~/doc.norang.ca/htdocs"
;;                :base-extension "css\\|pdf\\|png\\|jpg\\|gif\\|org"
;;                :publishing-function org-publish-attachment
;;                :recursive t
;;                :author nil)
;;               ("org-mode-doc"
;;                :components ("org-mode-doc-org" "org-mode-doc-extra"))
;;               ;; 
;;               ;; http://doc.norang.ca/  (norang website)
;;               ;; org-mode-doc-org this document
;;               ;; org-mode-doc-extra are images and css files that need to be included
;;               ;; org-mode-doc is the top-level project that gets published
;;               ;; This uses the same target directory as the 'doc' project
;;               ("tmp-org"
;;                :base-directory "/tmp/publish/"
;;                :publishing-directory "/ssh:www-data@www:~/www.norang.ca/htdocs/tmp"
;;                :recursive t
;;                :section-numbers nil
;;                :table-of-contents nil
;;                :base-extension "org"
;;                :publishing-function (org-html-publish-to-html org-org-publish-to-org)
;;                :html-head "<link rel=\"stylesheet\" href=\"http://doc.norang.ca/org.css\" type=\"text/css\" />"
;;                :plain-source t
;;                :htmlized-source t
;;                :style-include-default nil
;;                :auto-sitemap t
;;                :sitemap-filename "index.html"
;;                :sitemap-title "Test Publishing Area"
;;                :sitemap-style "tree"
;;                :author-info t
;;                :creator-info t)
;;               ("tmp-extra"
;;                :base-directory "/tmp/publish/"
;;                :publishing-directory "/ssh:www-data@www:~/www.norang.ca/htdocs/tmp"
;;                :base-extension "css\\|pdf\\|png\\|jpg\\|gif"
;;                :publishing-function org-publish-attachment
;;                :recursive t
;;                :author nil)
;;               ("tmp"
;;                :components ("tmp-org" "tmp-extra")))))

(setq org-read-date-prefer-future 'time)

;; Allow refile to create parent tasks with confirmation
(setq org-refile-allow-creating-parent-nodes (quote confirm)) 

(setq org-refile-target-verify-function 'jw/verify-refile-target)

;; Targets include this file and any file contributing to the agenda - up to 9 levels deep
(setq org-refile-targets (quote ((nil :maxlevel . 9)
                                 (org-agenda-files :maxlevel . 9))))

;; Use full outline paths for refile targets - we file directly with IDO
(setq org-refile-use-outline-path t)

(setq org-remove-highlights-with-change t)

(setq org-return-follows-link t)

(setq org-reverse-note-order nil)

(setq org-show-entry-below (quote ((default))))

(setq org-show-following-heading t)

(setq org-show-hierarchy-above t)

(setq org-show-siblings (quote ((default))))

(setq org-special-ctrl-a/e t)

(setq org-special-ctrl-k t)

(setq org-speed-commands-user (quote (("0" . ignore)
                                      ("1" . ignore)
                                      ("2" . ignore)
                                      ("3" . ignore)
                                      ("4" . ignore)
                                      ("5" . ignore)
                                      ("6" . ignore)
                                      ("7" . ignore)
                                      ("8" . ignore)
                                      ("9" . ignore)
                                      ;; 
                                      ("a" . ignore)
                                      ("d" . ignore)
                                      ("h" . jw/hide-other)
                                      ("i" progn
                                       (forward-char 1)
                                       (call-interactively 'org-insert-heading-respect-content))
                                      ("k" . org-kill-note-or-show-branches)
                                      ("l" . ignore)
                                      ("m" . ignore)
                                      ("q" . jw/show-org-agenda)
                                      ("r" . ignore)
                                      ("s" . org-save-all-org-buffers)
                                      ("w" . org-refile)
                                      ("x" . ignore)
                                      ("y" . ignore)
                                      ("z" . org-add-note)
                                      ;; 
                                      ("A" . ignore)
                                      ("B" . ignore)
                                      ("E" . ignore)
                                      ("F" . jw/restrict-to-file-or-follow)
                                      ("G" . ignore)
                                      ("H" . ignore)
                                      ("J" . org-clock-goto)
                                      ("K" . ignore)
                                      ("L" . ignore)
                                      ("M" . ignore)
                                      ("N" . jw/narrow-to-org-subtree)
                                      ("P" . jw/narrow-to-org-project)
                                      ("Q" . ignore)
                                      ("R" . ignore)
                                      ("S" . ignore)
                                      ("T" . jw/org-todo)
                                      ("U" . jw/narrow-up-one-org-level)
                                      ("V" . ignore)
                                      ("W" . jw/widen)
                                      ("X" . ignore)
                                      ("Y" . ignore)
                                      ("Z" . ignore))))

(setq org-src-fontify-natively t)

(setq org-src-preserve-indentation nil)

;; Use the current window for C-c ' source editing
(setq org-src-window-setup 'current-window)

(setq org-startup-folded t)

(setq org-startup-indented t)

;; Don't enable this because it breaks access to emacs from my Android phone
(setq org-startup-with-inline-images nil)

(setq org-structure-template-alist
      (quote (("s" "#+begin_src ?\n\n#+end_src" "<src lang=\"?\">\n\n</src>")
              ("e" "#+begin_example\n?\n#+end_example" "<example>\n?\n</example>")
              ("q" "#+begin_quote\n?\n#+end_quote" "<quote>\n?\n</quote>")
              ("v" "#+begin_verse\n?\n#+end_verse" "<verse>\n?\n</verse>")
              ("c" "#+begin_center\n?\n#+end_center" "<center>\n?\n</center>")
              ("l" "#+begin_latex\n?\n#+end_latex" "<literal style=\"latex\">\n?\n</literal>")
              ("L" "#+latex: " "<literal style=\"latex\">?</literal>")
              ("h" "#+begin_html\n?\n#+end_html" "<literal style=\"html\">\n?\n</literal>")
              ("H" "#+html: " "<literal style=\"html\">?</literal>")
              ("a" "#+begin_ascii\n?\n#+end_ascii")
              ("A" "#+ascii: ")
              ("i" "#+index: ?" "#+index: ?")
              ("I" "#+include %file ?" "<include file=%file markup=\"?\">"))))

(setq org-stuck-projects (quote ("" nil nil "")))

(setq org-table-export-default-format "orgtbl-to-csv")

(setq org-table-use-standard-references (quote from))

; Tags with fast selection keys
(setq org-tag-alist (quote ((:startgroup)
                            ("@errand" . ?e)
                            ("@office" . ?o)
                            ("@home" . ?H)
                            ("@lab" . ?l)
                            (:endgroup)
                            ("WAITING" . ?w)
                            ("HOLD" . ?h)
                            ("PERSONAL" . ?P)
                            ("WORK" . ?W)
                            ("LAB" . ?L)
                            ("ORG" . ?O)
                            ;; ("NORANG" . ?N)
                            ("crypt" . ?E)
                            ("NOTE" . ?n)
                            ("CANCELLED" . ?c)
                            ("FLAGGED" . ??))))

(setq org-tags-exclude-from-inheritance (quote ("crypt")))

(setq org-tags-match-list-sublevels t)

(setq org-time-clocksum-format
      '(:hours "%d" :require-hours t :minutes ":%02d" :require-minutes t))

(setq org-time-stamp-rounding-minutes (quote (1 1)))

(setq org-todo-keyword-faces
      (quote (("TODO" :foreground "red" :weight bold)
              ("NEXT" :foreground "blue" :weight bold)
              ("DONE" :foreground "forest green" :weight bold)
              ("WAITING" :foreground "orange" :weight bold)
              ("HOLD" :foreground "magenta" :weight bold)
              ("CANCELLED" :foreground "forest green" :weight bold)
              ("MEETING" :foreground "forest green" :weight bold)
              ("PHONE" :foreground "forest green" :weight bold))))

(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
              (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)" "PHONE" "MEETING"))))

(setq org-todo-state-tags-triggers
      (quote (("CANCELLED" ("CANCELLED" . t))
              ("WAITING" ("WAITING" . t))
              ("HOLD" ("WAITING") ("HOLD" . t))
              (done ("WAITING") ("HOLD"))
              ("TODO" ("WAITING") ("CANCELLED") ("HOLD"))
              ("NEXT" ("WAITING") ("CANCELLED") ("HOLD"))
              ("DONE" ("WAITING") ("CANCELLED") ("HOLD")))))

(setq org-treat-S-cursor-todo-selection-as-state-change nil)

(setq org-use-fast-todo-selection t)

(setq org-use-speed-commands t)

(setq org-use-sub-superscripts nil)

(setq org-yank-adjusted-subtrees t)

(setq require-final-newline t)

