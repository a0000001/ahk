#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force
;#NoTrayIcon

; note to self: this must be in UTF-8 encoding.

;; Computer Science symbols
; ⊕→←↓↑
; RCtrl & +:: Send ⊕
LAlt & Right:: Send {Space}→{Space}
LAlt & Left:: Send {Space}←{Space}
LAlt & Down:: Send {Space}↓{Space}
LAlt & Up:: Send {Space}↑{Space}


;; Greek Letters
; αβΔ∞σμτγλεΩθπ δ
RAlt & a::Send α
RAlt & b::Send β
RAlt & d::Send Δ
RAlt & e::Send ε
RAlt & g::Send γ
RAlt & h::Send θ
RAlt & l::Send λ
RAlt & m::Send μ
RAlt & o::Send Ω
RAlt & s::Send σ
RAlt & t::Send τ
RAlt & p::Send π
RCtrl & d::Send δ

;; Comparison characters
; ≤≥≠
RAlt & <::Send ≤
RAlt & >::Send ≥
RAlt & =::Send ≠

;; Math characters
; ≈∞
RCtrl & =::Send ≈
RAlt & 0::Send ∞

;; Logic synbols
; ∨∧¬⇒⇔∀
RCtrl & >::Send {Space}∧{Space}
RCtrl & <::Send {Space}∨{Space}
RCtrl & n::Send ¬
RCtrl & Right::Send {Space}⇒{Space}
RCtrl & Left::Send {Space}⇔{Space}
RCtrl & a::Send ∀
RCtrl & e::Send ∃

~+!x::ExitApp			;Shift+Alt+X = Emergency Exit
~!+r::Reload			;Shift+Alt+R = Reload