package ar.edu.alumnosMockito

import static org.mockito.Mockito.*

/**
 * Implementación de mocks de cursos y notas 
 */
class MockHelpers {

	static def mockearCurso(int cantidadParciales) {
		val cursoTemp = mock(Curso)
		when(cursoTemp.cantidadParciales).thenReturn(cantidadParciales)
		cursoTemp
	}

	static def mockearNota(int nota) {
		val notaTemp = mock(Nota)
		when(notaTemp.nota).thenReturn(nota)
		when(notaTemp.aprobo).thenReturn(nota >= 4)
		notaTemp
	}

}