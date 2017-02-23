(define (domain rcll-prod-c0)
	(:requirements :strips :typing :durative-actions)

	(:types
		robot - object
		team-color - object
		location - object
		mps - location
		mps-typename - object
		mps-statename - object
		mps-side - object
		base-color - object
		cap-color - object
		ring-color object
		ds-gate - object
		cs-operation - object
		cs-statename - object
		order - object
    order-complexity-value - object
		workpiece - object
		cap-carrier - workpiece
		shelf-spot - object
	)

	(:constants
		START - location
		BS CS DS RS - mps-typename
		IDLE BROKEN PREPARED PROCESSING PROCESSED WAIT-IDLE READY-AT-OUTPUT DOWN - mps-statename
		ANYSIDE INPUT OUTPUT - mps-side
		BASE_NONE BASE_CC BASE_RED BASE_BLACK BASE_SILVER - base-color
		CAP_NONE CAP_BLACK CAP_GREY - cap-color
		GATE-1 GATE-2 GATE-3 - ds-gate
		RING_NONE RING_BLUE RING_GREEN RING_ORANGE RING_YELLOW - ring-color
		CS_RETRIEVE CS_MOUNT - cs-operation
		c0 c1 c2 c3 - order-complexity-value
		LEFT MIDDLE RIGHT - shelf-spot
	)

	(:predicates
		(at ?r - robot ?m - location ?side - mps-side)
		(holding ?r - robot ?wp - workpiece)
		(can-hold ?r - robot)
		(entered-field ?r - robot)
		(location-free ?l - location ?side - mps-side)
		(location-allowed ?l - location)
		(robot-waiting ?r - robot)
		(mps-type ?m - mps ?t - mps-typename)
		(mps-state ?m - mps ?s - mps-statename)
		(bs-prepared-color ?m - mps ?col - base-color)
		(bs-prepared-side ?m - mps ?side - mps-side)
		(rs-ring-spec ?m - mps ?r - ring-color)
		(cs-can-perform ?m - mps ?op - cs-operation)
		(cs-prepared-for ?m - mps ?op - cs-operation)
		(cs-buffered ?m - mps ?col - cap-color)
		(cs-free ?m - mps)
		(prepared ?m - mps)
		(order-complexity ?ord - order ?com - order-complexity-value)
		(order-base-color ?ord - order ?col - base-color)
		(order-ring1-color ?ord - order ?col - ring-color)
		(order-ring2-color ?ord - order ?col - ring-color)
		(order-ring3-color ?ord - order ?col - ring-color)
		(order-cap-color ?ord - order ?col - cap-color)
		(order-fulfilled ?ord - order)
		(order-delivery-begin ?ord - order)
		(order-delivery-end ?ord - order)
		(order-gate ?ord - order ?gate - ds-gate)
		(wp-unused ?wp - workpiece)
		(wp-usable ?wp - workpiece)
		(wp-at ?wp - workpiece ?m - mps ?side - mps-side)
		(wp-base-color ?wp - workpiece ?col - base-color)
		(wp-ring1-color ?wp - workpiece ?col - ring-color)
		(wp-ring2-color ?wp - workpiece ?col - ring-color)
		(wp-ring3-color ?wp - workpiece ?col - ring-color)
		(wp-cap-color ?wp - workpiece ?col - cap-color)
		(wp-on-shelf ?wp - workpiece ?m - mps ?spot - shelf-spot)
	)

	(:action prepare-bs
		:parameters (?m - mps ?side - mps-side ?bc - base-color)
		:precondition (and (mps-type ?m BS) (mps-state ?m IDLE))
		:effect (and (prepared ?m) (not (mps-state ?m IDLE)) (mps-state ?m PROCESSING)
								 (bs-prepared-color ?m ?bc) (bs-prepared-side ?m ?side))
	)

	(:action prepare-ds
		:parameters (?m - mps ?gate - ds-gate)
		:precondition (and (mps-type ?m DS) (mps-state ?m IDLE))
		;:precondition (and (mps-type ?m DS))
		:effect (and (prepared ?m) (not (mps-state ?m IDLE)) (mps-state ?m PREPARED))
	)

	(:action prepare-cs
		:parameters (?m - mps ?op - cs-operation)
		:precondition (and (mps-type ?m CS) (mps-state ?m IDLE) (cs-can-perform ?m ?op))
		:effect (and (prepared ?m) (not (mps-state ?m IDLE)) (mps-state ?m PREPARED)
								 (not (cs-can-perform ?m ?op)) (cs-prepared-for ?m ?op))
	)

	(:action bs-dispense
		:parameters (?m - mps ?side - mps-side ?wp - workpiece ?basecol - base-color)
		:precondition (and (mps-type ?m BS) (mps-state ?m PROCESSING)
											 (bs-prepared-color ?m ?basecol) (bs-prepared-side ?m ?side)
											 (wp-base-color ?wp BASE_NONE) (wp-unused ?wp))
		:effect (and (wp-at ?wp ?m ?side)
								 (not (wp-base-color ?wp BASE_NONE)) (wp-base-color ?wp ?basecol)
								 (not (wp-unused ?wp)) (wp-usable ?wp)
								 (not (mps-state ?m PROCESSING)) (mps-state ?m READY-AT-OUTPUT))
	)
		
	(:durative-action cs-mount-cap
		:parameters (?m - mps ?wp - workpiece ?capcol - cap-color)
		:duration (= ?duration 0)
		:condition (and (at start (mps-type ?m CS)) (at start (mps-state ?m PROCESSING))
										(at start (cs-buffered ?m ?capcol)) (at start (cs-prepared-for ?m CS_MOUNT))
										(at start (wp-usable ?wp)) (at start (wp-at ?wp ?m INPUT))
										(at start (wp-cap-color ?wp CAP_NONE)))
		:effect (and (at start (not (mps-state ?m PROCESSING))) (at end (mps-state ?m READY-AT-OUTPUT))
								 (at start (not (wp-at ?wp ?m INPUT))) (at end (wp-at ?wp ?m OUTPUT))
								 (at start (not (wp-cap-color ?wp CAP_NONE))) (at end (wp-cap-color ?wp ?capcol))
								 (at end (cs-can-perform ?m CS_RETRIEVE)))
	)

	(:durative-action cs-retrieve-cap
		:parameters (?m - mps ?cc - cap-carrier ?capcol - cap-color)
		:duration (= ?duration 0)
		:condition (and (at start (mps-type ?m CS)) (at start (mps-state ?m PROCESSING))
										(at start (cs-prepared-for ?m CS_RETRIEVE))
										(at start (wp-at ?cc ?m INPUT))  (at start (wp-cap-color ?cc ?capcol)))
		:effect (and (at start (not (mps-state ?m PROCESSING))) (at end (mps-state ?m READY-AT-OUTPUT))
								 (at start (not (wp-at ?cc ?m INPUT))) (at end (wp-at ?cc ?m OUTPUT))
								 (at start (not (wp-cap-color ?cc ?capcol))) (at end (wp-cap-color ?cc CAP_NONE))
								 (at end (cs-buffered ?m ?capcol)) (at end (cs-can-perform ?m CS_MOUNT)))
	)

	(:action prepare-rs
		:parameters (?m - mps ?rc - ring-color)
		:precondition (and (mps-type ?m RS) (mps-state ?m IDLE) (rs-ring-spec ?m ?rc))
		:effect (and (prepared ?m) (not (mps-state ?m IDLE)) (mps-state ?m PREPARED))
	)
	
	(:durative-action move
		:parameters (?r - robot ?from - location ?from-side - mps-side ?to - location ?to-side - mps-side)
		:duration (= ?duration 25)
		:condition (and (at start (entered-field ?r))
										(at start (at ?r ?from ?from-side))
										(at start (location-free ?to ?to-side))
										(at start (location-allowed ?to)))
		:effect (and (at start (not (at ?r ?from ?from-side)))
								 (at start (location-free ?from ?from-side))
								 (at start (not (location-free ?to ?to-side)))
								 (at end (at ?r ?to ?to-side)))
	)

	(:durative-action enter-field
		:parameters (?r - robot ?team-color - team-color)
		:duration (= ?duration 10)
		:condition (and (at start (location-free START ANYSIDE))
										(at start (robot-waiting ?r)))
		:effect (and (at end (entered-field ?r))
								 (at end (at ?r START ANYSIDE))
								 (at start (not (location-free START ANYSIDE)))
								 (at end (not (robot-waiting ?r))) (at end (can-hold ?r)))
	)

	(:action wp-discard
		:parameters (?r - robot ?cc - cap-carrier)
		:precondition (and (holding ?r ?cc))
		:effect (and (not (holding ?r ?cc)) (not (wp-usable ?cc)) (can-hold ?r))
	)

	(:durative-action wp-get-shelf
		:parameters (?r - robot ?cc - cap-carrier ?m - mps ?spot - shelf-spot)
	 	:duration (= ?duration 30)
		:condition (and (at start (at ?r ?m INPUT)) (at start (wp-on-shelf ?cc ?m ?spot)) (at start (can-hold ?r)))
		:effect (and (at end (holding ?r ?cc)) (at start (not (can-hold ?r)))
								 (at start (not (wp-on-shelf ?cc ?m ?spot))) (at end (wp-usable ?cc)))
	)

	(:durative-action wp-get
		:parameters (?r - robot ?wp - workpiece ?m - mps ?side - mps-side)
		:duration (= ?duration 30)
		:condition (and (at start (at ?r ?m ?side)) (at start (can-hold ?r)) (at start (wp-at ?wp ?m ?side))
										(at start (mps-state ?m READY-AT-OUTPUT)) (at start (wp-usable ?wp)))
		:effect (and (at end (not (wp-at ?wp ?m ?side))) (at end (holding ?r ?wp)) (at start (not (can-hold ?r)))
								 (at start (not (mps-state ?m READY-AT-OUTPUT))) (at end (mps-state ?m IDLE)))
	)

	(:durative-action wp-put
		:parameters (?r - robot ?wp - workpiece ?m - mps)
		:duration (= ?duration 30)
		:condition (and (at start (at ?r ?m INPUT)) (at start (mps-state ?m PREPARED))
										(at start (wp-usable ?wp)) (at start (holding ?r ?wp)))
		:effect (and (at end (wp-at ?wp ?m INPUT)) (at start (not (holding ?r ?wp))) (at end (can-hold ?r))
								 (at start (not (mps-state ?m PREPARED))) (at end (mps-state ?m PROCESSING)))
	)

	; (:durative-action mps-process
	; 	:parameters (?m - mps)
	; 	:duration (= ?duration 10)
	; 	:condition (and (at start (mps-state ?m PROCESSING)))
	; 	:effect (and (at start (not (mps-state ?m PROCESSING))) (at end (mps-state ?m READY-AT-OUTPUT)))
	; )

	(:action fulfill-order-c0
		:parameters (?ord - order ?wp - workpiece ?m - mps ?basecol - base-color ?capcol - cap-color)
		:precondition (and (wp-at ?wp ?m INPUT) (wp-usable ?wp)
											 (mps-type ?m DS) (mps-state ?m PROCESSING)
											 (order-complexity ?ord c0)
											 (order-base-color ?ord ?basecol) (wp-base-color ?wp ?basecol)
											 (order-cap-color ?ord ?capcol) (wp-cap-color ?wp ?capcol)
											 )
		:effect (and (order-fulfilled ?ord) (not (wp-at ?wp ?m INPUT))
								 (not (wp-base-color ?wp ?basecol)) (not (wp-cap-color ?wp ?capcol)))
								 
	)
)
