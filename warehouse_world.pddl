(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )
   (:action robotMove
      :parameters (?l_from - location ?l_to - location ?r - robot)
      :precondition (and (at ?r ?l_from) (no-robot ?l_to) (connected ?l_from ?l_to))
      :effect (and (at ?r ?l_to) (no-robot ?l_from) (not (at ?r ?l_from)) (not (no-robot ?l_to)))
   )
   (:action robotMoveWithPallette
      :parameters (?l_from - location ?l_to - location ?r - robot ?p - pallette)
      :precondition (and (at ?r ?l_from) (no-robot ?l_to) (connected ?l_from ?l_to) (at ?p ?l_from) (no-pallette ?l_to))
      :effect (and (at ?r ?l_to) (no-robot ?l_from) (not (at ?r ?l_from)) (not (no-robot ?l_to)) (at ?p ?l_to) 
      (not (at ?p ?l_from)) (not (no-pallette ?l_to)) (no-pallette ?l_from))
   )
   (:action moveItemFromPalletteToShipment
      :parameters (?l - location ?p - pallette ?s - shipment ?o - order ?si - saleitem)
      :precondition (and (at ?p ?l) (packing-at ?s ?l) (contains ?p ?si) (started ?s) 
      (not (complete ?s)) (ships ?s ?o) (orders ?o ?si))
      :effect (and (includes ?s ?si) (not (contains ?p ?si)))
   )
   (:action completeShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (started ?s) (not (complete ?s)) (ships ?s ?o) (packing-at ?s ?l))
      :effect (and (complete ?s) (not (started ?s)) (available ?l))
   )

)
