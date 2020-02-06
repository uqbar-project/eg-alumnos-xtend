package ar.edu.alumnosMockito

import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Test

import static ar.edu.alumnosMockito.MockHelpers.*
import static org.mockito.Mockito.*
import static org.junit.jupiter.api.Assertions.assertFalse
import static org.junit.jupiter.api.Assertions.assertTrue

@DisplayName("Dado un alumno que desaprobó al menos una materia y aprobó otras")
class TestAlumnoDesaprobado {

	Alumno desaprobado
	Curso cursoUnicoAlgo2
	Cursada cursadaDesaprobadaEnAlgo2
	Cursada cursadaAprobadaEnDiscreta
	Nota nota2
	Nota nota7 = new StubNotaSiete
	Curso stubCursoDiscreta = new StubCurso
	
	@BeforeEach
	def void init() {
		// Definicion de stubs y mocks
		cursoUnicoAlgo2 = mockearCurso(2)

		nota2 = mockearNota(2)

		cursadaDesaprobadaEnAlgo2 = new Cursada(cursoUnicoAlgo2) => [
			rendirParcial(1, nota2)
		]
		cursadaAprobadaEnDiscreta = new Cursada(stubCursoDiscreta) => [
			rendirParcial(1, nota7)
		]

		// ***************************************************
		desaprobado = new Alumno => [
			cursar(cursadaDesaprobadaEnAlgo2)
			cursar(cursadaAprobadaEnDiscreta)
		]
	}

	/**
	 * Test de Stub: estado
	 */

	@Test
	@DisplayName("no tiene aprobada la materia que desaprobó")
	def void noAproboAlgoritmos2() {
		assertFalse(cursadaDesaprobadaEnAlgo2.aprobo, "Debería tener desaprobada la cursada de Algo2")
	}

	@Test
	@DisplayName("tiene aprobada alguna de las materias que aprobó")
	def void aproboDiscreta() {
		assertTrue(cursadaAprobadaEnDiscreta.aprobo, "Debería tener aprobada la cursada de Discreta")
	}

	@Test
	@DisplayName("como le faltan aprobar materias aún no se recibió")
	def void noSeRecibio() {
		assertFalse(desaprobado.seRecibio, "El alumno desaprobado no debería estar recibido")
	}

	/**
	 * Test de Mock: expectativas
	 */
	@Test
	@DisplayName("si decoramos la nota de la materia desaprobada, lo hacemos aprobar")
	def void apruebaAlgoritmos2ConUnPocoDeAyuda() {
		// spy permite interceptar un objeto, mientras
		// que mock trabaja sobre una clase
		val Cursada cursadaBuenaAlgo2 = spy(cursadaDesaprobadaEnAlgo2)
		// cuando me pregunten por la cursada de este alumno en Algoritmos 2
		// le digo que aprobo
		doReturn(true).when(cursadaBuenaAlgo2).aprobo
		assertTrue(cursadaBuenaAlgo2.aprobo)
		// Probamos que nunca se pregunto "posta" si chotelli aprobo Algoritmos 2
		verify(nota2, never()).aprobo
	}

}
