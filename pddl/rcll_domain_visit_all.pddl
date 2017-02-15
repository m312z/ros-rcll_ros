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
							 (entered-field ?r - robot)
							 (free-location ?l - location)
							 (robot-waiting ?r - robot))
							 ;(greeted ?l - location))
	
	(:durative-action move
					 :parameters (?r - robot ?from - location ?to - machine)
					 :duration (= ?duration 60)
					 :condition (and (at start (entered-field ?r))
													 (at start (at ?r ?from))
													 (at start (free-location ?to)))
					 :effect (and (at start (not (at ?r ?from)))
												(at start (free-location ?from))
												(at start (not (free-location ?to)))
												(at end (at ?r ?to)))
	)

	; (:durative-action mark-visited
	; 				 :parameters (?r - robot ?m - machine)
	; 				 :duration (= ?duration 0)
	; 				 :condition (at start (at ?r ?m))
	; 				 :effect (at end (visited ?m))
	; 				 )
	(:action mark-visited
					 :parameters (?r - robot ?m - machine)
					 :precondition (at ?r ?m)
					 :effect (visited ?m)
					 )

	(:durative-action enter-field
					 :parameters (?r - robot ?team-color - team-color)
					 :duration (= ?duration 10)
					 :condition (and (at start (free-location START))
													 (at start (robot-waiting ?r)))
													 ;(at start (not (entered-field ?r))))
					 ; The following crashes ROSplan
					 ;:effect (and (at start (forall (?l - location) (not (at ?r ?l)))) (at end (at ?r START)))
					 :effect (and (at end (entered-field ?r))
												(at end (at ?r START))
												(at start (not (free-location START)))
												(at end (not (robot-waiting ?r))))
	)

	;(:durative-action hello_world
	;				 :parameters (?l - location)
	;				 :duration (= ?duration 3)
	;				 :effect (at end (greeted ?l))
	;)
)
