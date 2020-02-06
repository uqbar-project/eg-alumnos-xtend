package ar.edu.alumnosMockito

class StubCurso implements Curso {
	override getCantidadParciales() { 1 }
}

class StubNotaSiete implements Nota {
	
	override aprobo() { true }
	override getNota() { 7 }
	
}
