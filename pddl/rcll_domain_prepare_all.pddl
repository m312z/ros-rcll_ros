(define (domain rcll-prepare)
	(:requirements :strips :typing)

	(:types mps - object
					mps-typename - object
					mps-statename - object
					mps-side - object
					base-color - object
					cap-color - object
					ring-color object
					ds-gate - object
					cs-operation - object)

  (:constants
	 BS - mps-typename
	 CS - mps-typename
	 DS - mps-typename
	 RS - mps-typename
	 IDLE - mps-statename
	 BROKEN - mps-statename
	 PREPARED - mps-statename
	 PROCESSING - mps-statename
	 PROCESSED - mps-statename
	 READY-AT-OUTPUT - mps-statename
	 WAIT-IDLE - mps-statename
	 DOWN - mps-statename
	 INPUT - mps-side
	 OUTPUT - mps-side
	 BASE_RED - base-color
	 BASE_BLACK - base-color
	 BASE_SILVER - base-color
	 CAP_BLACK - cap-color
	 CAP_GREY - cap-color
	 GATE-1 - ds-gate
	 GATE-2 - ds-gate
	 GATE-3 - ds-gate
	 RING_BLUE - ring-color
	 RING_GREEN - ring-color
	 RING_ORANGE - ring-color
	 RING_YELLOW - ring-color
	 CS_RETRIEVE - cs-operation
	 CS_MOUNT - cs-operation
	)

	(:predicates
	 (mps-type ?m - mps ?t - mps-typename)
	 (mps-state ?m - mps ?s - mps-statename)
	 (rs-ring-spec ?m - mps ?r - ring-color)
	 (prepared ?m - mps)
	)
	
	(:action prepare-bs
					 :parameters (?m - mps ?side - mps-side ?bc - base-color)
					 ;:precondition (and (mps-type ?m BS) (mps-state ?m IDLE))
					 :precondition (and (mps-type ?m BS))
					 :effect (prepared ?m)
	)

	(:action prepare-ds
					 :parameters (?m - mps ?gate - ds-gate)
					 ;:precondition (and (mps-type ?m DS) (mps-state ?m IDLE))
					 :precondition (and (mps-type ?m DS))
					 :effect (prepared ?m)
	)

	(:action prepare-cs
					 :parameters (?m - mps ?op - cs-operation)
					 ;:precondition (and (mps-type ?m CS) (mps-state ?m IDLE))
					 :precondition (and (mps-type ?m CS))
					 :effect (prepared ?m)
	)

	(:action prepare-rs
					 :parameters (?m - mps ?rc - ring-color)
					 ;:precondition (and (mps-type ?m RS) (mps-state ?m IDLE))
					 :precondition (and (mps-type ?m RS) (rs-ring-spec ?m ?rc))
					 :effect (prepared ?m)
	)
)
