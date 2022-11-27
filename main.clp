; Authored By:
; 13520071 Wesly Giovano
; 13520113 Brianaldo Phandiarta
; 13520131 Steven

; How to Run:
; (clear)
; (load "main.clp")
; (reset)
; (run)

; ------------------------------------------------------------------ ;
; ---------------------------  TEMPLATE  --------------------------- ;
; ------------------------------------------------------------------ ;

(deftemplate Description
    (multislot LabResults)
    (slot Diagnosis (type STRING) (default "Unknown"))
)

(deffacts NewFact 
    (Description)
)

; ------------------------------------------------------------------ ;
; ----------------------------  HELPER  ---------------------------- ;
; ------------------------------------------------------------------ ;

(defrule PrintDiagnosis
    (not (Description (Diagnosis "Unknown")))
    (Description (Diagnosis ?y))
    =>
    (printout t "Hasil Prediksi = " ?y crlf)
)

; ------------------------------------------------------------------ ;
; -------------------------   Height = 0   ------------------------- ;
; ------------------------------------------------------------------ ;

(defrule CheckHBsAg
    ?d <- (Description (LabResults $?y))
    (not (Description (LabResults $?l HBsAg $?r)))
    =>
    (printout t "HBsAg? ")
    (bind ?HBsAg (read))
    (if (eq ?HBsAg positive) then (modify ?d (LabResults $?y HBsAg Positive)))
    (if (eq ?HBsAg negative) then (modify ?d (LabResults $?y HBsAg Negative)))
)

; ------------------------------------------------------------------ ;
; -------------------------   Height = 1   ------------------------- ;
; ------------------------------------------------------------------ ;

(defrule CheckAntiHDV
    ?d <- (Description (LabResults $?y))
    (Description (LabResults $?s HBsAg Positive $?f))
    (not (Description (LabResults $?l AntiHDV $?r)))
    =>
    (printout t "anti-HDV? ")
    (bind ?AntiHDV (read))
    (if (eq ?AntiHDV positive) then (modify ?d (LabResults $?y AntiHDV Positive) (Diagnosis "Hepatitis B+D")))
    (if (eq ?AntiHDV negative) then (modify ?d (LabResults $?y AntiHDV Negative)))
)

(defrule CheckAntiHBs2
    ?d <- (Description (LabResults $?y))
    (Description (LabResults $?s HBsAg Negative $?f))
    (not (Description (LabResults $?l AntiHBs $?r)))
    =>
    (printout t "anti-HBs? ")
    (bind ?AntiHBs (read))
    (if (eq ?AntiHBs positive) then (modify ?d (LabResults $?y AntiHBs Positive)))
    (if (eq ?AntiHBs negative) then (modify ?d (LabResults $?y AntiHBs Negative)))
)

; ------------------------------------------------------------------ ;
; -------------------------   Height = 2   ------------------------- ;
; ------------------------------------------------------------------ ;

(defrule CheckAntiHBc1
    ?d <- (Description (LabResults $?y))
    (Description (LabResults $?q HBsAg Positive $?e))
    (Description (LabResults $?s AntiHDV Negative $?f))
    (not (Description (LabResults $?l AntiHBc $?r)))
    =>
    (printout t "anti-HBc? ")
    (bind ?AntiHBc (read))
    (if (eq ?AntiHBc positive) then (modify ?d (LabResults $?y AntiHBc Positive)))
    (if (eq ?AntiHBc negative) then (modify ?d (LabResults $?y AntiHBc Negative) (Diagnosis "Uncertain configuration")))
)

(defrule CheckAntiHBc2
    ?d <- (Description (LabResults $?y))
    (Description (LabResults $?q HBsAg Negative $?e))
    (Description (LabResults $?s AntiHBs Positive $?f))
    (not (Description (LabResults $?l AntiHBc $?r)))
    =>
    (printout t "anti-HBc? ")
    (bind ?AntiHBc (read))
    (if (eq ?AntiHBc positive) then (modify ?d (LabResults $?y AntiHBc Positive) (Diagnosis "Cured")))
    (if (eq ?AntiHBc negative) then (modify ?d (LabResults $?y AntiHBc Negative) (Diagnosis "Vaccinated")))
)

(defrule CheckAntiHBc3
    ?d <- (Description (LabResults $?y))
    (Description (LabResults $?q HBsAg Negative $?e))
    (Description (LabResults $?s AntiHBs Negative $?f))
    (not (Description (LabResults $?l AntiHBc $?r)))
    =>
    (printout t "anti-HBc? ")
    (bind ?AntiHBc (read))
    (if (eq ?AntiHBc positive) then (modify ?d (LabResults $?y AntiHBc Positive) (Diagnosis "Unclear (possible resolved)")))
    (if (eq ?AntiHBc negative) then (modify ?d (LabResults $?y AntiHBc Negative) (Diagnosis "Healthy not vaccinated or suspicious")))
)

; ------------------------------------------------------------------ ;
; -------------------------   Height = 3   ------------------------- ;
; ------------------------------------------------------------------ ;

(defrule CheckAntiHBs1
    ?d <- (Description (LabResults $?y))
    (Description (LabResults $?q HBsAg Positive $?e))
    (Description (LabResults $?s AntiHBc Positive $?f))
    (not (Description (LabResults $?l AntiHBs $?r)))
    =>
    (printout t "anti-HBs? ")
    (bind ?AntiHBs (read))
    (if (eq ?AntiHBs positive) then (modify ?d (LabResults $?y AntiHBs Positive) (Diagnosis "Uncertain configuration")))
    (if (eq ?AntiHBs negative) then (modify ?d (LabResults $?y AntiHBs Negative)))
)

; ------------------------------------------------------------------ ;
; -------------------------   Height = 4   ------------------------- ;
; ------------------------------------------------------------------ ;

(defrule CheckIgMAntiHBc
    ?d <- (Description (LabResults $?y))
    (Description (LabResults $?q AntiHBs Negative $?e))
    (Description (LabResults $?s HBsAg Positive $?f))
    (not (Description (LabResults $?l IgMAntiHBc $?r)))
    =>
    (printout t "IgM anti-HBc? ")
    (bind ?IgMAntiHBc (read))
    (if (eq ?IgMAntiHBc positive) then (modify ?d (LabResults $?y IgMAntiHBc Positive) (Diagnosis "Acute infection")))
    (if (eq ?IgMAntiHBc negative) then (modify ?d (LabResults $?y IgMAntiHBc Negative) (Diagnosis "Chronic infection")))
)
