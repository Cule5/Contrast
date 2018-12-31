;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;Funkcja, kt�rej zadaniem jest przekszta�cenie sk�adowych RGB w zale�no�ci od 
;warto�ci wsp�czynnika kontrastu.
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;Argumenty funckji zosta�y przekazane do nast�puj�cych rejestr�w:
;*	RSI-adres pocz�tku tablicy
;*	RDI-szroko�� przetwarzanej cz�ci obrazu
;*	R8-d�ugo�� przetwarzanej cz�ci obrazu
;*	XMM3-wsp�czynnik kontrastu
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
.data
maxValue REAL8 255.0		
ratio REAL8 0.5
.code
MyProc1 proc
emms

mov eax,edi		;przeniesienie do rejestru eax m�odszej cz�ci rejestru rdi
mul r8d		;eax<-eax*r8d, wymno�enie zawarto�ci rejestru eax z zawarto�ci� rejestru r8d
mov r10,4		;przeniesienie do rejestru r10 warto�ci 4
mul r10d		;eax<-eax*r10d, wymno�enie zawarto�ci rejestru eax z zawarto�ci� rejestru r10d
mov r10,rax		;przeniesienie zawarto�ci z rejestru rax do rejestru r10. Jest to rozmiar tablicy do przetworzenia
mov r11,0		;rejestr r11 staje si� licznikiem p�tli


loop1:
	movzx eax,byte ptr[rsi+r11]		;pobranie sk�adowej B z tablicy
	
	cvtsi2sd xmm4,eax		;konwersja 32-bitowej warto�ci ca�kowitoliczbowej do 64-bitowej warto�ci zmiennoprzecinkowej. Zapisanie rozmiaru tablicy w rejestrze xmm4
	divsd xmm4,maxValue		;podzielenie warto�ci w rejestrze xmm4 przez 255.0
	subsd xmm4,ratio		;odj�cie 0.5 od warto�ci w rejestrze xmm4 
	mulsd xmm4,xmm3		;pomno�enie warto�ci w rejestrze xmm4 przez wsp�czynnik kontrastu
	addsd xmm4,ratio	;dodanie 0.5 do warto�ci znajduj�cej si� w rejestrze xmm4
	mulsd xmm4,maxValue		;pomno�enie warto�ci w rejestrze xmm4 przez 255.0

	cvttsd2si eax,xmm4		;konwersja 64-bitowej warto�ci zmiennoprzecinkowej do 32-bitowej warto�ci ca�kowitoliczbowej
	cmp eax,250		;por�wnanie zawarto�ci rejestru eax oraz warto�ci 250
	jnle biggerB		;skok, je�li nie mniejsze lub r�wne do etykiety biggerB

	cmp eax,0		;por�wnanie zawarto�ci rejestru eax oraz warto�ci 0
	jle lowerB	;skok je�li mniejsze lub r�wne do etykiety lowerB


	greenParam:
		mov byte ptr[rsi+r11],al		;zapisanie przetworznonego parametru B do tablicy

		movzx eax,byte ptr[rsi+r11+1]		;pobranie sk�adowej G z tablicy
		cvtsi2sd xmm5,eax		;konwersja 32-bitowej warto�ci ca�kowitoliczbowej do 64-bitowej warto�ci zmiennoprzecinkowej
		divsd xmm5,maxValue		;podzielenie warto�ci w rejestrze xmm5 przez 255.0
		subsd xmm5,ratio		;odj�cie 0.5 od warto�ci w rejestrze xmm5 
		mulsd xmm5,xmm3		;pomno�enie warto�ci w rejestrze xmm5 przez wsp�czynnik kontrastu
		addsd xmm5,ratio	;dodanie 0.5 do warto�ci znajduj�cej si� w rejestrze xmm5
		mulsd xmm5,maxValue		;pomno�enie warto�ci w rejestrze xmm5 przez 255.0

		cvttsd2si eax,xmm5		;konwersja 64-bitowej warto�ci zmiennoprzecinkowej do 32-bitowej warto�ci ca�kowitoliczbowej
		cmp eax,250		;por�wnanie warto�ci z rejestru eax oraz warto�ci 250
		jnle biggerG	;skok je�li nie mniejsze lub r�wne do etykiety lowerG

		cmp eax,0		;por�wnanie warto�ci z rejestru eax oraz warto�ci 0
		jle lowerG		;skok je�li mniejsze lub r�wne do etykiety lowerG


	redParam:
		mov byte ptr[rsi+r11+1],al		;zapisanie przetworzonego parametru B do tablicy

		movzx eax,byte ptr[rsi+r11+2]		;pobranie sk�adowej R z tablicy
		cvtsi2sd xmm6,eax		;konwersja 32-bitowej warto�ci ca�kowitoliczbowej do 64-bitowej warto�ci zmiennoprzecinkowej
		divsd xmm6,maxValue		;podzielenie warto�ci w rejestrze xmm6 przez 255.0
		subsd xmm6,ratio		;odj�cie 0.5 od warto�ci w rejestrze xmm6 
		mulsd xmm6,xmm3		;pomno�enie warto�ci w rejestrze xmm6 przez wsp�czynnik kontrastu
		addsd xmm6,ratio	;dodanie 0.5 do warto�ci znajduj�cej si� w rejestrze xmm6
		mulsd xmm6,maxValue		;pomno�enie warto�ci w rejestrze xmm6 przez 255.0

		cvttsd2si eax,xmm6		;konwersja 64-bitowej warto�ci zmiennoprzecinkowej do 32-bitowej warto�ci ca�kowitoliczbowej
		cmp eax,250		;por�wnanie warto�ci z rejestru eax oraz warto�ci 250
		jnle biggerR		;skok je�li nie mniejsze lub r�wne do etykiety biggerR

		cmp eax,0		;por�wnanie warto�ci z rejestru eax oraz warto�ci 0
		jle lowerR		;skok je�li mniejsze lub r�wne do etykiety lowerR

		
	
	endLoop:
		mov byte ptr[rsi+r11+2],al		;zapisanie przetworzonego parametru R do tablicy
		
		cmp r11,r10		;por�wnanie rozmiaru tablicy oraz aktualnej warto�ci indexu tablicy
		jE endProc		;skok do etykiety endProc je�li za�a tablica zosta�a przetworzona
		add r11,4		;dodanie warto�ci 4 do indexu tablicy
		jmp loop1		;skok do etykiety loop1

biggerB:
	mov eax, 255		;zapisanie w rejestrze eax warto�ci 255
	jmp greenParam		;skok do etykiety greenParam

lowerB:
	mov eax,0		;zapisanie w rejestrze eax warto�ci 0
	jmp greenParam		;skok do etykiety geenParam

biggerG:
	mov eax,255		;zapisanie w rejestrze eax warto�ci 255
	jmp redParam		;skok do etykiety redParam

lowerG:
	mov eax,0		;zapisanie w rejestrze eax warto�ci 0
	jmp redParam		;skok do etykiety redParam

biggerR:
	mov eax,255		;zapisanie w rejestrze eax warto�ci 255
	jmp endLoop		;skok do etykiety endLoop

lowerR:
	mov eax,0		;zapisanie w rejestrze eax warto�ci 0
	jmp endLoop		;skok do etykiety endLoop

endProc:		;etykieta ko�cz�ca wykonywanie procedury
	ret
	

MyProc1 endp
end
