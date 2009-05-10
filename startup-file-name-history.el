;;; startup-file-name-history.el --- command line files into file-name-history

;; Copyright 2007, 2008 Kevin Ryde

;; Author: Kevin Ryde <user42@zip.com.au>
;; Version: 2
;; Keywords: files
;; URL: http://www.geocities.com/user42_kevin/startup-file-name-history/index.html

;; startup-file-name-history.el is free software; you can redistribute it
;; and/or modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 3, or (at your
;; option) any later version.
;;
;; startup-file-name-history.el is distributed in the hope that it will be
;; useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General
;; Public License for more details.
;;
;; You can get a copy of the GNU General Public License online at
;; <http://www.gnu.org/licenses>.


;;; Commentary:

;; This is a spot of code to get filenames passed on the Emacs command line
;; added to `file-name-history' (as well as opened in buffers in the usual
;; way).
;;
;; savehist.el can be used at the same time if desired.  `savehist-mode'
;; initializes `file-name-history' when .emacs is evaluated, and then
;; startup-file-name-history.el runs later during command line processing
;; and adds to whatever savehist loaded (which is what you want).

;;; Install:

;; Put startup-file-name-history.el somewhere in your `load-path', and in
;; .emacs put
;;
;;     (require 'startup-file-name-history)
;;
;; There's an autoload cookie below for this, if you use
;; `update-file-autoloads' and friends.

;;; Emacsen:

;; Designed for Emacs 21 and 22.
;; Doesn't work in XEmacs 21 (but does no harm).

;;; History:

;; Version 1 - the first version
;; Version 2 - note ok with savehist.el


;;; Code:

;;;###autoload (require 'startup-file-name-history)

(defun startup-file-name-history-add ()
  "Add command line filenames to `file-name-history'.
This function is for use from `command-line-functions'.  `argi'
is bound to a filename and is added to `file-name-history'.  The
return is nil, meaning argi has not been consumed but should be
passed to subsequent functions or the default filename opener.

This function should be near the end of `command-line-functions',
after any handlers for strange non-filename stuff, so it only
sees filenames."

  (let ((filename (expand-file-name argi command-line-default-directory)))
    (if (fboundp 'add-to-history) ;; new in emacs22
        (add-to-history 'file-name-history filename)
      (setq file-name-history
            (cons filename file-name-history))))
  nil) ;; argi not consumed

;; XEmacs 21.4 doesn't have `command-line-functions' (it's in the manual,
;; but not in the code).
(when (boundp 'command-line-functions)

  (add-to-list 'command-line-functions 'startup-file-name-history-add
               ;; `t' to append, so we're near the end of the list and hence
               ;; only see what reaches the default filename open handler,
               ;; not strange stuff crunched by other command-line-functions
               t))

(provide 'startup-file-name-history)

;;; startup-file-name-history.el ends here
