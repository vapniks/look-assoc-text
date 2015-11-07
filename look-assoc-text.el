;;; look-assoc-text.el --- look-mode extensions for searching/filtering images based on OCR & tags

;; Filename: look-assoc-text.el
;; Description: look-mode extensions for searching/filtering images based on OCR & tags
;; Author: Joe Bloggs <vapniks@yahoo.com>
;; Maintainer: Joe Bloggs <vapniks@yahoo.com>
;; Copyleft (Ↄ) 2015, Joe Bloggs, all rites reversed.
;; Created: 2015-11-07 13:39:47
;; Version: 0.1
;; Last-Updated: 2015-11-07 13:39:47
;;           By: Joe Bloggs
;; URL: https://github.com/vapniks/look-assoc-text
;; Keywords: convenience
;; Compatibility: GNU Emacs 24.5.1
;; Package-Requires: ((look-mode "20151107.1206"))
;;
;; Features that might be required by this library:
;;
;; look-mode cl
;;

;;; This file is NOT part of GNU Emacs

;;; License
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.
;; If not, see <http://www.gnu.org/licenses/>.

;;; Commentary: 
;;
;; Bitcoin donations gratefully accepted: 1ArFina3Mi8UDghjarGqATeBgXRDWrsmzo
;;
;;;;


;;; Installation:
;;
;; Put look-assoc-text.el in a directory in your load-path, e.g. ~/.emacs.d/
;; You can add a directory to your load-path with the following line in ~/.emacs
;; (add-to-list 'load-path (expand-file-name "~/elisp"))
;; where ~/elisp is the directory you want to add 
;; (you don't need to do this for ~/.emacs.d - it's added by default).
;;
;; Add the following to your ~/.emacs startup file.
;;
;; (require 'look-assoc-text)

;;; Customize:
;;
;; To automatically insert descriptions of customizable variables defined in this buffer
;; place point at the beginning of the next line and do: M-x auto-document

;;
;; All of the above can customized by:
;;      M-x customize-group RET look-assoc-text RET
;;

;;; Change log:
;;	
;; 2015/11/07
;;      * First released.
;; 

;;; Acknowledgements:
;;
;; 
;;

;;; TODO
;;
;; 
;;

;;; Require
(require 'look-mode)
(require 'cl-lib)


;;; Code:

;; TODO!!
(defcustom look-assoc-text-suffix "txt"
  "File suffix for text files associated with image files."
  :group 'look
  :type 'string)

(defcustom look-assoc-text-directory nil
  "Directory containing (OCR) text files associated with image/pdf files (e.g. from OCR).
This can be either an absolute or relative directory. If nil then text files will be 
searched for in the same directory as the associated image files."
  :group 'look
  :type 'directory)

(defcustom look-assoc-text-types '("jpg" "JPG" "pdf" "PDF" "gif" "GIF" "png" "PNG" "bmp" "BMP" "tiff" "TIFF")
  "File extensions of files that may have associated text files."
  :group 'look
  :type '(repeat string))

(defcustom look-assoc-text-conversion-commands nil
  "Alist of file extensions and corresponding text conversion commands."
  :group 'look
  :type '(alist :key-type (string :tag "file extension") :value-type (string :tag "command")))

;;;###autoload
(defun look-assoc-text-file (file)
  "Return path to text file associated with FILE.
The text should be in `look-assoc-text-directory' (which see),
with file extension `look-assoc-text-suffix'."
  (concat (file-name-as-directory
	   (if look-assoc-text-directory
	       (if (file-name-absolute-p look-assoc-text-directory)
		   look-assoc-text-directory
		 (concat (file-name-directory file) look-assoc-text-directory))
	     (file-name-directory file)))
	  (file-name-base file) "." look-assoc-text-suffix))

;;;###autoload
(defun look-assoc-text-search-forward (regex)
  "Search forward through looked at files."
  (interactive (list (read-regexp "Regexp: ")))
  (while (and look-current-file
	      (not (if (not (member (file-name-extension look-current-file)
				    look-assoc-text-types))
		       (with-temp-file look-current-file (re-search-forward regex nil t))
		     (and (file-exists-p (look-assoc-text-file look-current-file))
			  (with-temp-file (look-assoc-text-file look-current-file)
			    (re-search-forward regex nil t))))))
    (look-at-next-file)))

;;;###autoload
(defun look-assoc-text-search-backward (regex)
  "Search backward through looked at files."
  (interactive (list (read-regexp "Regexp: ")))
  (while (and look-current-file
	      (not (if (not (member (file-name-extension look-current-file)
				    look-assoc-text-types))
		       (with-temp-file look-current-file (re-search-backward regex nil t))
		     (and (file-exists-p (look-assoc-text-file look-current-file))
			  (with-temp-file (look-assoc-text-file look-current-file)
			    (re-search-backward regex nil t))))))
    (look-at-previous-file)))



;; (require 'deferred)
;; (defun look-create-assoc-text-files nil
;;   "Create text files from looked at image files using conversion functions.
;; The conversion functions are defined in `look-conversion-commands'."
;;   (let ((buf (get-buffer-create "*look text extraction*")))
;;   (cl-loop for file in (look-file-list)
;; 	   for ext = (file-name-extension file)
;; 	   for cmdstr = (format (cdr (assoc ext look-conversion-commands)) file)
;; 	   if cmdstr do (start-process "look-text-extraction" buf cmdstr)
;; 	   )
  
;;   ))

(provide 'look-assoc-text)

;; (magit-push)
;; (yaoddmuse-post "EmacsWiki" "look-assoc-text.el" (buffer-name) (buffer-string) "update")

;;; look-assoc-text.el ends here
