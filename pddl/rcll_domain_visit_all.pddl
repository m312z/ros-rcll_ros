(define (domain rcll-visit)
	(:requirements :strips :typing :durative-actions)

	(:types location - object
					machine - location
					robot - object
					team-color - object)

  (:constants START - location)
	;						CYAN - team-color
	;						MAGENTA - team-color
	;						)

	(:predicates (at ?r - robot ?m - location)
							 (visited ?m - machine))
	(:durative-action move
					 :parameters (?r - robot ?from - location ?to - machine)
					 :duration ( = ?duration 60)
					 :condition (at start (at ?r ?from))
					 :effect (and (at start (not (at ?r ?from))) (at end (at ?r ?to)) (at end (visited ?to)))
	)
)
