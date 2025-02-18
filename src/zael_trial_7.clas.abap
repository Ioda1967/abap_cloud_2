CLASS zael_trial_7 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zael_trial_7 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.


    CONSTANTS c_number TYPE i VALUE 1234.

    SELECT FROM /dmo/carrier
         FIELDS 'Hello'    AS Character,    " Type c
                 1         AS Integer1,     " Type i
                -1         AS Integer2,     " Type i

                @c_number  AS constant      " Type i  (same as constant)

          INTO TABLE @DATA(result).

    out->write(
      EXPORTING
        data   = result
        name   = 'RESULT'
    ).



    SELECT FROM /dmo/carrier
         FIELDS '19891109'                           AS char_8,
                CAST( '19891109' AS CHAR( 4 ) )      AS char_4,
                CAST( '19891109' AS NUMC( 8  ) )     AS numc_8,

                CAST( '19891109' AS INT4 )          AS integer,
                CAST( '19891109' AS DEC( 10, 2 ) )  AS dec_10_2,
                CAST( '19891109' AS FLTP )          AS fltp,

                CAST( '19891109' AS DATS )          AS date

           INTO TABLE @DATA(result2).

    out->write(
      EXPORTING
        data   = result2
        name   = 'RESULT2'
    ).


    SELECT FROM /dmo/customer
         FIELDS customer_id,
                title,
                CASE title
                  WHEN 'Mr.'  THEN 'Mister'
                  WHEN 'Mrs.' THEN 'Misses'
                  ELSE             ' '
               END AS title_long

        WHERE country_code = 'AT'
         INTO TABLE @DATA(result_simple).

    out->write(
      EXPORTING
        data   = result_simple
        name   = 'RESULT_SIMPLE'
    ).

**********************************************************************

    SELECT FROM /DMO/flight
         FIELDS flight_date,
                seats_max,
                seats_occupied,
                CASE
                  WHEN seats_occupied < seats_max THEN 'Seats Avaliable'
                  WHEN seats_occupied = seats_max THEN 'Fully Booked'
                  WHEN seats_occupied > seats_max THEN 'Overbooked!'
                  ELSE                                 'This is impossible'
                END AS Booking_State

          WHERE carrier_id    = 'LH'
            AND connection_id = '0400'
           INTO TABLE @DATA(result_complex).

    out->write(
      EXPORTING
        data   = result_complex
        name   = 'RESULT_COMPLEX'
    ).

********************************************************************************************************************************************
    SELECT FROM /dmo/flight
            FIELDS seats_max,
                   seats_occupied,

                   seats_max - seats_occupied           AS seats_avaliable,

                   (   CAST( seats_occupied AS FLTP )
                     * CAST( 100 AS FLTP )
                   ) / CAST(  seats_max AS FLTP )       AS percentage_fltp

              WHERE carrier_id = 'LH' AND connection_id = '0400'
               INTO TABLE @DATA(result4).

    out->write(
      EXPORTING
        data   = result4
        name   = 'RESULT4'
    ).

**********************************************************************
    SELECT FROM /dmo/flight
          FIELDS carrier_id,
                 connection_id,
                 flight_date,
                 seats_max - seats_occupied AS seats
*           WHERE carrier_id     = 'AA'
*             AND plane_type_id  = 'A320-200'
*       ORDER BY seats_max - seats_occupied DESCENDING,
*                flight_date                ASCENDING
            INTO TABLE @DATA(result5).

    out->write(
      EXPORTING
        data   = result5
        name   = 'RESULT5'
    ).

    SELECT FROM /dmo/flight
           FIELDS carrier_id,
                  connection_id,
                  flight_date,
                  seats_max - seats_occupied AS seats
*           WHERE carrier_id     = 'AA'
*             AND plane_type_id  = 'A320-200'
       ORDER BY seats_max - seats_occupied DESCENDING,
                flight_date                ASCENDING
             INTO TABLE @DATA(result6).

    out->write(
      EXPORTING
        data   = result6
        name   = 'RESULT6'
    ).
**********************************************************************
    SELECT FROM /dmo/connection
        FIELDS  DISTINCT
               airport_from_id,
               distance_unit

      ORDER BY airport_from_id
          INTO TABLE @DATA(result7).

    out->write(
      EXPORTING
        data   = result7
        name   = 'RESULT7'
    ).
**********************************************************************


    SELECT FROM /dmo/connection
         FIELDS carrier_id,
                connection_id,
                airport_from_id,
                distance
*          WHERE carrier_id = 'LH'
           INTO TABLE @DATA(result_raw).


    out->write(
      EXPORTING
        data   = result_raw
        name   = 'RESULT_RAW'
    ).

*********************************************************************

    SELECT FROM /dmo/connection
         FIELDS MAX( distance ) AS max,
                MIN( distance ) AS min,
                SUM( distance ) AS sum,
                AVG( distance ) AS average,
                COUNT( * ) AS count,
                COUNT( DISTINCT airport_from_id ) AS count_dist

*          WHERE carrier_id = 'LH'
           INTO TABLE @DATA(result_aggregate2).

    out->write(
      EXPORTING
        data   = result_aggregate2
        name   = 'RESULT_AGGREGATED2'
    ).

*********************************************************************
    SELECT FROM /dmo/connection
         FIELDS
                carrier_id,
                MAX( distance ) AS max,
                MIN( distance ) AS min,
                SUM( distance ) AS sum,
                COUNT( * ) AS count

         GROUP BY carrier_id
         INTO TABLE @DATA(result9).

    out->write(
      EXPORTING
        data   = result9
        name   = 'RESULT9'
    ).

*********************************************************************

    TYPES t_flights TYPE STANDARD TABLE OF /dmo/flight
                    WITH NON-UNIQUE KEY carrier_id connection_id flight_date.

    DATA  flights TYPE t_flights.

    flights = VALUE #( ( client        = sy-mandt
                         carrier_id    = 'LH'
                         connection_id = '0400'
                         flight_date = '20230201'
                         plane_type_id = '747-400'
                         price = '600'
                         currency_code = 'EUR' )
                       ( client = sy-mandt
                         carrier_id = 'LH'
                         connection_id = '0400'
                         flight_date = '20230115'
                         plane_type_id = '747-400'
                         price = '600' currency_code = 'EUR' )
                       ( client = sy-mandt
                         carrier_id = 'QF'
                         connection_id = '0006'
                         flight_date = '20230112'
                         plane_type_id = 'A380'
                         price = '1600' currency_code = 'AUD' )
                       ( client = sy-mandt
                         carrier_id = 'AA'
                         connection_id = '0017'
                         flight_date = '20230110'
                         plane_type_id = '747-400'
                         price = '600'
                         currency_code = 'USD' )
                       ( client = sy-mandt
                         carrier_id = 'UA'
                         connection_id = '0900'
                         flight_date = '20230201'
                         plane_type_id = '777-200'
                         price = '600'
                         currency_code = 'USD' )
                     ).

    out->write( 'Contents Before Sort' ).
    out->write( '____________________' ).
    out->write( flights ).
    out->write( ` ` ).


* Sort with no additions - sort by primary table key carrier_id connection_id flight_date

    SORT flights.

    out->write( 'Effect of SORT with no additions - sort by primary table key' ).
    out->write( '____________________________________________________________' ).
    out->write( flights ).
    out->write( ` ` ).


* Sort with field list - default sort direction is ascending

    SORT flights BY currency_code plane_type_id.

    out->write( 'Effect of SORT with field list - ascending is default direction' ).
    out->write( '________________________________________________________________' ).
    out->write( flights ).
    out->write( ` ` ).


* Sort with field list and sort directions.
    SORT flights BY carrier_Id ASCENDING flight_Date DESCENDING.

    out->write( 'Effect of SORT with field list and sort direction' ).
    out->write( '_________________________________________________' ).
    out->write( flights ).
    out->write( ` ` ).

*****************************************************************************

    TYPES: BEGIN OF t_results,
             occupied TYPE /dmo/plane_seats_occupied,
             maximum  TYPE /dmo/plane_seats_max,
           END OF t_results.


    TYPES: BEGIN OF t_results_with_Avg,
             occupied TYPE /dmo/plane_seats_occupied,
             maximum  TYPE /dmo/plane_seats_max,
             average  TYPE p LENGTH 16 DECIMALS 2,
           END OF t_results_with_avg.


    DATA flights2 TYPE TABLE OF /dmo/flight.
    SELECT FROM /dmo/flight FIELDS * INTO TABLE @flights2.


* Result is a scalar data type
    DATA(sum) =
     REDUCE i( INIT total = 0
               FOR line IN flights2
               NEXT total += line-seats_occupied ).
    out->write( 'Result is a scalar data type' ).
    out->write( '_____________ ______________' ).
    out->write( sum ).
    out->write( ` ` ).


* Result is a structured data type
    DATA(results) =
     REDUCE t_results( INIT totals TYPE t_results
                       FOR line IN flights2
                       NEXT totals-occupied += line-seats_occupied
                            totals-maximum  += line-seats_max ).
    out->write( 'Result is a structure' ).
    out->write( '_____________________' ).
    out->write( results ).
    out->write( ` ` ).


* Result is a structured data type
* Reduction uses a local helper variable
* Result of the reduction is always the *first* variable declared after init
    out->write( 'Result is a structure. The average is calculated using a local helper variable' ).
    out->write( '______________________________________________________________________________' ).


    DATA(result_with_Average) =
     REDUCE t_results_with_avg( INIT totals_avg TYPE t_results_with_avg count = 1
                                FOR line IN flights2
                                NEXT totals_Avg-occupied += line-seats_occupied
                                     totals_avg-maximum += line-seats_max
                                     totals_avg-average = totals_avg-occupied / count
                                     count += 1 ).
    out->write( result_with_average ).



  ENDMETHOD.
ENDCLASS.
