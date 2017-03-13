;****************************************************************************
;  rcll_domain_production.pddl: RoboCup Logistics League Production Model
;
;  Created: Fri Feb 24 23:20:38 2017
;  Copyright  2017  Tim Niemueller [www.niemueller.de]
;****************************************************************************

;  This program is free software; you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation; either version 2 of the License, or
;  (at your option) any later version.
;
;  This program is distributed in the hope that it will be useful,
;  but WITHOUT ANY WARRANTY; without even the implied warranty of
;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;  GNU Library General Public License for more details.
;
;  Read the full text in the LICENSE.GPL file in the doc directory.

(define (domain rcll-production)
	(:requirements :strips :typing :durative-actions :numeric-fluents)

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
		ring-color - object
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
		INPUT OUTPUT - mps-side
		BASE_NONE BASE_RED BASE_BLACK BASE_SILVER - base-color
		CAP_NONE CAP_BLACK CAP_GREY - cap-color
		GATE-1 GATE-2 GATE-3 - ds-gate
		RING_NONE RING_BLUE RING_GREEN RING_ORANGE RING_YELLOW - ring-color
		CS_RETRIEVE CS_MOUNT - cs-operation
		C0 C1 C2 C3 - order-complexity-value
		LEFT MIDDLE RIGHT - shelf-spot
	)

	(:functions
	 (path-length ?from - location ?from-side - mps-side ?to - location ?to-side - mps-side)
	)

	(:predicates
		(at ?r - robot ?m - location ?side - mps-side)
		(holding ?r - robot ?wp - workpiece)
		(can-hold ?r - robot)
		(entered-field ?r - robot)
		(location-free ?l - location ?side - mps-side)
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
		(rs-prepared-color ?m - mps ?col - ring-color)
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
		:effect (and (not (mps-state ?m IDLE)) (mps-state ?m PROCESSING)
								 (bs-prepared-color ?m ?bc) (bs-prepared-side ?m ?side))
	)

	(:action prepare-ds
		:parameters (?m - mps ?gate - ds-gate)
		:precondition (and (mps-type ?m DS) (mps-state ?m IDLE))
		:effect (and (not (mps-state ?m IDLE)) (mps-state ?m PREPARED))
	)

	(:action prepare-cs
		:parameters (?m - mps ?op - cs-operation)
		:precondition (and (mps-type ?m CS) (mps-state ?m IDLE) (cs-can-perform ?m ?op))
		:effect (and (not (mps-state ?m IDLE)) (mps-state ?m PREPARED)
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
								 (at end (not (wp-cap-color ?wp CAP_NONE))) (at end (wp-cap-color ?wp ?capcol))
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
		:effect (and (not (mps-state ?m IDLE)) (mps-state ?m PREPARED)
								 (rs-prepared-color ?m ?rc))
	)

	(:durative-action rs-mount-ring1
		:parameters (?m - mps ?wp - workpiece ?col - ring-color)
		:duration (= ?duration 0)				 
		:condition (and (at start (mps-type ?m RS)) (at start (mps-state ?m PROCESSING))
										(at start (wp-at ?wp ?m INPUT)) (at start (wp-usable ?wp))
										(at start (wp-ring1-color ?wp RING_NONE))
										(at start (wp-cap-color ?wp CAP_NONE))
										(at start (rs-prepared-color ?m ?col)))
		:effect (and (at end (not (mps-state ?m PROCESSING))) (at end (mps-state ?m READY-AT-OUTPUT))
								 (at end (not (rs-prepared-color ?m ?col)))
								 (at start (not (wp-at ?wp ?m INPUT))) (at end (wp-at ?wp ?m OUTPUT))
								 (at end (not (wp-ring1-color ?wp RING_NONE))) (at end (wp-ring1-color ?wp ?col)))
	)

	(:durative-action rs-mount-ring2
		:parameters (?m - mps ?wp - workpiece ?col - ring-color)
		:duration (= ?duration 0)				 
		:condition (and (at start (mps-type ?m RS)) (at start (mps-state ?m PROCESSING))
										(at start (wp-at ?wp ?m INPUT)) (at start (wp-usable ?wp))
										(at start (wp-ring2-color ?wp RING_NONE))
										(at start (wp-cap-color ?wp CAP_NONE))
										(at start (rs-prepared-color ?m ?col)))
		:effect (and (at end (not (mps-state ?m PROCESSING))) (at end (mps-state ?m READY-AT-OUTPUT))
								 (at end (not (rs-prepared-color ?m ?col)))
								 (at start (not (wp-at ?wp ?m INPUT))) (at end (wp-at ?wp ?m OUTPUT))
								 (at end (not (wp-ring2-color ?wp RING_NONE))) (at end (wp-ring2-color ?wp ?col)))
	)

	(:durative-action rs-mount-ring3
		:parameters (?m - mps ?wp - workpiece ?col - ring-color)
		:duration (= ?duration 0)				 
		:condition (and (at start (mps-type ?m RS)) (at start (mps-state ?m PROCESSING))
										(at start (wp-at ?wp ?m INPUT)) (at start (wp-usable ?wp))
										(at start (wp-ring3-color ?wp RING_NONE))
										(at start (wp-cap-color ?wp CAP_NONE))
										(at start (rs-prepared-color ?m ?col)))
		:effect (and (at end (not (mps-state ?m PROCESSING))) (at end (mps-state ?m READY-AT-OUTPUT))
								 (at end (not (rs-prepared-color ?m ?col)))
								 (at start (not (wp-at ?wp ?m INPUT))) (at end (wp-at ?wp ?m OUTPUT))
								 (at end (not (wp-ring3-color ?wp RING_NONE))) (at end (wp-ring3-color ?wp ?col)))
	)

	; The following is the generic move version.
	; It takes the robot from any location (at any side) to any MPS (any side).
	; However, this also creates a tremendous number of options during search and
	; hence is detrimental for planning performance.
	;
	; (:durative-action move
	; 	:parameters (?r - robot ?from - location ?from-side - mps-side ?to - mps ?to-side - mps-side)
	; 	:duration (= ?duration 0)
	; 	:condition (and (at start (entered-field ?r))
	; 									(at start (at ?r ?from ?from-side))
	; 									(at start (location-free ?to ?to-side)))
	; 	:effect (and (at start (not (at ?r ?from ?from-side)))
	; 							 (at start (location-free ?from ?from-side))
	; 							 (at start (not (location-free ?to ?to-side)))
	; 							 (at end (at ?r ?to ?to-side)))
	; )

	; Move actions specific for the expected follow-up action.
	; This models the move in two versions specific to the expected next action,
	; either the retrieval or the delivery of a workpiece. While a more generic
	; such as the one would be desirable, in typical test cases these specific
	; actions cut the planning time by about 95%.
	(:durative-action move-wp-put
		:parameters (?r - robot ?from - location ?from-side - mps-side ?to - mps)
		:duration (= ?duration (path-length ?from ?from-side ?to INPUT))
		:condition (and (at start (entered-field ?r))
										(at start (at ?r ?from ?from-side))
										(at start (location-free ?to INPUT))
										(at start (mps-state ?to PREPARED)))
		:effect (and (at start (not (at ?r ?from ?from-side)))
								 (at start (location-free ?from ?from-side))
								 (at start (not (location-free ?to INPUT)))
								 (at end (at ?r ?to INPUT)))
	)

	(:durative-action move-wp-get
		:parameters (?r - robot ?from - location ?from-side - mps-side ?to - mps ?to-side - mps-side)
		:duration (= ?duration (path-length ?from ?from-side ?to ?to-side))
		:condition (and (at start (entered-field ?r))
										(at start (at ?r ?from ?from-side))
										(at start (location-free ?to ?to-side))
										(at start (mps-state ?to READY-AT-OUTPUT))
										(at start (can-hold ?r)))
		:effect (and (at start (not (at ?r ?from ?from-side)))
								 (at start (location-free ?from ?from-side))
								 (at start (not (location-free ?to ?to-side)))
								 (at end (at ?r ?to ?to-side)))
	)

	(:durative-action enter-field
		:parameters (?r - robot ?team-color - team-color)
		:duration (= ?duration 10)
		:condition (and (at start (location-free START INPUT))
										(at start (robot-waiting ?r)))
		:effect (and (at end (entered-field ?r))
								 (at end (at ?r START INPUT))
								 (at start (not (location-free START INPUT)))
								 (at end (not (robot-waiting ?r))) (at end (can-hold ?r)))
	)

	(:action wp-discard
		:parameters (?r - robot ?cc - cap-carrier)
		:precondition (and (holding ?r ?cc))
		:effect (and (not (holding ?r ?cc)) (not (wp-usable ?cc)) (can-hold ?r))
	)

	(:durative-action wp-get-shelf
		:parameters (?r - robot ?cc - cap-carrier ?m - mps ?spot - shelf-spot)
	 	:duration (= ?duration 20)
		:condition (and (at start (at ?r ?m INPUT)) (at start (wp-on-shelf ?cc ?m ?spot)) (at start (can-hold ?r)))
		:effect (and (at end (holding ?r ?cc)) (at start (not (can-hold ?r)))
								 (at start (not (wp-on-shelf ?cc ?m ?spot))) (at end (wp-usable ?cc)))
	)

	(:durative-action wp-get
		:parameters (?r - robot ?wp - workpiece ?m - mps ?side - mps-side)
		:duration (= ?duration 10)
		:condition (and (at start (at ?r ?m ?side)) (at start (can-hold ?r)) (at start (wp-at ?wp ?m ?side))
										(at start (mps-state ?m READY-AT-OUTPUT)) (at start (wp-usable ?wp)))
		:effect (and (at end (not (wp-at ?wp ?m ?side))) (at end (holding ?r ?wp)) (at start (not (can-hold ?r)))
								 (at start (not (mps-state ?m READY-AT-OUTPUT))) (at end (mps-state ?m IDLE)))
	)

	(:durative-action wp-put
		:parameters (?r - robot ?wp - workpiece ?m - mps)
		:duration (= ?duration 10)
		:condition (and (at start (at ?r ?m INPUT)) (at start (mps-state ?m PREPARED))
										(at start (wp-usable ?wp)) (at start (holding ?r ?wp)))
		:effect (and (at end (wp-at ?wp ?m INPUT)) (at start (not (holding ?r ?wp))) (at end (can-hold ?r))
								 (at start (not (mps-state ?m PREPARED))) (at end (mps-state ?m PROCESSING)))
	)

	(:action fulfill-order-c0
		:parameters (?ord - order ?wp - workpiece ?m - mps
		             ?basecol - base-color ?capcol - cap-color)
		:precondition (and (wp-at ?wp ?m INPUT) (wp-usable ?wp)
											 (mps-state ?m PROCESSING)
											 (order-complexity ?ord C0)
											 (order-base-color ?ord ?basecol) (wp-base-color ?wp ?basecol)
											 (order-cap-color ?ord ?capcol) (wp-cap-color ?wp ?capcol)
											 (wp-ring1-color ?wp RING_NONE) (wp-ring2-color ?wp RING_NONE) (wp-ring3-color ?wp RING_NONE))
		:effect (and (order-fulfilled ?ord) (not (wp-at ?wp ?m INPUT))
								 (not (wp-base-color ?wp ?basecol)) (not (wp-cap-color ?wp ?capcol)))
								 
	)

	(:action fulfill-order-c1
		:parameters (?ord - order ?wp - workpiece ?m - mps
		             ?basecol - base-color ?capcol - cap-color
		             ?ring1col - ring-color)

		:precondition (and (wp-at ?wp ?m INPUT) (wp-usable ?wp)
											 (mps-type ?m DS) (mps-state ?m PROCESSING)
											 (order-complexity ?ord C1)
											 (order-base-color ?ord ?basecol) (wp-base-color ?wp ?basecol)
											 (order-ring1-color ?ord ?ring1col) (wp-ring1-color ?wp ?ring1col)
											 (order-cap-color ?ord ?capcol) (wp-cap-color ?wp ?capcol))
		:effect (and (order-fulfilled ?ord) (not (wp-at ?wp ?m INPUT))
								 (not (wp-base-color ?wp ?basecol)) (not (wp-cap-color ?wp ?capcol)))
	)

	(:action fulfill-order-c2
		:parameters (?ord - order ?wp - workpiece ?m - mps
		             ?basecol - base-color ?capcol - cap-color
		             ?ring1col - ring-color ?ring2col - ring-color)

		:precondition (and (wp-at ?wp ?m INPUT) (wp-usable ?wp)
											 (mps-type ?m DS) (mps-state ?m PROCESSING)
											 (order-complexity ?ord C2)
											 (order-base-color ?ord ?basecol) (wp-base-color ?wp ?basecol)
											 (order-ring1-color ?ord ?ring1col) (wp-ring1-color ?wp ?ring1col)
											 (order-ring2-color ?ord ?ring2col) (wp-ring2-color ?wp ?ring2col)
											 (wp-ring3-color ?wp RING_NONE)
											 (order-cap-color ?ord ?capcol) (wp-cap-color ?wp ?capcol))
		:effect (and (order-fulfilled ?ord) (not (wp-at ?wp ?m INPUT))
								 (not (wp-base-color ?wp ?basecol)) (not (wp-cap-color ?wp ?capcol)))
								 
	)

	(:action fulfill-order-c3
		:parameters (?ord - order ?wp - workpiece ?m - mps
		             ?basecol - base-color ?capcol - cap-color
		             ?ring1col - ring-color ?ring2col - ring-color ?ring3col - ring-color)

		:precondition (and (wp-at ?wp ?m INPUT) (wp-usable ?wp)
											 (mps-type ?m DS) (mps-state ?m PROCESSING)
											 (order-complexity ?ord C3)
											 (order-base-color ?ord ?basecol) (wp-base-color ?wp ?basecol)
											 (order-ring1-color ?ord ?ring1col) (wp-ring1-color ?wp ?ring1col)
											 (order-ring2-color ?ord ?ring2col) (wp-ring2-color ?wp ?ring2col)
											 (order-ring3-color ?ord ?ring3col) (wp-ring3-color ?wp ?ring3col)
											 (order-cap-color ?ord ?capcol) (wp-cap-color ?wp ?capcol)
											 )
		:effect (and (order-fulfilled ?ord) (not (wp-at ?wp ?m INPUT))
								 (not (wp-base-color ?wp ?basecol)) (not (wp-cap-color ?wp ?capcol)))
	)
)
