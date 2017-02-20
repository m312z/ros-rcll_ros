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
					cs-operation - object
					cs-statename - object)

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
	 (cs-can-perform ?m - mps ?op - cs-operation)
	 (cs-has-performed ?m - mps ?op - cs-operation)
	 (prepared ?m - mps)
	)
	
	(:action prepare-bs
		:parameters (?m - mps ?side - mps-side ?bc - base-color)
		:precondition (and (mps-type ?m BS) (mps-state ?m IDLE))
		:effect (and (prepared ?m) (mps-state ?m READY-AT-OUTPUT))
	)

	(:action prepare-ds
		:parameters (?m - mps ?gate - ds-gate)
		:precondition (and (mps-type ?m DS) (mps-state ?m IDLE))
		;:precondition (and (mps-type ?m DS))
		:effect (and (prepared ?m) (mps-state ?m PREPARED))
	)

	; (:action prepare-cs
	; 	:parameters (?m - mps ?op - cs-operation)
	; 	:precondition (and (mps-type ?m CS) (mps-state ?m IDLE))
	; 	;:precondition (and (mps-type ?m CS))
	; 	:effect (and (prepared ?m) (mps-state ?m PREPARED))
		;:precondition (and (mps-type ?m CS))
								 ;(when (cs-can-perform ?m CS_RETRIEVE)
								;	 (and (not (cs-can-perform ?m CS_RETRIEVE)) (cs-can-perform ?m CS_MOUNT)))
								 ;(when (cs-can-perform ?m CS_MOUNT)
								;	 (and (not (cs-can-perform ?m CS_MOUNT)) (cs-can-perform ?m CS_RETRIEVE))))
	; )
	(:action prepare-cs
		:parameters (?m - mps ?op - cs-operation)
		:precondition (and (mps-type ?m CS) (mps-state ?m IDLE) (cs-can-perform ?m ?op))
		:effect (and (prepared ?m) (mps-state ?m PREPARED) (not (cs-can-perform ?m ?op)) (cs-has-performed ?m ?op))
	)

  ; The following two actions are to mark the state of the machine without
  ; conditional effects (just to please POPF)
	(:action cs-modeswap-retrieved
		:parameters (?m - mps)
		:precondition (cs-has-performed ?m CS_RETRIEVE)
		:effect (and (not (cs-has-performed ?m CS_RETRIEVE)) (cs-can-perform ?m CS_MOUNT))
	)

	(:action cs-modeswap-mounted
		:parameters (?m - mps)
		:precondition (cs-has-performed ?m CS_MOUNT)
		:effect (and (not (cs-has-performed ?m CS_MOUNT)) (cs-can-perform ?m CS_RETRIEVE))
	)

	(:action prepare-rs
		:parameters (?m - mps ?rc - ring-color)
		:precondition (and (mps-type ?m RS) (mps-state ?m IDLE) (rs-ring-spec ?m ?rc))
		;:precondition (and (mps-type ?m RS) (rs-ring-spec ?m ?rc))
		:effect (and (prepared ?m) (mps-state ?m PREPARED))
	)
)
