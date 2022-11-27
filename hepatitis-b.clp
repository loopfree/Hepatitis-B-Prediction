(deftemplate Description
    (multislot LabResults)
    (slot Diagnosis (type STRING) (default "Unknown"))
)

(defrule CheckHBsAG
    ?d <- (Description (LabResults $?y))
    (not (Description (LabResults $?l HBsAg $?r)))
    =>
    (printout t "HBsAg? ")
    (bind ?HBsAg (read))
    (if (eq ?HBsAg Positive) then (modify ?d (LabResults $?y HBsAg Positive)))
    (if (eq ?HBsAg Negative) then (modify ?d (LabResults $?y HBsAg Negative)))
)

(defrule CheckAntiHDV
    ?d <- (Description (LabResults $?s HBsAg Positive $?f))
    (not (Description (LabResults $?l AntiHDV $?r)))
    =>
    (printout t "AntiHDV? ")
    (bind ?AntiHDV (read))
    (if (eq ?AntiHDV Positive) then (modify ?d (LabResults $?y AntiHDV Positive)))
    (if (eq ?AntiHDV Negative) then (modify ?d (LabResults $?y AntiHDV Negative) (Diagnosis "Hepatitis B+D")))
)

(defrule Diagnose
    (Description (Diagnosis ?y)
    (not (eq ?y "Unknown")))
    =>
    (printout t "Hasil Prediksi = " ?y)
)

; (defrule CheckAntiHBc
;     (Description (ID ?x) (Diagnosis Unknown)) 
;     (Description ID ?x) (LabResults $?s AntiHDV Positive)
; )


; (defrule DiagHepatitisB+D
;     ?d <- (Description (ID ?x) (LabResults $?s AntiHDV Positive $?f) (Diagnosis Unknown))
;     =>
;     (modify ?d Diagnosis (Hepatitis-B+D))
; )

