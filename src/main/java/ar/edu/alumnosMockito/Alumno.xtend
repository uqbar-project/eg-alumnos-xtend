package ar.edu.alumnosMockito

import java.util.List
import java.util.Map

class Alumno {
	String nombre
	List<Cursada> cursadas = newArrayList
	
	new(String _nombre) {
		nombre = _nombre
	}
	
	def boolean seRecibio() {
		cursadas.forall [ cursada | cursada.aprobo ]	
	}

	def cursar(Cursada cursada) {
		cursadas.add(cursada)
	}		
}

class Cursada {
	Map<Integer, List<Nota>> notas = newHashMap
	Curso curso

	new(Curso _curso) {
		curso = _curso
	}
	
	def List<Nota> getNotasDeParcial(Integer numeroParcial) {
		notas.get(numeroParcial) ?: newArrayList
	}
	
	def rendirParcial(Integer numeroParcial, Nota nota) {
		var List<Nota> notasAux = getNotasDeParcial(numeroParcial)
		notasAux.add(nota)
		notas.put(numeroParcial, notasAux)
	}

	def boolean aprobo() {
		(1..curso.cantidadParciales).forall [ i |
			getNotasDeParcial(i).exists [ nota | nota.aprobo ]
		]
	}		
	
}

// TODO
interface Curso {
	def int getCantidadParciales()
}

// TODO
interface Nota {
	
	def boolean aprobo()
	def int getNota()
	
}

