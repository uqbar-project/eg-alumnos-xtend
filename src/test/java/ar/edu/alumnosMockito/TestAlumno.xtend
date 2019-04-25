package ar.edu.alumnosMockito

import org.junit.Assert
import org.junit.Before
import org.junit.Test

import static org.mockito.Mockito.*

class StubCurso implements Curso {
	override getCantidadParciales() { 1 }
}

class StubNotaSiete implements Nota {
	
	override aprobo() { true }
	override getNota() { 7 }
	
}

class TestAlumno {

	Alumno marina
	Alumno chotelli
	Curso cursoUnicoAlgo2
	Curso cursoUnicoAlgo3
	Cursada marinaEnAlgoritmos2
	Cursada marinaEnAlgoritmos3
	Cursada chotelliEnAlgoritmos2
	Cursada chotelliEnDiscreta
	Nota nota2
	Nota nota5
	Nota nota10
	Nota nota7 = new StubNotaSiete
	Curso stubCursoDiscreta = new StubCurso
	
	@Before
	def void init() {
		// Definicion de stubs y mocks
		cursoUnicoAlgo2 = mockearCurso(2)
		cursoUnicoAlgo3 = mockearCurso(1)

		nota2 = mockearNota(2)
		nota5 = mockearNota(5)
		nota10 = mockearNota(10)

		marinaEnAlgoritmos2 = new Cursada(cursoUnicoAlgo2) => [
			rendirParcial(1, nota2)
			rendirParcial(1, nota5)
			rendirParcial(2, nota10)
		]
		marinaEnAlgoritmos3 = new Cursada(cursoUnicoAlgo3) => [
			rendirParcial(1, nota10)
		]
		chotelliEnAlgoritmos2 = new Cursada(cursoUnicoAlgo2) => [
			rendirParcial(1, nota2)
		]
		chotelliEnDiscreta = new Cursada(stubCursoDiscreta) => [
			rendirParcial(1, nota7)
		]

		// ***************************************************
		marina = new Alumno("Marina Huberman") => [
			cursar(marinaEnAlgoritmos2)
			cursar(marinaEnAlgoritmos3)
		]

		chotelli = new Alumno("Gervasio Chotelli") => [
			cursar(chotelliEnAlgoritmos2)
			cursar(chotelliEnDiscreta)
		]
	}

	/**
	 * Test de Stub: estado
	 */
	@Test
	def void marinaAproboAlgoritmos2() {
		Assert.assertTrue(marinaEnAlgoritmos2.aprobo)
	}

	@Test
	def void marinaAproboAlgoritmos3() {
		Assert.assertTrue(marinaEnAlgoritmos3.aprobo)
	}

	@Test
	def void chotelliNoAproboAlgoritmos2() {
		Assert.assertFalse(chotelliEnAlgoritmos2.aprobo)
	}

	@Test
	def void chotelliAproboDiscreta() {
		Assert.assertTrue(chotelliEnDiscreta.aprobo)
	}

	@Test
	def void marinaSeRecibio() {
		Assert.assertTrue(marina.seRecibio)
	}

	@Test
	def void chotelliNoSeRecibio() {
		Assert.assertFalse(chotelli.seRecibio)
	}

	/**
	 * Test de Mock: expectativas
	 */
	@Test
	def void paraSaberSiMarinaAproboAlgoritmos2HayQueRevisar3NotasEn1Curso() {
		marinaEnAlgoritmos2.aprobo
		verify(cursoUnicoAlgo2, times(1)).cantidadParciales
		verify(nota2, times(1)).aprobo
		verify(nota5, times(1)).aprobo
		verify(nota10, times(1)).aprobo
	}

	@Test
	def void paraSaberSiMarinaAproboAlgoritmos2DelegamosBienEnClaseNota() {
		marinaEnAlgoritmos2.aprobo
		verify(nota2, never()).nota
	}

	@Test
	def void paraSaberSiMarinaAproboAlgoritmos2NoUsamosElMensajeNotasDeNota() {
		marinaEnAlgoritmos2.aprobo
		#[nota2, nota5, nota10].forEach [ nota |
			verify(nota, never()).nota
			verify(nota, times(1)).aprobo
		]
	}

	@Test
	def void chotelliApruebaAlgoritmos2ConUnPocoDeAyuda() {
		// spy permite interceptar un objeto, mientras
		// que mock trabaja sobre una clase
		val Cursada cursadaBuenaChotelli = 
			spy(chotelliEnAlgoritmos2)
		// cuando me pregunten por chotelli en Algoritmos 2
		// le digo que aprobo
		doReturn(true).when(cursadaBuenaChotelli).aprobo
		Assert.assertTrue(cursadaBuenaChotelli.aprobo)
		// Probamos que nunca se pregunto "posta" si chotelli aprobo Algoritmos 2
		verify(nota2, never()).aprobo
	}

	/**
	 * Implementación de mocks de cursos y notas 
	 */
	def mockearCurso(int cantidadParciales) {
		val cursoTemp = mock(Curso)
		when(cursoTemp.cantidadParciales)
			.thenReturn(cantidadParciales)
		cursoTemp
	}

	def mockearNota(int nota) {
		val notaTemp = mock(Nota)
		when(notaTemp.nota).thenReturn(nota)
		when(notaTemp.aprobo).thenReturn(nota >= 4)
		notaTemp
	}

}
