CLASS lhc_zr_arestful_ael DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR Flights
        RESULT result,

      checksemanticKey FOR VALIDATE ON SAVE
        IMPORTING keys FOR Flights~checksemanticKey,

      GetCities FOR DETERMINE ON SAVE
        IMPORTING keys FOR Flights~GetCities.

ENDCLASS.

CLASS lhc_zr_arestful_ael IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD checksemanticKey.

    DATA read_keys   TYPE TABLE FOR READ IMPORT zr_arestful_ael.
    DATA Flightss    TYPE TABLE FOR READ RESULT zr_arestful_ael.

    read_keys = CORRESPONDING #( keys ).

*   Esta es la sentencia de EML para leer los datos que se han grabado
*   arriba se han definido las tablas para leer el import
    READ ENTITIES OF zr_arestful_ael IN LOCAL MODE
           ENTITY Flights
           FIELDS ( uuid CarrierID ConnectionID )
             WITH read_keys
           RESULT Flightss.

*   Tenemos los nuevos registros y vamos a ver si existen ya en
*    la tabla real o la de draft
    LOOP AT flightss INTO DATA(fl).

      SELECT FROM zarestful_ael
        FIELDS uuid
        WHERE  carrier_id    =  @fl-carrierId
          AND  connection_id =  @fl-ConnectionId
          AND  uuid          <> @fl-Uuid

*     select union, leer de dos tablas seguidas y dejar en una
       UNION

       SELECT FROM zarestful_ael_d
        FIELDS uuid
        WHERE  carrierid     =  @fl-carrierId
          AND  connectionid  =  @fl-ConnectionId
          AND  uuid          <> @fl-Uuid

          INTO TABLE @DATA(check_result).

*     si enuentra algo qes que ya hay registros con esa clave
      IF check_result IS NOT INITIAL.
*       Debemos mandar el mensaje usando la reported estructure
        DATA(message) = me->new_message(
                             id = 'ZAEL_MESS'
                             number = '001'
                             severity = ms-error
                             v1       = fl-carrierId
                             v2       = fl-ConnectionId ).
*       Para mandar el mensaje lo tenemos que meter en la tabla de resultados
        DATA: reported_record LIKE LINE OF reported-flights.
        reported_record-%tky = fl-%tky.
        reported_record-%msg = message.
        reported_record-%element-CarrierID    = if_abap_behv=>mk-on.
        reported_record-%element-connectionid = if_abap_behv=>mk-on.
        APPEND reported_record TO reported-flights.


*      Tenemos que avisar de que no cree los que ya existen, usamos failed structure
        DATA: failed_record LIKE LINE OF failed-flights.
        failed_record-%tky = fl-%tky.

        APPEND failed_record TO failed-flights.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD GetCities.

*   Esta es la sentencia de EML para leer los datos que se han grabado
*   la definición del destino es inline
    READ ENTITIES OF zr_arestful_ael IN LOCAL MODE
           ENTITY Flights
           FIELDS ( AirportFromID AirportToID )
             WITH CORRESPONDING #(  keys )
           RESULT DATA(Flightss).

*   Relleno la tabla leida con los valores determinados
    LOOP AT flightss INTO DATA(wfl).
      SELECT SINGLE
       FROM /dmo/i_airport
       FIELDS City, CountryCode
       WHERE AirportID = @wfl-AirportFromID
       INTO ( @wfl-CityTo, @wfl-CountryTo ).
      SELECT SINGLE
       FROM /dmo/i_airport
       FIELDS City, CountryCode
       WHERE AirportID = @wfl-AirportToID
       INTO ( @wfl-CityTo, @wfl-CountryTo ).
      MODIFY flightss FROM wfl.
    ENDLOOP.

* Defino una tabla para el update
    DATA : flights_upd TYPE TABLE FOR UPDATE zr_arestful_ael.
    flights_upd = CORRESPONDING #(  flightss ).

*  Con modify entities confirmo los cambios
    MODIFY ENTITIES OF zr_arestful_ael IN LOCAL MODE
      ENTITY flights
      UPDATE
      FIELDS ( CityTo CountryTo CityFrom CountryFrom )
      WITH flights_upd
      REPORTED DATA(reported_records).

    reported-flights = CORRESPONDING #( reported_records-flights ).


  ENDMETHOD.

ENDCLASS.
