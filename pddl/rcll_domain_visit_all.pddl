(define (domain rcll-visit)
	(:requirements :adl :strips :typing)

	(:types location - object
					machine - location
					robot - object)
	(:predicates (at ?r - robot ?m - location)
							 (visited ?m - machine))
	(:action move
					 :parameters (?r - robot ?from - location ?to - machine)
					 :precondition (at ?r ?from)
					 :effect (and (not (at ?r ?from)) (at ?r ?to) (visited ?to))
	)
)
