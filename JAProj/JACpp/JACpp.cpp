// MathLibrary.cpp : Defines the exported functions for the DLL.
/*
 * Funkcja, której zadaniem jest przekszta³cenie skladowych RGB w zale¿noœci od wspó³czynnika kontrastu
 */
#include "stdafx.h"

#include "JACpp.h"

 //Funkcja zajmujaca sie przeksztalcenie tablicy z pikselami
void MyProc2(unsigned char* tab, int width, int height, double contrastLevel)
{
	double red = 0.0;
	double green = 0.0;
	double blue = 0.0;
	const int size = 4 * width * height;		//ustalenie rozmiaru tablicy
	for (int i = 0; i < size; i += 4)
	{
		blue = ((((tab[i] / 255.0) - 0.5) *contrastLevel) + 0.5) * 255.0;		//przeksztalcenie skladowych RGB
		green = ((((tab[i + 1] / 255.0) - 0.5) *contrastLevel) + 0.5) * 255.0;
		red = ((((tab[i + 2] / 255.0) - 0.5) *contrastLevel) + 0.5) * 255.0;

		if (blue > 255)			//sprawdzanie czy przeksztalcone skladowe nie sa wieksze od 255 lub mniejsze od 0
			blue = 255;
		else if (blue < 0)
			blue = 0;

		if (green > 255)
			green = 255;
		else if (green < 0)
			green = 0;

		if (red > 255)
			red = 255;
		else if (red < 0)
			red = 0;


		tab[i] = static_cast<unsigned char>(blue);		//zapis do tablicy przeksztalconych skladowych RGB
		tab[i + 1] = static_cast<unsigned char>(green);
		tab[i + 2] = static_cast<unsigned char>(red);
	}
}
