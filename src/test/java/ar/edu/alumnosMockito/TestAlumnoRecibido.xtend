package ar.edu.alumnosMockito

import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Test

import static ar.edu.alumnosMockito.MockHelpers.*
import static org.junit.jupiter.api.Assertions.assertTrue
import static org.mockito.Mockito.*

@DisplayName("Dado un alumno recibido")
class TestAlumnoRecibido {

	Alumno recibido
	Curso cursoUnicoAlgo2
	Curso cursoUnicoAlgo3
	Cursada cursadaAlgoritmos2
	Cursada cursadaAlgoritmos3
	Nota nota2
	Nota nota5
	Nota nota10
	
	@BeforeEach
	def void init() {
		// Definicion de stubs y mocks
		cursoUnicoAlgo2 = mockearCurso(2)
		cursoUnicoAlgo3 = mockearCurso(1)

		nota2 = mockearNota(2)
		nota5 = mockearNota(5)
		nota10 = mockearNota(10)

		cursadaAlgoritmos2 = new Cursada(cursoUnicoAlgo2) => [
			rendirParcial(1, nota2)
			rendirParcial(1, nota5)
			rendirParcial(2, nota10)
		]
		cursadaAlgoritmos3 = new Cursada(cursoUnicoAlgo3) => [
			rendirParcial(1, nota10)
		]

		// ***************************************************
		recibido = new Alumno => [
			cursar(cursadaAlgoritmos2)
			cursar(cursadaAlgoritmos3)
		]
	}

	/**
	 * Test de Stub: estado
	 */
	@Test
	@DisplayName("cada materia que le preguntemos debe tenerla aprobada")
	def void aproboCadaMateria() {
		assertTrue(cursadaAlgoritmos2.aprobo, "El alumno recibido debería tener aprobada Algo2")
		assertTrue(cursadaAlgoritmos3.aprobo, "El alumno recibido debería tener aprobada Algo3")
	}

	@Test
	@DisplayName("debe estar efectivamente recibido")
	def void seRecibio() {
		assertTrue(recibido.seRecibio, "El alumno recibido debería estar recibido")
	}

	/**
	 * Test de Mock: expectativas
	 */
	@Test
	@DisplayName("deben enviarse mensajes a cada nota para verificar si aprobó")
	def void paraSaberSiAproboAlgoritmos2HayQueRevisar3NotasEn1Curso() {
		cursadaAlgoritmos2.aprobo
		verify(cursoUnicoAlgo2, times(1)).cantidadParciales
		verify(nota2, times(1)).aprobo
		verify(nota5, times(1)).aprobo
		verify(nota10, times(1)).aprobo
	}

	@Test
	@DisplayName("-- test que prueba que hay un buen diseño -- la cursada nunca le pregunta a la nota su número, solo pregunta si aprobó")
	def void paraSaberSiAproboAlgoritmos2DelegamosBienEnClaseNota() {
		cursadaAlgoritmos2.aprobo
		#[nota2, nota5, nota10].forEach [ nota |
			verify(nota, never()).nota
			verify(nota, times(1)).aprobo
		]
	}

}
