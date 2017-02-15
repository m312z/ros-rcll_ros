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
							 (visited ?m - machine)
							 (entered-field ?r - robot))
							 ;(greeted ?l - location))
	
	(:durative-action move
					 :parameters (?r - robot ?from - location ?to - machine)
					 :duration (= ?duration 60)
					 :condition (at start (and (at ?r ?from) (entered-field ?r)))
					 :effect (and (at start (not (at ?r ?from))) (at end (at ?r ?to)))
					 )

	(:action mark-visited
					 :parameters (?r - robot ?m - machine)
					 :precondition (at ?r ?m)
					 :effect (visited ?m)
					 )

	(:durative-action enter-field
					 :parameters (?r - robot ?team-color - team-color)
					 :duration (= ?duration 10)
					 ; The following crashes ROSplan
					 ;:effect (and (at start (forall (?l - location) (not (at ?r ?l)))) (at end (at ?r START)))
					 :effect (at end (entered-field ?r))
	)

	;(:durative-action hello_world
	;				 :parameters (?l - location)
	;				 :duration (= ?duration 3)
	;				 :effect (at end (greeted ?l))
	;)
)
