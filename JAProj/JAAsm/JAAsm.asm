;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;Funkcja, której zadaniem jest przekszta³cenie sk³adowych RGB w zale¿noœci od 
;wartoœci wspó³czynnika kontrastu.
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;Argumenty funckji zosta³y przekazane do nastêpuj¹cych rejestrów:
;*	RSI-adres pocz¹tku tablicy
;*	RDI-szrokoœæ przetwarzanej czêœci obrazu
;*	R8-d³ugoœæ przetwarzanej czêœci obrazu
;*	XMM3-wspó³czynnik kontrastu
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
.data
maxValue REAL8 255.0		
ratio REAL8 0.5
.code
MyProc1 proc
emms

mov eax,edi		;przeniesienie do rejestru eax m³odszej czêœci rejestru rdi
mul r8d		;eax<-eax*r8d, wymno¿enie zawartoœci rejestru eax z zawartoœci¹ rejestru r8d
mov r10,4		;przeniesienie do rejestru r10 wartoœci 4
mul r10d		;eax<-eax*r10d, wymno¿enie zawartoœci rejestru eax z zawartoœci¹ rejestru r10d
mov r10,rax		;przeniesienie zawartoœci z rejestru rax do rejestru r10. Jest to rozmiar tablicy do przetworzenia
mov r11,0		;rejestr r11 staje siê licznikiem pêtli


loop1:
	movzx eax,byte ptr[rsi+r11]		;pobranie sk³adowej B z tablicy
	
	cvtsi2sd xmm4,eax		;konwersja 32-bitowej wartoœci ca³kowitoliczbowej do 64-bitowej wartoœci zmiennoprzecinkowej. Zapisanie rozmiaru tablicy w rejestrze xmm4
	divsd xmm4,maxValue		;podzielenie wartoœci w rejestrze xmm4 przez 255.0
	subsd xmm4,ratio		;odjêcie 0.5 od wartoœci w rejestrze xmm4 
	mulsd xmm4,xmm3		;pomno¿enie wartoœci w rejestrze xmm4 przez wspó³czynnik kontrastu
	addsd xmm4,ratio	;dodanie 0.5 do wartoœci znajduj¹cej siê w rejestrze xmm4
	mulsd xmm4,maxValue		;pomno¿enie wartoœci w rejestrze xmm4 przez 255.0

	cvttsd2si eax,xmm4		;konwersja 64-bitowej wartoœci zmiennoprzecinkowej do 32-bitowej wartoœci ca³kowitoliczbowej
	cmp eax,250		;porównanie zawartoœci rejestru eax oraz wartoœci 250
	jnle biggerB		;skok, jeœli nie mniejsze lub równe do etykiety biggerB

	cmp eax,0		;porównanie zawartoœci rejestru eax oraz wartoœci 0
	jle lowerB	;skok jeœli mniejsze lub równe do etykiety lowerB


	greenParam:
		mov byte ptr[rsi+r11],al		;zapisanie przetworznonego parametru B do tablicy

		movzx eax,byte ptr[rsi+r11+1]		;pobranie sk³adowej G z tablicy
		cvtsi2sd xmm5,eax		;konwersja 32-bitowej wartoœci ca³kowitoliczbowej do 64-bitowej wartoœci zmiennoprzecinkowej
		divsd xmm5,maxValue		;podzielenie wartoœci w rejestrze xmm5 przez 255.0
		subsd xmm5,ratio		;odjêcie 0.5 od wartoœci w rejestrze xmm5 
		mulsd xmm5,xmm3		;pomno¿enie wartoœci w rejestrze xmm5 przez wspó³czynnik kontrastu
		addsd xmm5,ratio	;dodanie 0.5 do wartoœci znajduj¹cej siê w rejestrze xmm5
		mulsd xmm5,maxValue		;pomno¿enie wartoœci w rejestrze xmm5 przez 255.0

		cvttsd2si eax,xmm5		;konwersja 64-bitowej wartoœci zmiennoprzecinkowej do 32-bitowej wartoœci ca³kowitoliczbowej
		cmp eax,250		;porównanie wartoœci z rejestru eax oraz wartoœci 250
		jnle biggerG	;skok jeœli nie mniejsze lub równe do etykiety lowerG

		cmp eax,0		;porównanie wartoœci z rejestru eax oraz wartoœci 0
		jle lowerG		;skok jeœli mniejsze lub równe do etykiety lowerG


	redParam:
		mov byte ptr[rsi+r11+1],al		;zapisanie przetworzonego parametru B do tablicy

		movzx eax,byte ptr[rsi+r11+2]		;pobranie sk³adowej R z tablicy
		cvtsi2sd xmm6,eax		;konwersja 32-bitowej wartoœci ca³kowitoliczbowej do 64-bitowej wartoœci zmiennoprzecinkowej
		divsd xmm6,maxValue		;podzielenie wartoœci w rejestrze xmm6 przez 255.0
		subsd xmm6,ratio		;odjêcie 0.5 od wartoœci w rejestrze xmm6 
		mulsd xmm6,xmm3		;pomno¿enie wartoœci w rejestrze xmm6 przez wspó³czynnik kontrastu
		addsd xmm6,ratio	;dodanie 0.5 do wartoœci znajduj¹cej siê w rejestrze xmm6
		mulsd xmm6,maxValue		;pomno¿enie wartoœci w rejestrze xmm6 przez 255.0

		cvttsd2si eax,xmm6		;konwersja 64-bitowej wartoœci zmiennoprzecinkowej do 32-bitowej wartoœci ca³kowitoliczbowej
		cmp eax,250		;porównanie wartoœci z rejestru eax oraz wartoœci 250
		jnle biggerR		;skok jeœli nie mniejsze lub równe do etykiety biggerR

		cmp eax,0		;porównanie wartoœci z rejestru eax oraz wartoœci 0
		jle lowerR		;skok jeœli mniejsze lub równe do etykiety lowerR

		
	
	endLoop:
		mov byte ptr[rsi+r11+2],al		;zapisanie przetworzonego parametru R do tablicy
		
		cmp r11,r10		;porównanie rozmiaru tablicy oraz aktualnej wartoœci indexu tablicy
		jE endProc		;skok do etykiety endProc jeœli za³a tablica zosta³a przetworzona
		add r11,4		;dodanie wartoœci 4 do indexu tablicy
		jmp loop1		;skok do etykiety loop1

biggerB:
	mov eax, 255		;zapisanie w rejestrze eax wartoœci 255
	jmp greenParam		;skok do etykiety greenParam

lowerB:
	mov eax,0		;zapisanie w rejestrze eax wartoœci 0
	jmp greenParam		;skok do etykiety geenParam

biggerG:
	mov eax,255		;zapisanie w rejestrze eax wartoœci 255
	jmp redParam		;skok do etykiety redParam

lowerG:
	mov eax,0		;zapisanie w rejestrze eax wartoœci 0
	jmp redParam		;skok do etykiety redParam

biggerR:
	mov eax,255		;zapisanie w rejestrze eax wartoœci 255
	jmp endLoop		;skok do etykiety endLoop

lowerR:
	mov eax,0		;zapisanie w rejestrze eax wartoœci 0
	jmp endLoop		;skok do etykiety endLoop

endProc:		;etykieta koñcz¹ca wykonywanie procedury
	ret
	

MyProc1 endp
end
