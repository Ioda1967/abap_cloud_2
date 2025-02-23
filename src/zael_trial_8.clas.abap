CLASS zael_trial_8 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .
  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zael_trial_8 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    DATA : passenger TYPE REF TO lcl_passenger_plane.

    passenger = NEW #( iv_manufacturer = 'BOEING'
                       iv_type         = '737-800'
                       iv_seats        = 140  ).

  ENDMETHOD.
ENDCLASS.
