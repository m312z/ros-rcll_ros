(define (problem rcll-prod-c0-prob1)
	(:domain rcll-prod-c0)

	(:objects
		R-1 - robot
		o1 - order
		wp1 - workpiece
		cc1 cc2 cc3 - cap-carrier
		C-BS C-CS1 C-CS2 C-DS C-RS1 C-RS2 - mps
		CYAN - team-color
	)
	 
	(:init
	 (mps-type C-BS BS)
	 (mps-type C-CS1 CS)
	 (mps-type C-CS1 CS)
	 (mps-type C-DS DS)
	 (mps-type C-RS1 RS)
	 (mps-type C-RS2 RS)
	 (location-free START ANYSIDE)
	 (location-free C-BS INPUT)
	 (location-free C-BS OUTPUT)
	 (location-free C-CS1 INPUT)
	 (location-free C-CS1 OUTPUT)
	 (location-free C-CS2 INPUT)
	 (location-free C-CS2 OUTPUT)
	 (location-free C-DS INPUT)
	 (location-free C-DS OUTPUT)
	 ;(location-free C-RS1 INPUT)
	 ;(location-free C-RS1 OUTPUT)
	 ;(location-free C-RS2 INPUT)
	 ;(location-free C-RS2 OUTPUT)
	 (location-allowed C-BS)
	 (location-allowed C-CS1)
	 (location-allowed C-CS2)
	 (location-allowed C-DS)
	 ;(location-allowed C-RS1)
	 ;(location-allowed C-RS2)
	 (order-complexity o1 c0)
	 (order-base-color o1 BASE_RED)
	 (order-cap-color o1 CAP_GREY)
	 (cs-can-perform C-CS1 CS_RETRIEVE)
	 (cs-can-perform C-CS2 CS_RETRIEVE)
	 (cs-free C-CS1)
	 (cs-free C-CS2)
	 (wp-base-color wp1 BASE_NONE)
	 (wp-cap-color wp1 CAP_NONE)
	 (wp-ring1-color wp1 RING_NONE)
	 (wp-ring2-color wp1 RING_NONE)
	 (wp-ring3-color wp1 RING_NONE)
	 (wp-unused wp1)
	 (robot-waiting R-1)
	 (mps-state C-BS IDLE)
 	 (mps-state C-CS1 IDLE)
 	 (mps-state C-CS2 IDLE)
	 (mps-state C-DS IDLE)
 	 (mps-state C-RS1 IDLE)
 	 (mps-state C-RS2 IDLE)

	 (wp-base-color cc1 BASE_CC)
	 (wp-cap-color cc1 CAP_GREY)
	 (wp-on-shelf cc1 C-CS1 LEFT)

	 ;(rs-ring-spec C-RS1 RING_GREEN)
	 ;(rs-ring-spec C-RS1 RING_YELLOW)
	 ;(rs-ring-spec C-RS2 RING_BLUE)
	 ;(rs-ring-spec C-RS2 RING_ORANGE)

	 ;(mps-state C-RS1 PROCESSING)
	 ;(cs-prepared-for C-RS1 CS_RETRIEVE)
	 
	 ;(holding R-1 cc1)

	 ;(cs-buffered C-CS1 CAP_BLACK)

	 ; Only need to fulfill
	 ;(wp-at wp1 C-DS INPUT)
	 ;(wp-base-color wp1 BASE_RED)
	 ;(wp-cap-color wp1 CAP_BLACK)

	 ; Robot is holding wp1 at CS1 and has prepared DS
	 ;(at R-1 C-CS1 INPUT)
	 ;(holding R-1 wp1)
	 ;(wp-at wp1 C-BS INPUT)
	 ;(mps-state C-BS PREPARED)
	 ;(bs-prepared-color C-BS BASE_RED)
	 ;(bs-prepared-side C-BS INPUT)
	 ;(mps-state C-DS PREPARED)
	 ;(wp-base-color wp1 BASE_RED)
	 ;(wp-cap-color wp1 CAP_BLACK)

	 ; wp1 is still on C-CS1
	 ;(wp-at wp1 C-CS1 OUTPUT)
	 ;(at R-1 C-CS1)
	 ;(mps-state C-CS1 READY-AT-OUTPUT)
	 ;(mps-state C-DS IDLE)
	 ;(wp-base-color wp1 BASE_RED)
	 ;(wp-cap-color wp1 CAP_BLACK)
	)

	(:goal (order-fulfilled o1) )
	;(:goal (wp-at cc1 C-CS1 OUTPUT) )
	;(:goal (and (cs-buffered C-CS1 CAP_BLACK) (mps-state C-CS1 IDLE)))
	;(:goal (and (wp-base-color wp1 BASE_RED) (wp-cap-color wp1 CAP_BLACK)))
	;(:goal (holding R-1 cc1))
	;(:goal (wp-base-color wp1 BASE_RED))
)
