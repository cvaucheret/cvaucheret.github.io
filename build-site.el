;; Set the package installation directory so that packages aren't stored in the
;; ~/.emacs.d/elpa path.
(require 'package)
(setq package-user-dir (expand-file-name "./.packages"))
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

;; Initialize the package system
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Install dependencies
(package-install 'htmlize)

;; Load the publishing system
(require 'ox-publish)

;; Customize the HTML output
(setq
      org-export-with-section-numbers nil
      org-export-with-toc nil

      ;; ISO8601 Date Format
      org-export-date-timestamp-format "%Y-%m-%d"
      org-html-metadata-timestamp-format "%Y-%m-%d"


      org-html-validation-link nil            ;; Don't show validation link
      ;; Enable HTML5
      org-html-html5-fancy t
      org-html-doctype     "html5"
      org-html-head-include-scripts nil       ;; Use our own scripts
      org-html-head-include-default-style nil ;; Use our own styles
      org-html-htmlize-output-type 'css
      )

(setq org-export-global-macros
      '(("timestamp" . "@@html:<span class=\"timestamp\">[$1]</span>@@")))

;; Render ~code~ as kbd tag in HTML
(add-to-list 'org-html-text-markup-alist '(code . "<kbd>%s</kbd>"))

(defun my--sitemap-dated-entry-format (entry style project)
  "Sitemap PROJECT ENTRY STYLE format that includes date."
  (let ((filename (org-publish-find-title entry project)))
    (if (= (length filename) 0)
        (format "*%s*" entry)
      (format "{{{timestamp(%s)}}} [[file:%s][%s]]"
              (format-time-string "%Y-%m-%d"
				  (org-publish-find-date entry project))
              entry
              filename))))


;; Define the publishing project
(setq org-publish-project-alist
      `(("org-site:main"
             :recursive t
             :base-directory "./content"
             :publishing-function org-html-publish-to-html
             :publishing-directory "./public"
             :with-author nil           ;; Don't include author name
             :with-creator t            ;; Include Emacs and Org versions in footer
             :with-toc nil                ;; Include a table of contents
             :section-numbers nil       ;; Don't include section numbers
	     :html-head "
                         <link rel=\"stylesheet\" href=\"style.css\" type=\"text/css\"/>
<link rel=\"stylesheet\" media=\"(prefers-color-scheme: light)\" href=\"modus-operandi.css\" type=\"text/css\"/>
<link rel=\"stylesheet\" media=\"(prefers-color-scheme: dark)\" href=\"modus-vivendi.css\" type=\"text/css\"/>
"
	     :html-preamble "<div id=\"updated\">Actualizado: %C</div>"
	     :html-link-home "https://cvaucheret.github.io/"
	     :html-link-up "https://cvaucheret.github.io/"
	     :html-home/up-format "<div id=\"org-div-home-and-up\"><a href=\"%s\">MANÍ</a></div>"
             :time-stamp-file nil)
	("org-static"
	     :base-directory "./content"
	     :base-extension "css\\|js\\|png\\|jpg\\|jpeg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
	     :publishing-directory "./public"
	     :recursive t
	     :publishing-function org-publish-attachment)
	("blog"
	     :base-directory "./content/blog/"
	     :base-extension "org"
	     :recursive t
	     :publishing-directory "./public/blog/"
	     :publishing-function org-html-publish-to-html
	     :html-link-home "https://cvaucheret.github.io/"
	     :html-link-up "https://cvaucheret.github.io/blog"
	     :html-home/up-format "<div id=\"org-div-home-and-up\"><a href=\"%s\">MANÍES</a> <a href=\"%s\">MANÍ</a> </div>"
	     :auto-sitemap t
	     :with-author nil           ;; Don't include author name
             :with-creator t            ;; Include Emacs and Org versions in footer
             :with-toc nil                ;; Include a table of contents
             :section-numbers nil       ;; Don't include section numbers
	     :html-head "
                         <link rel=\"stylesheet\" href=\"../style.css\" type=\"text/css\"/>
<link rel=\"stylesheet\" media=\"(prefers-color-scheme: light)\" href=\"../modus-operandi.css\" type=\"text/css\"/>
<link rel=\"stylesheet\" media=\"(prefers-color-scheme: dark)\" href=\"../modus-vivendi.css\" type=\"text/css\"/>
"
	     :html-preamble "<div id=\"updated\">Actualizado: %C</div>"
	     :sitemap-title "Manices"
	     :sitemap-filename "index.org"
	     :time-stamp-file nil
             :sitemap-format-entry my--sitemap-dated-entry-format
	     :sitemap-sort-files anti-chronologically)
       ))    ;; Don't include time stamp in file

;; Generate the site output
(org-publish-all t)

(message "Build complete!")
