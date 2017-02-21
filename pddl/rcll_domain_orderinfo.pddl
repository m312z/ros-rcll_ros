(define (domain RCLL)
    (:requirements :typing :durative-actions)
    (:types
      Order - object
      OrderComplexityValue - object
      Color - object
    )
    (:constants
	RING_BLUE RING_GREEN RING_ORANGE RING_YELLOW BASE_RED BASE_BLACK BASE_SILVER CAP_BLACK CAP_GREY - Color
	c0 c1 c2 c3 - OrderComplexity
    )
    (:predicates   	
      (orderComplexity ?ord - Order ?com - OrderComplexityValue)
      (orderBaseColor ?ord - Order ?col - Color)
      (orderRing1Color ?ord - Order ?col - Color)
      (orderRing2Color ?ord - Order ?col - Color)
      (orderRing3Color ?ord - Order ?col - Color)
      (orderCapColor ?ord - Order ?col - Color)
      (orderFilled ?ord - Order)
    )
    (:action fillOrder
     :parameters (?ord - Order)
     :predcondition 
       (and
       )
     :effect
       (and 
		(orderFilled ?ord)
	)
    )


