CLASS z_ael67_4_tables_complex DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z_AEL67_4_TABLES_COMPLEX IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    TYPES: BEGIN OF st_connection,
             carrier_id      TYPE /dmo/carrier_id,
             connection_id   TYPE /dmo/connection_id,
             airport_from_id TYPE /dmo/airport_from_id,
             airport_to_id   TYPE /dmo/airport_to_id,
             carrier_name    TYPE /dmo/carrier_name,
           END OF st_connection.


* Example 1 : Simple and Complex Internal Table
**********************************************************************

    " simple table (scalar row type)
    DATA numbers TYPE TABLE OF i.
    " complex table (structured row type)
    DATA connections TYPE TABLE OF st_connection.

    out->write(  '--------------------------------------------' ).
    out->write(  'Example 1: Simple and Complex Internal Table' ).
    out->write( data = numbers
                name = 'Simple Table NUMBERS:' ).
    out->write( data = connections
                name = 'Complex Table CONNECTIONS:' ).

* Example 2 : Complex Internal Tables
**********************************************************************

    " standard table with non-unique standard key (short form)
    DATA connections_1 TYPE TABLE OF st_connection.

    " standard table with non-unique standard key (explicit form)
    DATA connections_2 TYPE STANDARD TABLE OF st_connection
                            WITH NON-UNIQUE DEFAULT KEY.

    " sorted table with non-unique explicit key
    DATA connections_3  TYPE SORTED TABLE OF st_connection
                             WITH NON-UNIQUE KEY airport_from_id
                                                 airport_to_id.

    " sorted hashed with unique explicit key
    DATA connections_4  TYPE HASHED TABLE OF st_connection
                             WITH UNIQUE KEY carrier_id
                                             connection_id.

* Example 3 : Local Table Type
**********************************************************************

    TYPES tt_connections TYPE SORTED TABLE OF st_connection
                              WITH UNIQUE KEY carrier_id
                                              connection_id.

    DATA connections_5 TYPE tt_connections.

* Example 4 : Global Table Type
**********************************************************************

    DATA flights  TYPE /dmo/t_flight.

    out->write(  `------------------------------------------` ).
    out->write(  `Example 4: Global Table TYpe /DMO/T_FLIGHT` ).
    out->write(  data = flights
                 name = `Internal Table FLIGHTS:` ).





    TYPES tt_connections2 TYPE STANDARD TABLE OF   st_connection
                              WITH NON-UNIQUE KEY carrier_id
                                                  connection_id.

    DATA connections2 TYPE tt_connections2.

    TYPES: BEGIN OF st_carrier,
             carrier_id    TYPE /dmo/carrier_id,
             carrier_name  TYPE /dmo/carrier_name,
             currency_code TYPE /dmo/currency_code,
           END OF st_carrier.

    TYPES tt_carriers TYPE STANDARD TABLE OF st_carrier
                          WITH NON-UNIQUE KEY carrier_id.

    DATA carriers TYPE tt_carriers.

* Example 1: APPEND with structured data object (work area)
**********************************************************************

*    DATA connection  TYPE st_connection.
    " Declare the work area with LIKE LINE OF
    DATA connection LIKE LINE OF connections2.


*    connection-carrier_id       = 'NN'.
*    connection-connection_id    = '1234'.
*    connection-airport_from_id  = 'ABC'.
*    connection-airport_to_id    = 'XYZ'.
*    connection-carrier_name     = 'My Airline'.

    " Use VALUE #( ) instead assignment to individual components
    connection = VALUE #( carrier_id       = 'NN'
                          connection_id    = '1234'
                          airport_from_id  = 'ABC'
                          airport_to_id    = 'XYZ'
                          carrier_name     = 'My Airline' ).

    APPEND connection TO connections2.

    out->write(  `--------------------------------` ).
    out->write(  `Example 1: APPEND with Work Area` ).
    out->write(  connections2 ).

* Example 2: APPEND with VALUE #( ) expression
**********************************************************************

    APPEND VALUE #( carrier_id       = 'NN'
                    connection_id    = '1234'
                    airport_from_id  = 'ABC'
                    airport_to_id    = 'XYZ'
                    carrier_name     = 'My Airline'
                  )
       TO connections2.

    out->write(  `----------------------------` ).
    out->write(  `Example 2: Append with VALUE` ).
    out->write(  connections2 ).

* Example 3: Filling an Internal Table with Several Rows
**********************************************************************

    carriers = VALUE #(  (  carrier_id = 'AA' carrier_name = 'American Airlines' )
                         (  carrier_id = 'JL' carrier_name = 'Japan Airlines'    )
                         (  carrier_id = 'SQ' carrier_name = 'Singapore Airlines' )
                      ).

    out->write(  `-----------------------------------------` ).
    out->write(  `Example 3: Fill Internal Table with VALUE` ).
    out->write(  carriers ).

* Example 4: Filling one Internal Table from Another
**********************************************************************

    connections2 = CORRESPONDING #( carriers ).

    out->write(  `--------------------------------------------` ).
    out->write(  `Example 4: CORRESPONDING for Internal Tables` ).
    out->write(  data = carriers
                 name = `Source Table CARRIERS:` ).
    out->write(  data = connections2
                 name = `Target Table CONNECTIONS:` ).

  ENDMETHOD.
ENDCLASS.
